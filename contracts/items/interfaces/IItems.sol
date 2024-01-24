// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;
import "../../lib/Structures.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

interface IItems is IERC1155MetadataURI {
    event Minted(address indexed owner, uint256 indexed id, uint256 amount);
    event Burned(address indexed owner, uint256 indexed id, uint256 amount);

    /**
    @notice Mint a new token 
    @param owner_ The token owner
    @param itemKey_ The item key, example 'item_hunting_rifle'
    @param location_ If set to 0, the token will be carryable item and should be unique
    @param slots_ Amount of the slots allowed for the item (for the carryable)
    @param count_ Amount minted (for location-based, for carryable should be 1)
    @return Id of the new token
    */
    function mint(
        address owner_,
        string memory itemKey_,
        uint256 location_,
        uint8 slots_,
        uint256 count_,
        string memory uri_
    ) external returns (uint256);

    /**
    @notice Remove the item amount of the person
    @param owner_ New owner
    @param tokenId_ Object token tokenId_
    @param amount_ The removed amount 
    */
    function burn(
        address owner_,
        uint256 tokenId_,
        uint256 amount_
    ) external;

    /**
    @notice Set the token uri
    @param tokenId_ Object token tokenId_
    @param uri_ Path to the uri
    */
    function setTokenURI(uint256 tokenId_, string memory uri_) external;

    /**
    @notice Sets a new base URI for all token types.
    The token URI is formed as follows: {baseUri}/{itemKey}/{slots}/meta.json
    @param uri_ Path to the base uri
    */
    function setURI(string memory uri_) external;


    /**
    @notice Get an metadata URI by item key
    @param itemKey_ The item key, example 'item_hunting_rifle'
    @param slots_ Number of item slots
    @return URI of the metadata
    */
    function getTypeUri(string memory itemKey_, uint256 slots_) external view returns (string memory);

    /**
    @notice Get the item data
    @param tokenId_ Object token tokenId_
    @return Structure Item
    */
    function item(uint256 tokenId_) external view returns (Structures.Item memory);
}
