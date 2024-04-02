// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
* @title GamePool
* @notice The contract is used for the exchange Game Points to UDS token
*/
interface IGamePool {

    event Claimed(uint256 indexed claimId, address indexed recipient, uint256 amount, address token);
    event ClaimCancelled(uint256 indexed claimId);
    event LimitsUpdate(address[] tokens, uint256[] limits);
    event PermitterUpdate(address permitter);
    
    /**
    * @notice Get claim limit for the selected token
    * @param token_ The address of ERC20 token
    */
    function getLimit(address token_) external view returns(uint256);

    /**
    * @notice Get the pool balance
    * @param token_ The address of ERC20 token
    */
    function getPoolBalance(IERC20 token_) external view returns(uint256);

    /**
    * @notice Claim tokens
    * @param amount_ The claimed amount
    * @param token_ The address of token to claim
    * @param claimId_ The claim id
    * @param expiresAt_ Signature expiration date
    * @param permitterSignature_ The data signature
    */
    function claim(
        uint256 amount_,
        IERC20 token_,
        uint256 claimId_,
        uint256 expiresAt_,
        bytes calldata permitterSignature_
    ) external;

    /**
    * @notice Claim tokens
    * @param amount_ The claimed amount
    * @param token_ The address of token to claim
    * @param recipient_ The token recipient
    * @param claimId_ The claim id
    * @param expiresAt_ Signature expiration date
    * @param permitterSignature_ The data signature
    */
    function claim(
        uint256 amount_,
        IERC20 token_,
        address recipient_,
        uint256 claimId_,
        uint256 expiresAt_,
        bytes calldata permitterSignature_
    ) external;

    /**
    * @notice Cancel claim
    * @param claimId_ The claim id
    */
    function cancelClaim(uint256 claimId_) external;

    /**
    * @notice Set claim limits for the selected tokens
    * @param tokens_ Addresses of ERC20 tokens
    * @param limits_ Limits for the token claim
    */
    function setLimits(
        address[] calldata tokens_, 
        uint256[] calldata limits_
    ) external;

    /**
    * @notice Set the new permitter address
    * @param permitter_ Ner permitter address
    */
    function setPermitter(address permitter_) external;

    /**
     * @notice It allows the admin to withdraw sent to the contract
     * @param amount_ The number of token amount to withdraw
     * @param token_ The address of token to withdraw
     * @param addressTo_ The token reciever address
     */
    function recover(uint256 amount_, IERC20 token_, address addressTo_) external;
}