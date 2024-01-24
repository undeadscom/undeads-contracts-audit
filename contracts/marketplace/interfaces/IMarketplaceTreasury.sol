// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "../../utils/interfaces/IClaimableFunds.sol";

interface IMarketplaceTreasury is IClaimableFunds {
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
    ) external;

    /*
     * @notice Method for aproving/disaproving payment method
     * @param paymantAddress_ address of the erc20 token or 0x0 for eth
     * @param enabled_ enable/disabled
     */
    function approvePayment(address paymantAddress_, bool enabled_) external;

    /*
     * @notice Method checking payment method if it is supported
     */
    function isPaymentAssetApproved(
        address paymentAsset_
    ) external view returns (bool);
}
