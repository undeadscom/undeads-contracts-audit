# IPotions.sol

View Source: [\contracts\persons\interfaces\IPotions.sol](..\contracts\persons\interfaces\IPotions.sol)

**↗ Extends: [IERC721Metadata](IERC721Metadata.md)**
**↘ Derived Contracts: [Potions](Potions.md)**

**IPotions**

**Events**

```js
event Created(address indexed owner, uint256 indexed id, uint256 indexed level);
event Opened(address indexed owner, uint256 indexed id);
event ChildsDefined(uint256 indexed childs);
event TokenUriDefined(uint256 indexed id, string  tokenUri);
```

## Functions

- [total()](#total)
- [unissued()](#unissued)
- [level(uint256 id_)](#level)
- [setChilds(uint256 childs_)](#setchilds)
- [getChilds()](#getchilds)
- [open(uint256 id_)](#open)
- [getMaxLevel()](#getmaxlevel)
- [create(address target, bool rare, uint256 id_)](#create)
- [createPotion(address target, uint256 level, uint256 id_)](#createpotion)
- [getLast(address target)](#getlast)
- [decreaseAmount(bool rare)](#decreaseamount)
- [setMetadataHash(uint256 id_, string metadataHash_)](#setmetadatahash)

### total

Get a total amount of issued tokens

```solidity
function total() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function total() external view returns (uint256);
```
</details>

### unissued

Get the amount of the actors remains to be created

```solidity
function unissued() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function unissued() external view returns (uint256);
```
</details>

### level

Get the level of the potion

```solidity
function level(uint256 id_) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | potion id | 

**Returns**

The level of the potion

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function level(uint256 id_) external view returns (uint256);
```
</details>

### setChilds

Set the maximum amount of the childs for the woman actor

```solidity
function setChilds(uint256 childs_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| childs_ | uint256 | New childs amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setChilds(uint256 childs_) external;
```
</details>

### getChilds

Get the current  maximum amount of the childs

```solidity
function getChilds() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getChilds() external view returns (uint256);
```
</details>

### open

Open the packed id with the random values

```solidity
function open(uint256 id_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | The pack id | 

**Returns**

The new actor id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function open(uint256 id_) external returns (uint256);
```
</details>

### getMaxLevel

return max potion level

```solidity
function getMaxLevel() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getMaxLevel() external view returns (uint256);
```
</details>

### create

Create the potion by box (rare or not)

```solidity
function create(address target, bool rare, uint256 id_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The potion owner | 
| rare | bool | The rarity sign | 
| id_ | uint256 | The id of a new token | 

**Returns**

The new pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function create(

        address target,

        bool rare,

        uint256 id_

    ) external returns (uint256);
```
</details>

### createPotion

Create the packed potion with desired level (admin only)

```solidity
function createPotion(address target, uint256 level, uint256 id_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The pack owner | 
| level | uint256 | The pack level | 
| id_ | uint256 | The id of a new token | 

**Returns**

The new pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function createPotion(

        address target,

        uint256 level,

        uint256 id_

    ) external returns (uint256);
```
</details>

### getLast

get the last pack for the address

```solidity
function getLast(address target) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The  owner | 

**Returns**

The  pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getLast(address target) external view returns (uint256);
```
</details>

### decreaseAmount

Decrease the amount of the common or rare tokens or fails

```solidity
function decreaseAmount(bool rare) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rare | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function decreaseAmount(bool rare) external returns (bool);
```
</details>

### setMetadataHash

Set an uri for the token

```solidity
function setMetadataHash(uint256 id_, string metadataHash_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| metadataHash_ | string | ipfs hash of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(uint256 id_, string calldata metadataHash_)

        external;
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
