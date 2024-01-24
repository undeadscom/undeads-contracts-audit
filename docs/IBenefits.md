# IBenefits.sol

View Source: [\contracts\persons\interfaces\IBenefits.sol](..\contracts\persons\interfaces\IBenefits.sol)

**↘ Derived Contracts: [Benefits](Benefits.md)**

**IBenefits**

**Events**

```js
event BenefitAdded(address indexed target, uint256  from, uint256  to, uint256  price, uint16  id, uint16  amount, uint8  level);
event BenefitUsed(address indexed target, uint256  id);
event BenefitsCleared(address indexed target);
```

## Functions

- [add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_)](#add)
- [clear(address target_)](#clear)
- [denied(uint256 current_)](#denied)
- [get(address target_, uint256 current_, uint256 price_)](#get)
- [set(address target_, uint256 id_)](#set)
- [read(address target_, uint256 id_)](#read)
- [totalReceivers()](#totalreceivers)
- [listReceivers()](#listreceivers)

### add

Add a new benefit

```solidity
function add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 
| price_ | uint256 | Price of the token | 
| id_ | uint16 | The token id | 
| amount_ | uint16 | The tokens amount | 
| level_ | uint8 | The locked tokens level | 
| from_ | uint256 | The timestamp of start of rule usage | 
| until_ | uint256 | The timestamp of end of rule usage | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(

        address target_,

        uint256 price_,

        uint16 id_,

        uint16 amount_,

        uint8 level_,

        uint256 from_,

        uint256 until_

    ) external;
```
</details>

### clear

Clear user's benefits for the contract

```solidity
function clear(address target_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function clear(address target_) external;
```
</details>

### denied

Check denied id

```solidity
function denied(uint256 current_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| current_ | uint256 | current id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function denied(uint256 current_) external view returns (bool);
```
</details>

### get

Get available user benefit

```solidity
function get(address target_, uint256 current_, uint256 price_) external view
returns(address, uint256, uint256, uint16, uint8, bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 
| current_ | uint256 | current tested token id | 
| price_ | uint256 | the received price | 

**Returns**

benefit id, benefit price, benefit token id, benefit level  (all items can be 0)

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(

        address target_,

        uint256 current_,

        uint256 price_

    )

        external

        view

        returns (

            address,

            uint256,

            uint256,

            uint16,

            uint8,

            bool // is fenefit found

        );
```
</details>

### set

Set  user benefit

```solidity
function set(address target_, uint256 id_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 
| id_ | uint256 | benefit id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(address target_, uint256 id_) external;
```
</details>

### read

Read specific benefit

```solidity
function read(address target_, uint256 id_) external view
returns(struct Structures.Benefit)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 
| id_ | uint256 | benefit id | 

**Returns**

benefit

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function read(address target_, uint256 id_)

        external

        view

        returns (Structures.Benefit memory);
```
</details>

### totalReceivers

Read total count of users received benefits

```solidity
function totalReceivers() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function totalReceivers() external view returns (uint256);
```
</details>

### listReceivers

Read list of the addresses received benefits

```solidity
function listReceivers() external view
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function listReceivers() external view returns (address[] memory);
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
