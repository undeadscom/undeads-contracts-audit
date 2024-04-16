// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy, Dmitry Kharlanchuk
// Email: is@unicsoft.com, kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/GuardExtension.sol";

/*
 @title The vesting tokens contract
 @author Ilya A. Shlyakhovoy
 @notice This contract distributes the tokens according rules
*/
contract Vesting is GuardExtension, Pausable {
    using BitMaps for BitMaps.BitMap;
    using SafeERC20 for IERC20;

    address private _token;
    mapping(uint256 => bytes32) private _roots;
    
    mapping(address => mapping(uint256 => BitMaps.BitMap)) private _claimedBitMaps;
    event RootUpdated(uint256 indexed key_, bytes32 indexed value_);
    event TokenUpdated(address indexed token);
    event Claimed(
        address indexed client_,
        uint256 indexed key_,
        uint256 indexed intervalTimestamp_,
        uint256 amount_
    );

    event IntervalUpdated(
        uint256 indexed key_,
        uint256 indexed intervalTimestamp_
    );

    /// @notice constructor
    constructor(
        address rights_,
        address token_
    ) GuardExtension(rights_) {
        _token = token_;
        emit TokenUpdated(token_);
    }

    /**
    @notice Pause distribution
    */
    function pause() external haveRights {
        if (!paused()) {
            _pause();
        }
    }

    /**
    @notice Continue distribution
    */

    function unpause() external haveRights {
        if (paused()) {
            _unpause();
        }
    }

    /**
    @notice Set the token for the distribution
    @param token_ New token address
    */
    function updateToken(address token_) external haveRights {
        require(token_ != address(0), "Zero address");
        _token = token_;
        emit TokenUpdated(token_);
    }

    /**
    @notice Get the token address
    @return The address of the token
    */
    function token() external view returns (address) {
        return _token;
    }

    /**
    @notice Set or update a root
    @param key_ Root key
    @param value_ New root value
    */
    function updateRoot(uint256 key_, bytes32 value_) external haveRights {
        _roots[key_] = value_;
        emit RootUpdated(key_, value_);
    }

    /**
    @notice Get a root value
    @param key_ Root key
    @return The value of the key (or zeroes if the root is not defined)
    */
    function root(uint256 key_) external view returns (bytes32) {
        return _roots[key_];
    }

    /**
    @notice Claim the current vesting amount for the caller
    @param key_ Root key
    @param intervalId_ The id of the current vesting interval
    @param intervalTimestamp_ The timestamp of the current vesting interval
    @param amount_ The claimed amount
    @param merkleProof_ The part of the merkle tree used for the claiming person
    */
    function claim(
        uint256 key_,
        uint256 intervalId_,
        uint256 intervalTimestamp_,
        uint256 amount_,
        bytes32[] calldata merkleProof_
    ) external whenNotPaused {
        _claim(
            msg.sender,
            key_,
            intervalId_,
            intervalTimestamp_,
            amount_,
            merkleProof_
        );
    }

    /**
    @notice Claim the current vesting amount for the any address
    @param client_ The address of the claimer
    @param key_ Root key
    @param intervalId_ The id of the current vesting interval
    @param intervalTimestamp_ The id of the current vesting interval
    @param amount_ The claimed amount
    @param merkleProof_ The part of the merkle tree used for the claiming person
    */
    function claim(
        address client_,
        uint256 key_,
        uint256 intervalId_,
        uint256 intervalTimestamp_,
        uint256 amount_,
        bytes32[] calldata merkleProof_
    ) external whenNotPaused {
        _claim(
            client_,
            key_,
            intervalId_,
            intervalTimestamp_,
            amount_,
            merkleProof_
        );
    }

    function _claim(
        address client_,
        uint256 key_,
        uint256 intervalId_,
        uint256 intervalTimestamp_,
        uint256 amount_,
        bytes32[] calldata merkleProof_
    ) internal {
        require(
            !_isClaimed(client_, key_, intervalId_),
            "Vesting: already claimed"
        );
        require(
            intervalTimestamp_ <= block.timestamp,
            "Vesting: too early for claim"
        );

        bytes32 node = keccak256(
            abi.encodePacked(
                client_,
                key_,
                intervalId_,
                intervalTimestamp_,
                amount_
            )
        );

        require(
            MerkleProof.verify(merkleProof_, _roots[key_], node),
            "Vesting: invalid proof"
        );

        _setClaimed(client_, key_, intervalId_);

        emit Claimed(client_, key_, intervalTimestamp_, amount_);

        IERC20(_token).safeTransfer(client_, amount_);
    }

    /**
    @notice Checks if already claimed
    @param client_ The address of the claimer
    @param key_ Root key
    @param intervalId_ The claimed amount
    */
    function _isClaimed(
        address client_,
        uint256 key_,
        uint256 intervalId_
    ) internal view returns (bool) {
        return _claimedBitMaps[client_][key_].get(intervalId_);
    }

    function isClaimed(
        address client_,
        uint256 key_,
        uint256 intervalId_
    ) external view returns (bool) {
        return _isClaimed(client_, key_, intervalId_);
    }

    /**
    @notice Checks claims for multiple keys and intervals
    @param client_ The address of the claimer
    @param keys_ Root keys
    @param intervalsIds_ The ids of the vesting interval we want to check
    */
    function isClaimed(
        address client_,
        uint256[] calldata keys_,
        uint256[] calldata intervalsIds_
    ) external view returns (bool[][] memory) {
        bool[][] memory keys = new bool[][](keys_.length);
        for (uint256 k = 0; k < keys_.length; k++) {
            bool[] memory claims = new bool[](intervalsIds_.length);
            for (uint256 i = 0; i < intervalsIds_.length; i++) {
                claims[i] = _isClaimed(client_, keys_[k], intervalsIds_[i]);
            }
            keys[k] = claims;
        }
        return keys;
    }

    function _setClaimed(
        address client_,
        uint256 key_,
        uint256 intervalId_
    ) internal {
        _claimedBitMaps[client_][key_].set(intervalId_);
    }
}
