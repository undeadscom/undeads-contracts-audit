# IMysteryBox.sol

View Source: [\contracts\persons\interfaces\IMysteryBox.sol](..\contracts\persons\interfaces\IMysteryBox.sol)

**↗ Extends: [IERC721Metadata](IERC721Metadata.md), [IClaimableFunds](IClaimableFunds.md)**
**↘ Derived Contracts: [MysteryBox](MysteryBox.md)**

**IMysteryBox**

**Events**

```js
event Created(address indexed owner, uint256 indexed id, bool indexed rare);
event Opened(address indexed owner, uint256 indexed id);
event CommonLimitDefined(uint256  commonLimit);
event CommonPriceDefined(uint256  commonPrice);
event RareLimitDefined(uint256  rareLimit);
event RarePriceDefined(uint256  rarePrice);
event RarePriceIncreaseDefined(uint256  rarePriceIncrease);
```

## Functions

- [total()](#total)
- [setCommonLimit(uint256 value_)](#setcommonlimit)
- [setCommonPrice(uint256 value_)](#setcommonprice)
- [setRareLimit(uint256 value_)](#setrarelimit)
- [setRarePrice(uint256 value_)](#setrareprice)
- [setRarePriceIncrease(uint256 value_)](#setrarepriceincrease)
- [getRarePrice()](#getrareprice)
- [getIssued(address account_)](#getissued)
- [create(address target_, bool rare_)](#create)
- [rarity(uint256 tokenId_)](#rarity)
- [deposit()](#deposit)
- [open(uint256 id_)](#open)

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

### setCommonLimit

Set the maximum amount of the common potions saled for one account

```solidity
function setCommonLimit(uint256 value_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setCommonLimit(uint256 value_) external;
```
</details>

### setCommonPrice

Set the price of the common potions for the account

```solidity
function setCommonPrice(uint256 value_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New price | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setCommonPrice(uint256 value_) external;
```
</details>

### setRareLimit

Set the maximum amount of the rare potions saled for one account

```solidity
function setRareLimit(uint256 value_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRareLimit(uint256 value_) external;
```
</details>

### setRarePrice

Set the maximum amount of the common potions saled for one account

```solidity
function setRarePrice(uint256 value_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRarePrice(uint256 value_) external;
```
</details>

### setRarePriceIncrease

Set the increase of the rare price

```solidity
function setRarePriceIncrease(uint256 value_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRarePriceIncrease(uint256 value_) external;
```
</details>

### getRarePrice

Get the current rare price

```solidity
function getRarePrice() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getRarePrice() external view returns (uint256);
```
</details>

### getIssued

```solidity
function getIssued(address account_) external view
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getIssued(address account_)

        external

        view

        returns (uint256, uint256);
```
</details>

### create

Create the packed id with rare or not (admin only)

```solidity
function create(address target_, bool rare_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | The box owner | 
| rare_ | bool | The rarity flag | 

**Returns**

The new box id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function create(address target_, bool rare_) external returns (uint256);
```
</details>

### rarity

Get the rarity of the box

```solidity
function rarity(uint256 tokenId_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 | The id of the token | 

**Returns**

The rarity flag

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function rarity(uint256 tokenId_) external view returns (bool);
```
</details>

### deposit

Deposit the funds (payable function)

```solidity
function deposit() external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function deposit() external payable;
```
</details>

### open

Open the packed box

```solidity
function open(uint256 id_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | The box id | 

**Returns**

The new potion id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function open(uint256 id_) external returns (uint256);
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
