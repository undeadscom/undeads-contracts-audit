// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "../upgradeable/utils/GuardExtensionUpgradeable.sol";
import "../lib/Structures.sol";
import "./interfaces/IBenefits.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title A rights access contract
/// @author Ilya A. Shlyakhovoy
/// @notice This contract manage all user's benefits

contract Benefits is IBenefits, GuardExtensionUpgradeable {
    using BitMaps for BitMaps.BitMap;
    using Counters for Counters.Counter;
    Counters.Counter private _ids;
    Counters.Counter private _deletedIds;
    BitMaps.BitMap private _used;
    mapping(address => Structures.Benefit[]) private _benefits;
    mapping(address => uint256) private _receiverIds;
    mapping(uint256 => address) private _receivers;

    // mapping(bytes32 => mapping(uint256 => uint256)) private _locked;
    string private constant ALREADY_SET = "Benefits: id already set";
    string private constant WRONG_TARGET = "Benefits: wrong target";
    string private constant OVERUSAGE = "Benefits: used more than have";

    mapping(address => mapping(uint256 => uint256)) private _additionalIssued;

    /// @notice constructor
    function initialize(address rights_) public initializer {
        __GuardExtensionUpgradeable_init(rights_);
    }

    function addBatch(
        address[] calldata targets_,
        uint256[] calldata prices_,
        uint16[] calldata ids_,
        uint16[] calldata amounts_,
        uint8[] calldata levels_,
        uint256[] calldata froms_,
        uint256[] calldata untils_
    ) external haveRights {
        for (uint256 i = 0; i < targets_.length; i++) {
            _add(
                targets_[i],
                prices_[i],
                ids_[i],
                amounts_[i],
                levels_[i],
                froms_[i],
                untils_[i]
            );
        }
    }

    /**
@notice Add a benefit
@param target_ target address 
@param price_ Price of the token
@param id_ The token id 
@param amount_ The tokens amount
@param level_ The locked tokens level
@param from_ The timestamp of start of rule usage
@param until_ The timestamp of end of rule usage
*/
    function add(
        address target_,
        uint256 price_,
        uint16 id_,
        uint16 amount_,
        uint8 level_,
        uint256 from_,
        uint256 until_
    ) external override haveRights {
        _add(target_, price_, id_, amount_, level_, from_, until_);
    }

    function _add(
        address target_,
        uint256 price_,
        uint16 id_,
        uint16 amount_,
        uint8 level_,
        uint256 from_,
        uint256 until_
    ) private {
        require(!_used.get(id_), ALREADY_SET);
        if (_receiverIds[target_] == 0) {
            _ids.increment();
            _receiverIds[target_] = _ids.current();
            _receivers[_ids.current()] = target_;
        }
        _benefits[target_].push(
            Structures.Benefit(price_, from_, until_, id_, amount_, level_, 0)
        );
        if (id_ > 0) {
            _used.set(id_);
        }
        emit BenefitAdded(target_, from_, until_, price_, id_, amount_, level_);
    }

    /**
@notice Clear user's benefits for the contract 
@param target_ target address 
*/
    function clear(address target_) external override haveRights {
        if (_receiverIds[target_] > 0) {
            _deletedIds.increment();
            delete _receivers[_receiverIds[target_]];
            delete _receiverIds[target_];
        }
        if (_benefits[target_].length > 0) {
            for (uint256 i = 0; i < _benefits[target_].length; i++) {
                if (_benefits[target_][i].id > 0) {
                    _used.unset(_benefits[target_][i].id);
                }
            }
        }
        delete _benefits[target_];
        emit BenefitsCleared(target_);
    }

    /**
@notice Check if denied to buy an nft with specific id for specific target address
@param current_ current id 
*/
    function denied(uint256 current_) external view returns (bool) {
        if (_used.get(current_)) return true; // this item is not denied
        return false; // any other case - allowed
    }

    /**
@notice Get available user benefit 
@param target_ target address 
@param current_ current tested token id
@param price_ the received price
@return benefit id, benefit price, benefit token id, benefit level  (all items can be 0)
*/
    function get(
        address target_,
        uint256 current_,
        uint256 price_
    )
        external
        view
        override
        returns (
            address,
            uint256,
            uint256,
            uint16,
            uint8,
            bool
        )
    {
        (
            address target,
            uint256 id,
            uint256 price,
            uint16 tokenId,
            uint8 level,
            bool isFound
        ) = _get(target_, current_, price_);

        if (target == address(0)) {
            return _get(target, current_, price_);
        }
        return (target, id, price, tokenId, level, isFound);
    }

    function _get(
        address target_,
        uint256 current_,
        uint256 price_
    )
        internal
        view
        returns (
            address,
            uint256,
            uint256,
            uint16,
            uint8,
            bool // bennefit found
        )
    {
        if (_benefits[target_].length == 0)
            return (address(0), 0, 0, 0, 0, false);
        uint256 i = 0;
        for (; i < _benefits[target_].length; i++) {
            if (
                _benefits[target_][i].from <= block.timestamp &&
                (_benefits[target_][i].until == 0 ||
                    _benefits[target_][i].until >= block.timestamp) &&
                (_benefits[target_][i].amount >
                    _benefits[target_][i].issued +
                        _additionalIssued[target_][i]) &&
                (_benefits[target_][i].id == 0 ||
                    _benefits[target_][i].id >= current_) &&
                price_ == _benefits[target_][i].price
            ) {
                return (
                    target_,
                    i,
                    _benefits[target_][i].price,
                    _benefits[target_][i].id,
                    _benefits[target_][i].level,
                    true
                );
            }
        }
        return (address(0), 0, 0, 0, 0, false);
    }

    /** 
@notice Set user benefit 
@param target_ target address 
@param id_ benefit id
*/
    function set(address target_, uint256 id_) external override haveRights {
        require(_benefits[target_].length > id_, WRONG_TARGET);
        require(
            _benefits[target_][id_].amount >
                (_benefits[target_][id_].issued +
                    _additionalIssued[target_][id_]),
            OVERUSAGE
        );
        if (_benefits[target_][id_].issued < 254) {
            _benefits[target_][id_].issued = _benefits[target_][id_].issued + 1;
        } else {
            _additionalIssued[target_][id_] =
                _additionalIssued[target_][id_] +
                1;
        }
        emit BenefitUsed(target_, id_);
    }

    /**
@notice Read specific benefit 
@param target_ target address 
@param id_  benefit id
@return benefit 
*/
    function read(address target_, uint256 id_)
        external
        view
        override
        returns (Structures.Benefit memory)
    {
        require(_benefits[target_].length > id_, WRONG_TARGET);
        return _benefits[target_][id_];
    }

    /**
@notice Read total count of users received benefits 
@return count 
*/
    function totalReceivers() external view override returns (uint256) {
        return _ids.current() - _deletedIds.current() - 1;
    }

    /**
@notice Read list of the addresses received benefits 
@return addresses  
*/
    function listReceivers() external view override returns (address[] memory) {
        address[] memory out = new address[](
            _ids.current() - _deletedIds.current() - 1
        );
        uint256 counter = 0;
        uint256 total = _ids.current();
        for (uint256 i = 1; i <= total; i++) {
            if (_receivers[i] != address(0)) {
                out[counter] = _receivers[i];
                counter = counter + 1;
            }
        }
        return out;
    }
}
