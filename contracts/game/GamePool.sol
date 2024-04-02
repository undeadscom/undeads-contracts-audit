// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/Guard.sol";
import "../upgradeable/utils/GuardExtensionUpgradeable.sol";
import "./interface/IGamePool.sol";

/**
 * @title GamePool
 * @notice This contract is used to pay users various tokens using permission from the permitter
 */
contract GamePool is IGamePool, GuardExtensionUpgradeable {
    using BitMaps for BitMaps.BitMap;
    using SafeERC20 for IERC20;

    string private constant CLAIM_COMPLETED =
        "GamePool: Claim completed or cancelled";
    string private constant INVALID_SIGNATURE = "GamePool: Invalid signature";
    string private constant LIMIT_EXCEEDED = "GamePool: Claim limit exceeded";
    string private constant INVALID_INPUT = "GamePool: Invalid input";
    string private constant SIGNATURE_EXPIRED = "GamePool: The signature has expired";

    BitMaps.BitMap private _completedClaims;
    mapping(address => uint256) private _claimLimits;
    address private _permitter;

    modifier checkLimit(uint256 amount_, address token_) {
        require(_claimLimits[token_] >= amount_, LIMIT_EXCEEDED);
        _;
    }

    /**
     * @notice constructor
     * @param rights_ The address of the rights
     * @param permitter_ Account whose signature authorizes the claim
     * @param tokens_ Addresses of ERC20 tokens
     * @param limits_ Limits for the token claim
     */
    function initialize(
        address rights_,
        address permitter_,
        address[] calldata tokens_,
        uint256[] calldata limits_
    ) public initializer {
        __GuardExtensionUpgradeable_init(rights_);
        _updateLimits(tokens_, limits_);
        _updatePermitter(permitter_);
    }

    /**
     * @notice Get claim limit for the selected token
     * @param token_ The address of ERC20 token
     */
    function getLimit(address token_) external view override returns (uint256) {
        return _claimLimits[token_];
    }

    /**
     * @notice Get the pool balance
     * @param token_ The address of ERC20 token
     */
    function getPoolBalance(
        IERC20 token_
    ) external view override returns (uint256) {
        return token_.balanceOf(address(this));
    }

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
    ) external override checkLimit(amount_, address(token_)) {
        _claim(
            amount_,
            token_,
            msg.sender,
            claimId_,
            expiresAt_,
            permitterSignature_
        );
    }

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
    ) external override checkLimit(amount_, address(token_)) {
        _claim(
            amount_,
            token_,
            recipient_,
            claimId_,
            expiresAt_,
            permitterSignature_
        );
    }

    /**
     * @notice Cancel claim
     * @param claimId_ The claim id
     */
    function cancelClaim(uint256 claimId_) external override haveRights {
        _completedClaims.set(claimId_);
        emit ClaimCancelled(claimId_);
    }

    /**
     * @notice It allows the admin to withdraw tokens sent to the contract
     * @param amount_ The number of token amount to withdraw
     * @param token_ The address of token to withdraw
     * @param addressTo_ The token reciever address
     */
    function recover(
        uint256 amount_,
        IERC20 token_,
        address addressTo_
    ) external override haveRights {
        token_.safeTransfer(addressTo_, amount_);
    }

    /**
     * @notice Set claim limits for the selected tokens
     * @param tokens_ Addresses of ERC20 tokens
     * @param limits_ Limits for the token claim
     */
    function setLimits(
        address[] calldata tokens_,
        uint256[] calldata limits_
    ) external override haveRights {
        _updateLimits(tokens_, limits_);
    }

    /**
     * @notice Set the new permitter address
     * @param permitter_ Ner permitter address
     */
    function setPermitter(address permitter_) external override haveRights {
        _updatePermitter(permitter_);
    }

    function _claim(
        uint256 amount_,
        IERC20 token_,
        address recipient_,
        uint256 claimId_,
        uint256 expiresAt_,
        bytes calldata permitterSignature_
    ) private {
        _verifySignature(
            amount_,
            token_,
            recipient_,
            claimId_,
            expiresAt_,
            permitterSignature_
        );
        _completedClaims.set(claimId_);

        token_.safeTransfer(recipient_, amount_);

        emit Claimed(claimId_, recipient_, amount_, address(token_));
    }

    function _updateLimits(
        address[] calldata tokens_,
        uint256[] calldata limits_
    ) private {
        require(tokens_.length == limits_.length, INVALID_INPUT);
        for (uint256 i; i < tokens_.length; ++i) {
            _claimLimits[tokens_[i]] = limits_[i];
        }
        emit LimitsUpdate(tokens_, limits_);
    }

    function _updatePermitter(address permitter_) private {
        _permitter = permitter_;
        emit PermitterUpdate(permitter_);
    }

    function _verifySignature(
        uint256 amount_,
        IERC20 token_,
        address recipient_,
        uint256 claimId_,
        uint256 expiresAt_,
        bytes calldata signature_
    ) internal view {
        require(expiresAt_ > block.timestamp, SIGNATURE_EXPIRED);
        require(!_completedClaims.get(claimId_), CLAIM_COMPLETED);
        bytes32 dataHash = keccak256(
            abi.encode(amount_, token_, recipient_, claimId_, expiresAt_)
        );
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(dataHash);
        address signer = ECDSA.recover(ethSignedMessageHash, signature_);
        require(signer == _permitter, INVALID_SIGNATURE);
    }
}
