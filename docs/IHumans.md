# IHumans.sol

View Source: [\contracts\persons\interfaces\IHumans.sol](..\contracts\persons\interfaces\IHumans.sol)

**↗ Extends: [IERC721Metadata](IERC721Metadata.md)**
**↘ Derived Contracts: [Humans](Humans.md)**

**IHumans**

**Events**

```js
event TokenUriDefined(uint256 indexed id, string  uri);
event Created(address indexed owner, uint256 indexed newId);
```

## Functions

- [mint(address owner_, uint16[10] props_)](#mint)
- [getProps(uint256 id_)](#getprops)
- [getRank(uint256 id_)](#getrank)
- [totalSupply()](#totalsupply)
- [setMetadataHash(uint256 id_, string ipfsHash_)](#setmetadatahash)
- [tokenURI(uint256 id_)](#tokenuri)
- [setBaseUri(string uri_)](#setbaseuri)

### mint

Mint a new human

```solidity
function mint(address owner_, uint16[10] props_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | Owner of new human | 
| props_ | uint16[10] | Array of the actor properties | 

**Returns**

The id of created human

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mint(address owner_, uint16[10] memory props_) external returns(uint256);
```
</details>

### getProps

Get the person props

```solidity
function getProps(uint256 id_) external view
returns(uint16[10])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

Array of the props

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getProps(uint256 id_) external view returns (uint16[10] memory);
```
</details>

### getRank

Get the person rank

```solidity
function getRank(uint256 id_) external view
returns(uint16)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

person rank value

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getRank(uint256 id_) external view returns (uint16);
```
</details>

### totalSupply

Get a total amount of issued tokens

```solidity
function totalSupply() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function totalSupply() external view returns(uint256);
```
</details>

### setMetadataHash

Set an uri for the human

```solidity
function setMetadataHash(uint256 id_, string ipfsHash_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| ipfsHash_ | string | ipfs hash of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(uint256 id_, string calldata ipfsHash_) external;
```
</details>

### tokenURI

Returns the URI for `tokenId` token.

```solidity
function tokenURI(uint256 id_) external view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenURI(uint256 id_) external view returns(string memory);
```
</details>

### setBaseUri

Set an base uri for the token

```solidity
function setBaseUri(string uri_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| uri_ | string | base URI of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setBaseUri(string calldata uri_) external;
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
