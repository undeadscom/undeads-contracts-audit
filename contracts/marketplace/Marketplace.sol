// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "./interfaces/IMarketplaceTreasury.sol";
import "./interfaces/IMarketplaceStorage.sol";
import "../utils/GuardExtension.sol";

contract Marketplace is ReentrancyGuard, GuardExtension {
    using Address for address payable;

    string private constant SAME_VALUE = "Marketplace: same value";

    struct Listing {
        uint256 price;
        address paymentAsset;
    }

    event ItemListed(
        address indexed seller,
        address indexed tokenAddress,
        uint256 indexed tokenId,
        uint256 id,
        uint256 amount,
        uint256 price,
        address paymentAsset
    );

    event ItemUpdated(
        address indexed seller,
        address indexed tokenAddress,
        uint256 indexed tokenId,
        uint256 id,
        uint256 amount,
        uint256 price,
        address paymentAsset
    );

    event ItemCanceled(
        address indexed seller,
        address indexed tokenAddress,
        uint256 indexed tokenId,
        uint256 id
    );

    event ItemBought(
        address indexed buyer,
        address indexed tokenAddress,
        uint256 indexed tokenId,
        uint256 id,
        uint256 amount,
        uint256 price,
        address paymentAsset
    );

    IMarketplaceStorage public marketplaceStorage;
    IMarketplaceTreasury public marketplaceTreasury;

    mapping(uint256 => Listing) private _prices;

    modifier validatePrice(uint256 price_) {
        require(price_ > 0, "Price must be > 0");
        _;
    }

    modifier validateAmount(uint256 amount_) {
        require(amount_ > 0, "Amount must be > 0");
        _;
    }

    modifier validatePaymentAsset(address paymentAsset_) {
        require(
            marketplaceTreasury.isPaymentAssetApproved(paymentAsset_),
            "Payment method not approved"
        );
        _;
    }

    modifier ensureERC721(address tokenAddress_) {
        if (
            IERC165(tokenAddress_).supportsInterface(type(IERC721).interfaceId)
        ) {
            _;
        }
    }

    modifier ensureERC1155(address tokenAddress_) {
        if (
            IERC165(tokenAddress_).supportsInterface(type(IERC1155).interfaceId)
        ) {
            _;
        }
    }

    /**
     * @notice Constructor
     */
    constructor(
        address marketplaceStorage_,
        address payable marketplaceTreasury_,
        address rights_
    ) GuardExtension(rights_) {
        marketplaceStorage = IMarketplaceStorage(marketplaceStorage_);
        marketplaceTreasury = IMarketplaceTreasury(marketplaceTreasury_);
    }

    /////////////////////
    // Main Functions //
    /////////////////////

    /*
     * @notice Method for listing ERC1155 NFT
     * @param tokenAddress_ Address of NFT contract
     * @param tokenId_ Token ID of NFT
     * @param amount_ Amount of tokens ueser wants to sell in the package
     * @param price_ Sale price of the shole package
     * @param paymentAsset_ Address of the asset user set the price
     */
    function listERC1155Item(
        address tokenAddress_,
        uint256 tokenId_,
        uint256 amount_,
        uint256 price_,
        address paymentAsset_
    )
        external
        validatePrice(price_)
        validateAmount(amount_)
        validatePaymentAsset(paymentAsset_)
        ensureERC1155(tokenAddress_)
    {
        IERC1155 nft = IERC1155(tokenAddress_);
        require(
            nft.balanceOf(msg.sender, tokenId_) >= amount_,
            "Not enought nfts"
        );

        uint256 id = marketplaceStorage.depositTokens(
            tokenId_,
            amount_,
            tokenAddress_,
            msg.sender,
            IMarketplaceStorage.TokenStandard.ERC1155
        );

        _prices[id] = Listing({price: price_, paymentAsset: paymentAsset_});

        emit ItemListed(
            msg.sender,
            tokenAddress_,
            tokenId_,
            id,
            amount_,
            price_,
            paymentAsset_
        );
    }

    /*
     * @notice Method for listing ERC721 NFT
     * @param tokenAddress_ Address of NFT contract
     * @param tokenId_ Token ID of NFT
     * @param price_ Sale price of the shole package
     * @param paymentAsset_ Address of the asset user set the price
     */
    function listERC721Item(
        address tokenAddress_,
        uint256 tokenId_,
        uint256 price_,
        address paymentAsset_
    )
        external
        validatePrice(price_)
        validatePaymentAsset(paymentAsset_)
        ensureERC721(tokenAddress_)
    {
        IERC721 nft = IERC721(tokenAddress_);
        require(nft.ownerOf(tokenId_) == msg.sender, "Not owner");

        uint256 id = marketplaceStorage.depositTokens(
            tokenId_,
            1,
            tokenAddress_,
            msg.sender,
            IMarketplaceStorage.TokenStandard.ERC721
        );
        _prices[id] = Listing({price: price_, paymentAsset: paymentAsset_});
        emit ItemListed(
            msg.sender,
            tokenAddress_,
            tokenId_,
            id,
            1,
            price_,
            paymentAsset_
        );
    }

    /*
     * @notice Method for cancelling listing
     * @param tokenAddress Address of NFT contract
     * @param tokenId Token ID of NFT
     */
    function cancelListing(uint256 id_) external {
        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage
            .getTokenData(id_);
        require(msg.sender == tokenData.owner, "Not owner");

        marketplaceStorage.transferTokens(id_, tokenData.owner);
        delete _prices[id_];
        emit ItemCanceled(
            tokenData.owner,
            tokenData.tokenAddress,
            tokenData.tokenId,
            id_
        );
    }

    /*
     * @notice Method for buying listing
     * @param id_ Id of the selling position
     */
    function buyItem(uint256 id_) external payable nonReentrant {
        Listing memory listing = _prices[id_];
        require(listing.price > 0, "Item not exists");

        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage
            .getTokenData(id_);
        require(tokenData.owner != msg.sender, "Trying to buy own item");

        // send funds to the treasury
        if (listing.paymentAsset == address(0x0)) {
            require(msg.value >= listing.price, "Price not met");
            payable(address(marketplaceTreasury)).sendValue(msg.value);
        } else {
            bool success = IERC20(listing.paymentAsset).transferFrom(
                msg.sender,
                address(marketplaceTreasury),
                listing.price
            );
            require(success, "Can't transfer to treasury");
        }

        if (
            IERC165(tokenData.tokenAddress).supportsInterface(
                type(IERC2981).interfaceId
            )
        ) {
            (address receiver, uint256 royaltyAmount) = IERC2981(
                tokenData.tokenAddress
            ).royaltyInfo(tokenData.tokenId, listing.price);
            marketplaceTreasury.addFunds(
                listing.paymentAsset,
                receiver,
                royaltyAmount
            );
            marketplaceTreasury.addFunds(
                listing.paymentAsset,
                tokenData.owner,
                listing.price - royaltyAmount
            );
        } else {
            marketplaceTreasury.addFunds(
                listing.paymentAsset,
                tokenData.owner,
                listing.price
            );
        }

        delete _prices[id_];

        marketplaceStorage.transferTokens(id_, msg.sender);

        emit ItemBought(
            msg.sender,
            tokenData.tokenAddress,
            tokenData.tokenId,
            id_,
            tokenData.amount,
            listing.price,
            listing.paymentAsset
        );
    }

    /*
     * @notice Method for updating listing
     * @param tokenAddress Address of NFT contract
     * @param tokenId Token ID of NFT
     * @param newPrice Price (wei dimension) of the item
     */
    function updateListing(
        uint256 id_,
        uint256 newPrice_,
        address newPaymentAsset_
    ) external validatePrice(newPrice_) validatePaymentAsset(newPaymentAsset_) {
        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage
            .getTokenData(id_);
        require(tokenData.owner == msg.sender, "Not owner");

        _prices[id_] = Listing({
            price: newPrice_,
            paymentAsset: newPaymentAsset_
        });

        emit ItemUpdated(
            msg.sender,
            tokenData.tokenAddress,
            tokenData.tokenId,
            id_,
            tokenData.amount,
            newPrice_,
            newPaymentAsset_
        );
    }

    /////////////////////
    // Getter Functions //
    /////////////////////

    function getListing(
        uint256 id_
    )
        external
        view
        returns (
            IMarketplaceStorage.TokenData memory tokenData,
            Listing memory listing
        )
    {
        tokenData = marketplaceStorage.getTokenData(id_);
        listing = _prices[id_];
    }
}
