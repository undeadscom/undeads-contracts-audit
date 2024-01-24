// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "../utils/GuardExtension.sol";

contract UDSToken is ERC20, ERC20Burnable, GuardExtension {
    constructor(uint256 initialSupply, address rights_)
        ERC20("UndeadServiceToken", "UDS")
        GuardExtension(rights_)
    {
        _mint(address(this), initialSupply);
    }

    /**
    @notice transfer the funds from the minter to target
    @param target_ The address of the receiver
    @param amount_ The funds amount
    @return bool true
    */
    function transferTo(address target_, uint256 amount_)
        external
        haveRights
        returns (bool)
    {
        _transfer(address(this), target_, amount_);
        return true;
    }
}
