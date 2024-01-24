// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

interface IMarketplaceStorage {
    struct TokenData {
        uint256 tokenId;
        uint256 amount;
        address owner;
        address tokenAddress;
        TokenStandard tokenStandard;
    }

    enum TokenStandard {
        ERC721,
        ERC1155
    }

    /**
     * @notice Function to deposit tokens to marketplace
     */
    function depositTokens(
        uint256 tokenId_,
        uint256 amount_,
        address tokenAddress_,
        address owner_,
        TokenStandard tokenStandard_
    ) external returns (uint256);

    /**
     * @notice Function to send tokens
     */
    function transferTokens(uint256 packageId_, address receiver_) external;

    /*
     * @notice Method enabling/disabling nfts
     * @param collections_ Addresses of NFTs smart contracts
     * @param enabled_ is NFTs are enabled
     */
    function approveCollections(
        address[] calldata collections_,
        bool enabled_
    ) external;

    /*
     * @notice Method returns token data by id
     * @param id_ storage id
     */
    function getTokenData(uint256 id_) external view returns (TokenData memory);
}
