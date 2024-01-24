// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IRouter.sol";

/// @title The router contract
/// @author Ilya A. Shlyakhovoy
/// @notice This contract contains the list of addresses of another contracts of the project,
/// addressed by their names

contract Router is Ownable, IRouter {
    mapping(bytes32 => address) private _addresses;

    /// @notice constructor
    constructor() Ownable() {}

    /**
@notice Set the address of the contract
@param name_ Contract name
@param address_ Contract address
*/

    function setAddress(string memory name_, address address_)
        external
        override
        onlyOwner
    {
        _addresses[keccak256(abi.encodePacked(name_))] = address_;
        emit AddressChanged(name_, address_);
    }

    /**
@notice The address of the contract 
@param name_ Contract name
@return The current address
*/

    function getAddress(string memory name_)
        external
        view
        override
        returns (address)
    {
        return _addresses[keccak256(abi.encodePacked(name_))];
    }
}
