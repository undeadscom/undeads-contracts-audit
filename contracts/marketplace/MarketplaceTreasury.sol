// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../utils/GuardExtension.sol";
import "./interfaces/IMarketplaceTreasury.sol";

contract MarketplaceTreasury is
    IMarketplaceTreasury,
    ReentrancyGuard,
    GuardExtension
{
    struct PaymentAsset {
        uint256 price;
        address paymentAsset;
    }

    modifier onlyAllowedPayment(address paymentAsset_) {
        require(_approvedPayments[paymentAsset_], "Payment not approved");
        _;
    }

    // userAddress => assetAddress => amount
    mapping(address => mapping(address => uint256)) private _balances;

    /*
     * @notice Method for listing NFT
     * assetAddress as 0 - is eth
     */
    mapping(address => bool) private _approvedPayments;

    /**
     * @notice Constructor
     */
    constructor(address rights_) GuardExtension(rights_) {}

    /*
     * @notice Method top up user's balance
     * @param paymentAsset_ what type of balance should be increased
     * @param beneficiar_ whose balance will be increased
     * @param amount_ amount of tokens that will be added
     */
    function addFunds(
        address paymentAsset_,
        address beneficiar_,
        uint256 amount_
    ) external haveRights onlyAllowedPayment(paymentAsset_) {
        _balances[beneficiar_][paymentAsset_] += amount_;
    }

    /*
     * @notice Method for aproving/disaproving payment method
     * @param paymantAddress_ address of the erc20 token or 0x0 for eth
     * @param enabled_ enable/disabled
     */
    function approvePayment(
        address paymantAddress_,
        bool enabled_
    ) external nonReentrant haveRights {
        require(
            paymantAddress_ == address(0x0) ||
                IERC20(paymantAddress_).totalSupply() > 0,
            "Not valid paymentMethod"
        );
        _approvedPayments[paymantAddress_] = enabled_;
    }

    /**
    @notice Returns the amount of funds available to claim
    @param asset_ Asset to check balance, 0x0 - is native coin (eth)
    */
    function availableToClaim(
        address owner_,
        address asset_
    ) external view returns (uint256) {
        return _balances[owner_][asset_];
    }

    /**
    @notice Claim funds
    @param asset_ Asset to withdraw, 0x0 - is native coin (eth)
    @param target_ The target for the withdrawal 
    @param amount_ Amount of tokens to withdraw
    */
    function claimFunds(
        address asset_,
        address payable target_,
        uint256 amount_
    ) external nonReentrant {
        uint256 balance = _balances[msg.sender][asset_];
        require(balance > 0, "Zero balance");
        require(balance >= amount_, "Not enought balance");
        _balances[msg.sender][asset_] = _balances[msg.sender][asset_] - amount_;

        if (asset_ == address(0x0)) {
            (bool success, ) = payable(target_).call{value: amount_}("");
            require(success, "Transfer failed");
        } else {
            bool success = IERC20(asset_).transfer(msg.sender, amount_);
            require(success, "Transfer failed");
        }
    }

    /*
     * @notice Method checking payment method
     */
    function isPaymentAssetApproved(
        address paymentAsset_
    ) external view returns (bool) {
        return _approvedPayments[paymentAsset_];
    }
}
