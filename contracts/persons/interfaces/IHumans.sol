// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

interface IHumans is IERC721Metadata {
    event TokenUriDefined(uint256 indexed id, string uri);
    event Created(address indexed owner, uint256 indexed newId);

    /**
    @notice Mint a new human
    @param owner_ Owner of new human
    @param props_ Array of the actor properties
    @return The id of created human
    */
    function mint(address owner_, uint16[10] memory props_) external returns(uint256);

    /**
    @notice Get the person props
    @param id_ Person token id
    @return Array of the props
    */
    function getProps(uint256 id_) external view returns (uint16[10] memory);

    /**
    @notice Get the person rank
    @param id_ Person token id
    @return person rank value
    */
    function getRank(uint256 id_) external view returns (uint16);

    /**
    @notice Get a total amount of issued tokens
    @return The number of tokens minted
    */
    function totalSupply() external view returns(uint256);

    /**
    @notice Set an uri for the human
    @param id_ token id
    @param ipfsHash_ ipfs hash of the metadata
    */
    function setMetadataHash(uint256 id_, string calldata ipfsHash_) external;

    /**
     * @notice Returns the URI for `tokenId` token.
       @param id_ token id
     */
    function tokenURI(uint256 id_) external view returns(string memory);

    /**
    @notice Set an base uri for the token 
    @param uri_ base URI of the metadata
    */
    function setBaseUri(string calldata uri_) external; 

}
