// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity 0.8.17;

contract BatchBalance {
    /**
    @notice Get balances for all address provided in the @addresses_ param
    @param addresses_ List of addresses
     */
    function balanceOf(address[] calldata addresses_)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory balances = new uint256[](addresses_.length);
        for (uint256 index = 0; index < addresses_.length; index++) {
            balances[index] = addresses_[index].balance;
        }
        return balances;
    }
}
