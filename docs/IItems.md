# IItems.sol

View Source: [\contracts\items\interfaces\IItems.sol](..\contracts\items\interfaces\IItems.sol)

**↗ Extends: [IERC1155MetadataURI](IERC1155MetadataURI.md)**
**↘ Derived Contracts: [Items](Items.md)**

**IItems**

**Events**

```js
event Minted(address indexed owner, uint256 indexed id, uint256  amount);
event Burned(address indexed owner, uint256 indexed id, uint256  amount);
```

## Functions

- [mint(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_)](#mint)
- [burn(address owner_, uint256 tokenId_, uint256 amount_)](#burn)
- [setTokenURI(uint256 tokenId_, string uri_)](#settokenuri)
- [setURI(string uri_)](#seturi)
- [getTypeUri(string itemKey_, uint256 slots_)](#gettypeuri)
- [item(uint256 tokenId_)](#item)

### mint

Mint a new token

```solidity
function mint(address owner_, string itemKey_, uint256 location_, uint8 slots_, uint256 count_, string uri_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | The token owner | 
| itemKey_ | string | The item key, example 'item_hunting_rifle' | 
| location_ | uint256 | If set to 0, the token will be carryable item and should be unique | 
| slots_ | uint8 | Amount of the slots allowed for the item (for the carryable) | 
| count_ | uint256 | Amount minted (for location-based, for carryable should be 1) | 
| uri_ | string |  | 

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

    ) external returns (uint256);
```
</details>

### burn

Remove the item amount of the person

```solidity
function burn(address owner_, uint256 tokenId_, uint256 amount_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | New owner | 
| tokenId_ | uint256 | Object token tokenId_ | 
| amount_ | uint256 | The removed amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function burn(

        address owner_,

        uint256 tokenId_,

        uint256 amount_

    ) external;
```
</details>

### setTokenURI

Set the token uri

```solidity
function setTokenURI(uint256 tokenId_, string uri_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 | Object token tokenId_ | 
| uri_ | string | Path to the uri | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setTokenURI(uint256 tokenId_, string memory uri_) external;
```
</details>

### setURI

Sets a new base URI for all token types.
The token URI is formed as follows: {baseUri}/{itemKey}/{slots}/meta.json

```solidity
function setURI(string uri_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| uri_ | string | Path to the base uri | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setURI(string memory uri_) external;
```
</details>

### getTypeUri

Get an metadata URI by item key

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
function getTypeUri(string memory itemKey_, uint256 slots_) external view returns (string memory);
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
function item(uint256 tokenId_) external view returns (Structures.Item memory);
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
