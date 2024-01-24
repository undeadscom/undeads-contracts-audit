// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

interface IRouter {
    event AddressChanged(string name_, address address_);

    /**
@notice Set the address of the contract
@param name_ Contract name
@param address_ Contract address
*/

    function setAddress(string memory name_, address address_) external;

    /**
@notice The address of the contract 
@param name_ Contract name
@return The current address
*/

    function getAddress(string memory name_) external view returns (address);
}
