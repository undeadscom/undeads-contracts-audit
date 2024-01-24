// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IItems.sol";
import "../lib/Structures.sol";
import "../utils/Guard.sol";
import "../utils/EIP2981.sol";
import "../utils/GuardExtension.sol";

contract Items is IItems, ERC1155Supply, EIP2981, GuardExtension {
    using Counters for Counters.Counter;

    mapping(uint256 => Structures.Item) private _items; // all items
    mapping(bytes32 => uint256) private _locationBasedItems; // location-based item ids
    
    string private _baseUri;
    Counters.Counter private _tokenIds;
    string private constant ONLY_ONE_CARRIABLE = "Item: can mint only 1 carriable item";
    string private constant WRONG_ID = "Item: wrong id";

    /**
    @notice constructor 
    @param rights_ The address of the Rights contract
    */
    constructor(address rights_, string memory baseUri_) ERC1155("") GuardExtension(rights_) {
        _baseUri = baseUri_;
    }

    /**
    @notice Mint new tokens
    @param owner_ The token owner
    @param itemKey_ The item key, example 'item_hunting_rifle'
    @param location_ If set to 0, the token will be carriable item and should be unique
    @param slots_ Amount of the slots allowed for the item (for the carriable)
    @param count_ Amount minted (for location-based, for carriable should be 1)
    @param uri_ Token specific metadata URI, only for new token, can be empty
    @return Id of the new token
    */
    function mint(
        address owner_,
        string memory itemKey_,
        uint256 location_,
        uint8 slots_,
        uint256 count_,
        string memory uri_
    ) external haveRights returns (uint256) {
        require(location_ > 0 || count_ == 1, ONLY_ONE_CARRIABLE);

        bytes32 key = _locationBasedKey(itemKey_, location_);

        // only for already created location-based items
        if (location_ > 0 && _locationBasedItems[key] != 0) {
            _mint(owner_, _locationBasedItems[key], count_, "");
            emit Minted(owner_, _locationBasedItems[key], count_);
            return _locationBasedItems[key];
        }

        // carriable or not createad yet location-based item
        return _create(owner_, itemKey_, location_, slots_, count_, uri_);
    }

    /**
    @notice Remove the item amount of the person
    @param owner_ Current owner
    @param tokenId_ Object token tokenId_
    @param amount_ The removed amount 
    */
    function burn(
        address owner_,
        uint256 tokenId_,
        uint256 amount_
    ) external override haveRights {
        delete _items[tokenId_];
        _burn(owner_, tokenId_, amount_);
        emit Burned(owner_, tokenId_, amount_);
    }

    /**
    @notice Set the token uri with specific id
    @param tokenId_ Object token tokenId_
    @param uri_ Path to the uri
    */
    function setTokenURI(uint256 tokenId_, string memory uri_)
        external
        haveRights
    {
        _items[tokenId_].uri = uri_;
        emit URI(uri_, tokenId_);
    }

    /**
    @notice Sets a new base URI for all token types.
    The token URI is formed as follows: {baseUri}/{itemKey}/{slots}/meta.json
    @param uri_ Path to the base uri
    */
    function setURI(string memory uri_) external haveRights {
        _baseUri = uri_;
    }

    /**
    @notice Get the static uri by token id
    @param tokenId_ Object token tokenId_
    @return String with path to the static uri
    */
    function uri(uint256 tokenId_)
        public
        view
        override(IERC1155MetadataURI, ERC1155)
        returns (string memory)
    {
        return _uri(tokenId_);
    }

    /**
    @notice Get an metadata URI by item key and number of slots
    @param itemKey_ The item key, example 'item_hunting_rifle'
    @param slots_ Number of item slots
    @return URI of the metadata
    */
    function getTypeUri(string memory itemKey_, uint256 slots_) external view returns (string memory)
    {
        return _typeUri(itemKey_, slots_);
    }

    /**
    @notice Get the item data
    @param tokenId_ Object token tokenId_
    @return Structure Item
    */
    function item(uint256 tokenId_) external view returns (Structures.Item memory)
    {
        require(tokenId_ > 0 && tokenId_ <= _tokenIds.current(), WRONG_ID);
        Structures.Item memory currentItem = _items[tokenId_];
        currentItem.uri = _uri(tokenId_);
        return currentItem;        
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, ERC2981, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// @notice create new token
    function _create(
        address owner_,
        string memory itemKey_,
        uint256 location_,
        uint8 slots_,
        uint256 count_,
        string memory uri_
    ) internal returns (uint256) {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();

        if (location_ > 0) {
            bytes32 key = _locationBasedKey(itemKey_, location_);
            _locationBasedItems[key] = newId;
        }
                
        _mint(owner_, newId, count_, "");
        _items[newId] = Structures.Item({
            itemKey: itemKey_,
            location: location_,
            slots: slots_,
            uri: uri_
        });

        emit Minted(owner_, newId, count_);
        return newId;
    }

    function _uri(uint256 tokenId_) internal view returns (string memory)
    {
        Structures.Item memory currentItem = _items[tokenId_];

        if (bytes(currentItem.uri).length > 0) {
            return currentItem.uri;
        }

        return _typeUri(currentItem.itemKey, currentItem.slots);
    }

    function _typeUri(string memory itemKey_, uint256 slots) internal view returns (string memory)
    {
        return string(abi.encodePacked(_baseUri, "/", itemKey_, "/", Strings.toString(slots), "/", "meta.json"));
    }

    /// @notice create key for item
    function _locationBasedKey(
        string memory itemKey_,
        uint256 location_
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(itemKey_, location_));
    }
}
