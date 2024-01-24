// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../../utils/interfaces/IClaimableFunds.sol";
import "../../utils/Guard.sol";

abstract contract ClaimableUpgradeable is
    Guard,
    ReentrancyGuardUpgradeable,
    IClaimableFunds
{
    function __ClaimableUpgradeable_init() internal onlyInitializing {
        __ReentrancyGuard_init();
    }

    /**
    @notice Returns the amount of funds available to claim
    @param asset_ Asset to withdraw, 0x0 - is native coin (eth)
    */
    function availableToClaim(
        address, /*owner_*/
        address asset_
    ) external view returns (uint256) {
        if (asset_ == address(0x0)) {
            return address(this).balance;
        } else {
            return IERC20(asset_).balanceOf(address(this));
        }
    }

    /**
    @notice Claim funds
    @param asset_ Asset to withdraw, 0x0 - is native coin (eth)
    @param target_ The target for the withdrawal 
    @param amount_ The amount of 
    */
    function claimFunds(
        address asset_,
        address payable target_,
        uint256 amount_
    ) external haveRights nonReentrant {
        if (asset_ == address(0x0)) {
            (bool sent, ) = target_.call{value: amount_}("");
            require(sent, "Can't sent");
        } else {
            IERC20(asset_).transfer(target_, amount_);
        }
    }
}
