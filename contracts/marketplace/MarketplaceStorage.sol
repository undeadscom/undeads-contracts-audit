// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../utils/GuardExtension.sol";
import "./interfaces/IMarketplaceStorage.sol";

contract MarketplaceStorage is
    IMarketplaceStorage,
    ERC721Holder,
    ERC1155Holder,
    ReentrancyGuard,
    GuardExtension
{
    // keep track of packs
    Counters.Counter internal itemsCounter;

    // token address => tokenId => data
    mapping(uint256 => TokenData) private _allTokens;

    // Method nft collections that are approved for selling on the marketplace
    mapping(address => bool) public approvedCollections;

    /**
     * @notice Constructor
     */
    constructor(address rights_) GuardExtension(rights_) {}

    /**
     * @notice Function to deposit tokens to marketplace
     */
    function depositTokens(
        uint256 tokenId_,
        uint256 amount_,
        address tokenAddress_,
        address owner_,
        TokenStandard tokenStandard_
    ) external haveRights returns (uint256) {
        if (tokenStandard_ == TokenStandard.ERC721) {
            IERC721(tokenAddress_).transferFrom(
                owner_,
                address(this),
                tokenId_
            );
        } else {
            IERC1155(tokenAddress_).safeTransferFrom(
                owner_,
                address(this),
                tokenId_,
                amount_,
                ""
            );
        }

        Counters.increment(itemsCounter);
        uint256 current = Counters.current(itemsCounter);

        _allTokens[current] = TokenData({
            tokenId: tokenId_,
            tokenAddress: tokenAddress_,
            amount: amount_,
            owner: owner_,
            tokenStandard: tokenStandard_
        });
        return current;
    }

    /**
     * @notice Function to send tokens
     */
    function transferTokens(
        uint256 packageId_,
        address receiver_
    ) external haveRights {
        TokenData memory package = _allTokens[packageId_];
        if (package.tokenStandard == TokenStandard.ERC721) {
            IERC721(package.tokenAddress).safeTransferFrom(
                address(this),
                receiver_,
                package.tokenId
            );
        } else {
            IERC1155(package.tokenAddress).safeTransferFrom(
                address(this),
                receiver_,
                package.tokenId,
                package.amount,
                ""
            );
        }
        delete _allTokens[packageId_];
    }

    /*
     * @notice Method enabling/disabling nfts
     * @param collections_ Addresses of NFTs smart contracts
     * @param enabled_ is NFTs are enabled
     */
    function approveCollections(
        address[] calldata collections_,
        bool enabled_
    ) external haveRights {
        for (uint256 index = 0; index < collections_.length; index++) {
            approvedCollections[collections_[index]] = enabled_;
        }
    }

    /*
     * @notice Method returns token data by id
     * @param id_ storage id
     */
    function getTokenData(
        uint256 id_
    ) external view returns (TokenData memory) {
        return _allTokens[id_];
    }
}
