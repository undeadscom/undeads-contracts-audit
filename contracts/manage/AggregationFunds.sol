// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../utils/interfaces/IClaimableFunds.sol";
import "../upgradeable/utils/GuardExtensionUpgradeable.sol";

contract AggregationFunds is Initializable, GuardExtensionUpgradeable {
    using AddressUpgradeable for address payable;

    string private constant SAME_VALUE = "AgFunds: same value";

    event TransferToHotWallet(address indexed asset, uint256 amount);
    event TransferToColdWallet(address indexed asset, uint256 amount);

    struct Limits {
        uint256 min;
        uint256 max;
    }

    /// @notice only existing asset
    modifier onlySupportedAsset(address asset) {
        require(
            asset == address(0x0) ||
                asset == address(_uds) ||
                asset == address(_ugold),
            "Asset address not supported"
        );
        _;
    }

    /// @notice only if destination wallets are defined
    modifier walletsDefined() {
        require(coldWallet != address(0x0), "Cold wallet not defined");
        require(hotWallet != address(0x0), "Hot wallet not defined");
        _;
    }

    mapping(address => IClaimableFunds[]) public claimableContracts;

    IERC20 private _uds;
    IERC20 private _ugold;
    mapping(address => Limits) private _limits;
    address payable public coldWallet;
    address payable public hotWallet;

    /**
    @notice Constructor
    @param claimableEthContracts_ Contracts that support claim of eth, like mystery box
    @param claimableUDSContracts_ Contracts that support claim of uds marketplace, like mystery box
    @param claimableUGLDContracts_ Contracts that support claim of ugold
    */
    function initialize(
        address[] memory claimableEthContracts_,
        address[] memory claimableUDSContracts_,
        address[] memory claimableUGLDContracts_,
        address rights_,
        address uds_,
        address ugold_
    ) public initializer {
        __GuardExtensionUpgradeable_init(rights_);
        uint256 index = 0;
        for (; index < claimableEthContracts_.length; ) {
            claimableContracts[address(0x0)].push(
                IClaimableFunds(claimableEthContracts_[index])
            );
            unchecked {
                index++;
            }
        }

        index = 0;
        for (; index < claimableUDSContracts_.length; ) {
            claimableContracts[uds_].push(
                IClaimableFunds(claimableUDSContracts_[index])
            );
            unchecked {
                index++;
            }
        }

        index = 0;
        for (; index < claimableUGLDContracts_.length; ) {
            claimableContracts[ugold_].push(
                IClaimableFunds(claimableUGLDContracts_[index])
            );
            unchecked {
                index++;
            }
        }

        _uds = IERC20(uds_);
        _ugold = IERC20(ugold_);
    }

    receive() external payable {}

    /**
    @notice Set addresses that support claim eth interface
    @param contracts_ New addresses
     */
    function setclaimableEthContracts(IClaimableFunds[] calldata contracts_)
        external
        haveRights
    {
        claimableContracts[address(0x0)] = contracts_;
    }

    /**
    @notice Set addresses that support claim ERC20 interface
    @param contracts_ New addresses
     */
    function setclaimableUDSContracts(IClaimableFunds[] calldata contracts_)
        external
        haveRights
    {
        claimableContracts[address(_uds)] = contracts_;
    }

    /**
    @notice Set addresses that support claim ERC20 interface
    @param contracts_ New addresses
     */
    function setclaimableUGLDContracts(IClaimableFunds[] calldata contracts_)
        external
        haveRights
    {
        claimableContracts[address(_ugold)] = contracts_;
    }

    /**
    @notice Set the mystery box contract address
    @param newValue_ address
     */
    function setUgold(IERC20 newValue_) external haveRights {
        _ugold = newValue_;
    }

    /**
    @notice Set the mystery box contract address
    @param newValue_ New address
     */
    function setUds(IERC20 newValue_) external haveRights {
        _uds = newValue_;
    }

    /**
    @notice Set hot wallet address
    @param newValue_ New address
     */
    function setHotWallet(address payable newValue_) external haveRights {
        require(hotWallet != newValue_, SAME_VALUE);
        hotWallet = newValue_;
    }

    /**
    @notice Set cold wallet address
    @param newValue_ New address
     */
    function setColdWallet(address payable newValue_) external haveRights {
        require(coldWallet != newValue_, SAME_VALUE);
        coldWallet = newValue_;
    }

    /**
    @notice Change minimum and maximum values for specific token to be stored on hot wallet to cover tx fees
    @param asset_ Address of token contrac, if addres is zero -> eth
    @param min_ Min critical value of the asset that should be stored on the hot wallet
    @param max_ Amoun of assets have to be sotored on hot wallet
     */
    function setMinMax(
        address asset_,
        uint256 min_,
        uint256 max_
    ) external haveRights onlySupportedAsset(asset_) {
        Limits storage limit = _limits[asset_];
        limit.min = min_;
        limit.max = max_;
    }

    /**
    @notice Get minimum and maximum values for specific token that will be stored on hot wallet to cover tx fees
    @param asset_ Address of token contrac, if addres is zero -> eth
     */
    function getMinMax(address asset_)
        external
        view
        onlySupportedAsset(asset_)
        returns (uint256 min, uint256 max)
    {
        Limits storage limit = _limits[asset_];
        min = limit.min;
        max = limit.max;
    }

    /**
    @notice Get the balance of the assetes available to claim
    @param asset_ to get balance of eth, pass zero (0x0) address
    @return The balance
    */
    function getAvailableBalance(address asset_)
        external
        view
        onlySupportedAsset(asset_)
        returns (uint256)
    {
        uint256 balance = 0;
        IClaimableFunds[] memory contracts = claimableContracts[asset_];
        for (uint256 index = 0; index < contracts.length; ) {
            unchecked {
                balance += contracts[index].availableToClaim(
                    address(this),
                    asset_
                );
                index++;
            }
        }
        return balance;
    }

    /**
    @notice Claim and destribute funds between hot/cold wallets
    */
    function withdraw() external walletsDefined {
        _claimTokens(address(0x0));
        _claimTokens(address(_ugold));
        _claimTokens(address(_uds));

        // ETH
        uint256 contractBalance = address(this).balance;
        uint256 hotWalletBalance = hotWallet.balance;
        uint256 max = _limits[address(0x0)].max;
        if (contractBalance > 0) {
            (
                uint256 toHotWallet,
                uint256 toColdWallet
            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);
            if (toHotWallet > 0) {
                hotWallet.sendValue(toHotWallet);
                emit TransferToHotWallet(address(0x0), toHotWallet);
            }
            if (toColdWallet > 0) {
                coldWallet.sendValue(toColdWallet);
                emit TransferToColdWallet(address(0x0), toColdWallet);
            }
        }

        // UGOLD
        contractBalance = _ugold.balanceOf(address(this));
        if (contractBalance > 0) {
            hotWalletBalance = _ugold.balanceOf(address(hotWallet));
            max = _limits[address(_ugold)].max;

            (
                uint256 toHotWallet,
                uint256 toColdWallet
            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);
            if (toHotWallet > 0) {
                _ugold.transfer(address(hotWallet), toHotWallet);
                emit TransferToHotWallet(address(_ugold), toHotWallet);
            }
            if (toColdWallet > 0) {
                _ugold.transfer(address(coldWallet), toColdWallet);
                emit TransferToColdWallet(address(_ugold), toColdWallet);
            }
        }

        // UDS
        contractBalance = _uds.balanceOf(address(this));
        if (contractBalance > 0) {
            hotWalletBalance = _uds.balanceOf(address(hotWallet));
            max = _limits[address(_uds)].max;

            (
                uint256 toHotWallet,
                uint256 toColdWallet
            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);
            if (toHotWallet > 0) {
                _uds.transfer(address(hotWallet), toHotWallet);
                emit TransferToHotWallet(address(_uds), toHotWallet);
            }
            if (toColdWallet > 0) {
                _uds.transfer(address(coldWallet), toColdWallet);
                emit TransferToColdWallet(address(_uds), toColdWallet);
            }
        }
    }

    /**
    @notice Calculate funds вistribution
    @return toHotWallet - amont to send to hotWallet, 
    @return toColdWallet - amount to send to cold wallet
    */
    function _calculateDistribution(
        uint256 currentContractBalance_,
        uint256 currentHotWalletBalance_,
        uint256 max_
    ) private pure returns (uint256 toHotWallet, uint256 toColdWallet) {
        if (
            currentHotWalletBalance_ < max_ &&
            currentHotWalletBalance_ + currentContractBalance_ > max_
        ) {
            toHotWallet = max_ - currentHotWalletBalance_;
            toColdWallet = currentContractBalance_ - toHotWallet;
        } else if (currentHotWalletBalance_ == max_) {
            toHotWallet = 0;
            toColdWallet = currentContractBalance_;
        } else {
            toHotWallet = currentContractBalance_;
            toColdWallet = 0;
        }
    }

    /**
    @notice Claim claim tokens to aggregation funds contract
    */
    function _claimTokens(address asset_) private {
        IClaimableFunds[] memory contracts = claimableContracts[asset_];
        for (uint256 index = 0; index < contracts.length; ) {
            uint256 amount = contracts[index].availableToClaim(
                address(this),
                asset_
            );
            if (amount > 0) {
                contracts[index].claimFunds(
                    asset_,
                    payable(address(this)),
                    amount
                );
            }
            unchecked {
                index++;
            }
        }
    }
}
