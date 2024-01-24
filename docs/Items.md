# Items.sol

View Source: [\contracts\items\Items.sol](..\contracts\items\Items.sol)

**↗ Extends: [IItems](IItems.md), [ERC1155Supply](ERC1155Supply.md), [EIP2981](EIP2981.md), [GuardExtension](GuardExtension.md)**

**Items**

## Contract Members
**Constants & Variables**

```js
mapping(uint256 => struct Structures.Item) private _items;
mapping(bytes32 => uint256) private _locationBasedItems;
string private _baseUri;
struct Counters.Counter private _tokenIds;
string private constant ONLY_ONE_CARRIABLE;
string private constant WRONG_ID;

```

## Functions

- [constructor(address rights_, string baseUri_)](#)
- [mint(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_)](#mint)
- [burn(address owner_, uint256 tokenId_, uint256 amount_)](#burn)
- [setTokenURI(uint256 tokenId_, string uri_)](#settokenuri)
- [setURI(string uri_)](#seturi)
- [uri(uint256 tokenId_)](#uri)
- [getTypeUri(string itemKey_, uint256 slots_)](#gettypeuri)
- [item(uint256 tokenId_)](#item)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)
- [_create(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_)](#_create)
- [_uri(uint256 tokenId_)](#_uri)
- [_typeUri(string itemKey_, uint256 slots)](#_typeuri)
- [_locationBasedKey(string itemKey_, uint256 location_)](#_locationbasedkey)

### 

constructor

```solidity
function (address rights_, string baseUri_) public nonpayable ERC1155 GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rights_ | address | The address of the Rights contract | 
| baseUri_ | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(address rights_, string memory baseUri_) ERC1155("") GuardExtension(rights_) {

        _baseUri = baseUri_;

    }
```
</details>

### mint

Mint new tokens

```solidity
function mint(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_) external nonpayable haveRights 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | The token owner | 
| itemKey_ | string | The item key, example 'item_hunting_rifle' | 
| location_ | uint256 | If set to 0, the token will be carriable item and should be unique | 
| slots_ | uint8 | Amount of the slots allowed for the item (for the carriable) | 
| count_ | uint256 | Amount minted (for location-based, for carriable should be 1) | 
| uri_ | string | Token specific metadata URI, only for new token, can be empty | 

**Returns**

Id of the new token

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
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
```
</details>

### burn

Remove the item amount of the person

```solidity
function burn(address owner_, uint256 tokenId_, uint256 amount_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | Current owner | 
| tokenId_ | uint256 | Object token tokenId_ | 
| amount_ | uint256 | The removed amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function burn(

        address owner_,

        uint256 tokenId_,

        uint256 amount_

    ) external override haveRights {

        delete _items[tokenId_];

        _burn(owner_, tokenId_, amount_);

        emit Burned(owner_, tokenId_, amount_);

    }
```
</details>

### setTokenURI

Set the token uri with specific id

```solidity
function setTokenURI(uint256 tokenId_, string uri_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 | Object token tokenId_ | 
| uri_ | string | Path to the uri | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setTokenURI(uint256 tokenId_, string memory uri_)

        external

        haveRights

    {

        _items[tokenId_].uri = uri_;

        emit URI(uri_, tokenId_);

    }
```
</details>

### setURI

Sets a new base URI for all token types.
The token URI is formed as follows: {baseUri}/{itemKey}/{slots}/meta.json

```solidity
function setURI(string uri_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| uri_ | string | Path to the base uri | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setURI(string memory uri_) external haveRights {

        _baseUri = uri_;

    }
```
</details>

### uri

Get the static uri by token id

```solidity
function uri(uint256 tokenId_) public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 | Object token tokenId_ | 

**Returns**

String with path to the static uri

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function uri(uint256 tokenId_)

        public

        view

        override(IERC1155MetadataURI, ERC1155)

        returns (string memory)

    {

        return _uri(tokenId_);

    }
```
</details>

### getTypeUri

Get an metadata URI by item key and number of slots

```solidity
function getTypeUri(string itemKey_, uint256 slots_) external view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| itemKey_ | string | The item key, example 'item_hunting_rifle' | 
| slots_ | uint256 | Number of item slots | 

**Returns**

URI of the metadata

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getTypeUri(string memory itemKey_, uint256 slots_) external view returns (string memory)

    {

        return _typeUri(itemKey_, slots_);

    }
```
</details>

### item

Get the item data

```solidity
function item(uint256 tokenId_) external view
returns(struct Structures.Item)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 | Object token tokenId_ | 

**Returns**

Structure Item

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function item(uint256 tokenId_) external view returns (Structures.Item memory)

    {

        require(tokenId_ > 0 && tokenId_ <= _tokenIds.current(), WRONG_ID);

        Structures.Item memory currentItem = _items[tokenId_];

        currentItem.uri = _uri(tokenId_);

        return currentItem;        

    }
```
</details>

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceId | bytes4 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function supportsInterface(bytes4 interfaceId)

        public

        view

        override(ERC1155, ERC2981, IERC165)

        returns (bool)

    {

        return super.supportsInterface(interfaceId);

    }
```
</details>

### _create

create new token

```solidity
function _create(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_) internal nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address |  | 
| itemKey_ | string |  | 
| location_ | uint256 |  | 
| slots_ | uint8 |  | 
| count_ | uint256 |  | 
| uri_ | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
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
```
</details>

### _uri

```solidity
function _uri(uint256 tokenId_) internal view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _uri(uint256 tokenId_) internal view returns (string memory)

    {

        Structures.Item memory currentItem = _items[tokenId_];

        if (bytes(currentItem.uri).length > 0) {

            return currentItem.uri;

        }

        return _typeUri(currentItem.itemKey, currentItem.slots);

    }
```
</details>

### _typeUri

```solidity
function _typeUri(string itemKey_, uint256 slots) internal view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| itemKey_ | string |  | 
| slots | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _typeUri(string memory itemKey_, uint256 slots) internal view returns (string memory)

    {

        return string(abi.encodePacked(_baseUri, "/", itemKey_, "/", Strings.toString(slots), "/", "meta.json"));

    }
```
</details>

### _locationBasedKey

create key for item

```solidity
function _locationBasedKey(string itemKey_, uint256 location_) internal pure
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| itemKey_ | string |  | 
| location_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _locationBasedKey(

        string memory itemKey_,

        uint256 location_

    ) internal pure returns (bytes32) {

        return keccak256(abi.encodePacked(itemKey_, location_));

    }
```
</details>

## Contracts

* [AccessControl](AccessControl.md)
* [AccessControlEnumerableUpgradeable](AccessControlEnumerableUpgradeable.md)
* [AccessControlUpgradeable](AccessControlUpgradeable.md)
* [Actors](Actors.md)
* [Address](Address.md)
* [AddressUpgradeable](AddressUpgradeable.md)
* [AggregationFunds](AggregationFunds.md)
* [BatchBalance](BatchBalance.md)
* [Benefits](Benefits.md)
* [BitMaps](BitMaps.md)
* [Breed](Breed.md)
* [Claimable](Claimable.md)
* [ClaimableUpgradeable](ClaimableUpgradeable.md)
* [Constants](Constants.md)
* [Context](Context.md)
* [ContextUpgradeable](ContextUpgradeable.md)
* [Counters](Counters.md)
* [DefaultOperatorFilterer](DefaultOperatorFilterer.md)
* [ECDSA](ECDSA.md)
* [EIP2981](EIP2981.md)
* [EnumerableMap](EnumerableMap.md)
* [EnumerableSet](EnumerableSet.md)
* [EnumerableSetUpgradeable](EnumerableSetUpgradeable.md)
* [ERC1155](ERC1155.md)
* [ERC1155Holder](ERC1155Holder.md)
* [ERC1155Receiver](ERC1155Receiver.md)
* [ERC1155Supply](ERC1155Supply.md)
* [ERC165](ERC165.md)
* [ERC165Upgradeable](ERC165Upgradeable.md)
* [ERC20](ERC20.md)
* [ERC20Burnable](ERC20Burnable.md)
* [ERC2981](ERC2981.md)
* [ERC721](ERC721.md)
* [ERC721Holder](ERC721Holder.md)
* [Guard](Guard.md)
* [GuardExtension](GuardExtension.md)
* [GuardExtensionUpgradeable](GuardExtensionUpgradeable.md)
* [Humans](Humans.md)
* [IAccessControl](IAccessControl.md)
* [IAccessControlEnumerableUpgradeable](IAccessControlEnumerableUpgradeable.md)
* [IAccessControlUpgradeable](IAccessControlUpgradeable.md)
* [IActors](IActors.md)
* [IBenefits](IBenefits.md)
* [IBreed](IBreed.md)
* [IClaimableFunds](IClaimableFunds.md)
* [IERC1155](IERC1155.md)
* [IERC1155MetadataURI](IERC1155MetadataURI.md)
* [IERC1155Receiver](IERC1155Receiver.md)
* [IERC165](IERC165.md)
* [IERC165Upgradeable](IERC165Upgradeable.md)
* [IERC20](IERC20.md)
* [IERC20Metadata](IERC20Metadata.md)
* [IERC2981](IERC2981.md)
* [IERC721](IERC721.md)
* [IERC721Metadata](IERC721Metadata.md)
* [IERC721Receiver](IERC721Receiver.md)
* [IHumans](IHumans.md)
* [IItems](IItems.md)
* [IManagement](IManagement.md)
* [IMarketplaceStorage](IMarketplaceStorage.md)
* [IMarketplaceTreasury](IMarketplaceTreasury.md)
* [IMysteryBox](IMysteryBox.md)
* [Initializable](Initializable.md)
* [IOperatorFilterRegistry](IOperatorFilterRegistry.md)
* [IPotions](IPotions.md)
* [IRandaoRandomizer](IRandaoRandomizer.md)
* [IRandomizer](IRandomizer.md)
* [IRights](IRights.md)
* [IRouter](IRouter.md)
* [Items](Items.md)
* [LehmerRandomizer](LehmerRandomizer.md)
* [Management](Management.md)
* [Marketplace](Marketplace.md)
* [MarketplaceStorage](MarketplaceStorage.md)
* [MarketplaceTreasury](MarketplaceTreasury.md)
* [Math](Math.md)
* [MathUpgradeable](MathUpgradeable.md)
* [MysteryBox](MysteryBox.md)
* [NaturalNum](NaturalNum.md)
* [OperatorFilterer](OperatorFilterer.md)
* [OperatorFiltererERC721](OperatorFiltererERC721.md)
* [Ownable](Ownable.md)
* [OwnableUpgradeable](OwnableUpgradeable.md)
* [Potions](Potions.md)
* [ReentrancyGuard](ReentrancyGuard.md)
* [ReentrancyGuardUpgradeable](ReentrancyGuardUpgradeable.md)
* [Rights](Rights.md)
* [Router](Router.md)
* [Sqrt](Sqrt.md)
* [Strings](Strings.md)
* [StringsUpgradeable](StringsUpgradeable.md)
* [Structures](Structures.md)
* [UDSToken](UDSToken.md)
* [UGoldToken](UGoldToken.md)
* [Voting](Voting.md)
* [Zombies](Zombies.md)
