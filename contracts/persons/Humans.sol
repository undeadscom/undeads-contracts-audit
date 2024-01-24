// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/IHumans.sol";
import "../utils/GuardExtension.sol";
import "../utils/EIP2981.sol";
import {
    ERC721,
    OperatorFiltererERC721
} from "../utils/OperatorFiltererERC721.sol";

contract Humans is OperatorFiltererERC721, IHumans, EIP2981, GuardExtension {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenCounter;
    mapping(uint256 => string) private _metadataHashes;
    mapping(uint256 => uint16[10]) private _props;
    string private _baseTokenURI;

    string private constant IPFS_PREFIX = "ipfs://";

    /**
    @notice Constructor
    @param baseURI_ The base token URI
    @param rights_ The address of the rights contract
    */
    constructor(
        string memory baseURI_,
        address rights_
    ) ERC721("UndeadsHumans", "UDHT") GuardExtension(rights_) {
        _baseTokenURI = baseURI_;
    }

    /**
    @notice Mint a new human
    @param owner_ Owner of new human
    @param props_ Array of the actor properties
    @return The id of created human
    */
    function mint(
        address owner_,
        uint16[10] memory props_
    ) external override haveRights returns(uint256) {
        _tokenCounter.increment();
        uint256 id = _tokenCounter.current();
        _props[id] = props_;
        _mint(owner_, id);
        emit Created(owner_, id);
        return id;
    }

    /**
    @notice Get the person props
    @param id_ Person token id
    @return Array of the props
    */
    function getProps(
        uint256 id_
    ) external view override returns (uint16[10] memory)
    {
        return _props[id_];
    }

    /**
    @notice Get the person rank
    @param id_ Person token id
    @return person rank value
    */
    function getRank(
        uint256 id_
    ) external view override returns (uint16)
    {
        _requireMinted(id_);
        uint16[10] memory props = _props[id_];
        uint16 rank;
        for (uint256 i; i < 10;) {
            rank += props[i];
            unchecked {
                ++i;
            }
        }
        rank = rank / 10;
        return rank;
    }

    /**
    @notice Get a total amount of issued tokens
    @return The number of tokens minted
    */
    function totalSupply() external view override returns(uint256) {
        return _tokenCounter.current();
    }

    /**
    @notice Set an uri for the human
    @param id_ token id
    @param ipfsHash_ ipfs hash of the metadata
    */
    function setMetadataHash(
        uint256 id_,
        string calldata ipfsHash_
    ) external override haveRights
    {
        _requireMinted(id_);
        _metadataHashes[id_] = ipfsHash_;
        emit TokenUriDefined(id_, string(abi.encodePacked(IPFS_PREFIX, ipfsHash_)));
    }

    /**
    @notice Returns the URI for `tokenId` token.
    @param id_ token id
     */
    function tokenURI(
        uint256 id_
    ) public view override(ERC721, IHumans) returns(string memory)
    {
        _requireMinted(id_);
        string memory metadataHash = _metadataHashes[id_];
        if (bytes(metadataHash).length != 0) {
            return string(abi.encodePacked(IPFS_PREFIX, metadataHash));
        }

        return string(abi.encodePacked(_baseTokenURI, "/", Strings.toString(id_), ".json"));
    }

    /**
    @notice Set an base uri for the token 
    @param uri_ base URI of the metadata
    */
    function setBaseUri(string calldata uri_) external override haveRights {
        _baseTokenURI = uri_;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC2981, ERC721, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
