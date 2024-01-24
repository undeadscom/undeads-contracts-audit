// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IRights.sol";

/// @title A rights access contract
/// @author Ilya A. Shlyakhovoy
/// @notice This contract manage all access rights for the contracts

contract Rights is AccessControl, Ownable, IRights {
    /// @notice available only for Rights admin
    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Rights: Admin area");
        _;
    }

    /// @notice constructor
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function packAddress(address contract_) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(contract_));
    }

    /**
@notice Add a new admin for the Rigths contract
@param admin_ New admin address
*/

    function addAdmin(address admin_) external override onlyAdmin {
        _setupRole(DEFAULT_ADMIN_ROLE, admin_);
        emit AdminAdded(admin_);
    }

    /**
@notice Add a new admin for the any other contract
@param contract_ Contract address packed into address
@param admin_ New admin address
*/

    function addAdmin(address contract_, address admin_)
        external
        override
        onlyAdmin
    {
        require(address(this) != contract_, "Rights: cannot set this contract");
        _setupRole(packAddress(contract_), admin_);
        emit AdminDefined(admin_, contract_);
    }

    /**
@notice Remove the existing admin from the Rigths contract
@param admin_ Admin address
*/

    function removeAdmin(address admin_) external override onlyAdmin {
        require(msg.sender != admin_, "Rights: cannot clear itself");
        _revokeRole(DEFAULT_ADMIN_ROLE, admin_);
        emit AdminRemoved(admin_);
    }

    /**
@notice Remove the existing admin from the specified contract
@param contract_ Contract address packed into address
@param admin_ Admin address
*/

    function removeAdmin(address contract_, address admin_)
        external
        override
        onlyAdmin
    {
        require(address(this) != contract_, "Rights: cannot this contract");
        require(msg.sender != admin_, "Rights: cannot clear itself");
        _revokeRole(packAddress(contract_), admin_);
        emit AdminCleared(admin_, contract_);
    }

    /**
@notice Get the rights for the contract for the caller
@param contract_ Contract address packed into address
@return have rights or not
*/
    function haveRights(address contract_)
        external
        view
        override
        returns (bool)
    {
        return hasRole(packAddress(contract_), msg.sender);
    }

    /**
@notice Get the rights for the contract
@param contract_ Contract address packed into address
@param admin_ Admin address
@return have rights or not
*/
    function haveRights(address contract_, address admin_)
        external
        view
        override
        returns (bool)
    {
        return hasRole(packAddress(contract_), admin_);
    }
}
