# A rights access contract (Rights.sol)

View Source: [\contracts\utils\Rights.sol](..\contracts\utils\Rights.sol)

**↗ Extends: [AccessControl](AccessControl.md), [Ownable](Ownable.md), [IRights](IRights.md)**

**Rights**

This contract manage all access rights for the contracts

## Modifiers

- [onlyAdmin](#onlyadmin)

### onlyAdmin

available only for Rights admin

```js
modifier onlyAdmin() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [constructor()](#)
- [packAddress(address contract_)](#packaddress)
- [addAdmin(address admin_)](#addadmin)
- [addAdmin(address contract_, address admin_)](#addadmin)
- [removeAdmin(address admin_)](#removeadmin)
- [removeAdmin(address contract_, address admin_)](#removeadmin)
- [haveRights(address contract_)](#haverights)
- [haveRights(address contract_, address admin_)](#haverights)

### 

constructor

```solidity
function () public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor() {

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

    }
```
</details>

### packAddress

```solidity
function packAddress(address contract_) internal pure
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contract_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function packAddress(address contract_) internal pure returns (bytes32) {

        return keccak256(abi.encodePacked(contract_));

    }
```
</details>

### addAdmin

Add a new admin for the Rigths contract

```solidity
function addAdmin(address admin_) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| admin_ | address | New admin address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addAdmin(address admin_) external override onlyAdmin {

        _setupRole(DEFAULT_ADMIN_ROLE, admin_);

        emit AdminAdded(admin_);

    }
```
</details>

### addAdmin

Add a new admin for the any other contract

```solidity
function addAdmin(address contract_, address admin_) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contract_ | address | Contract address packed into address | 
| admin_ | address | New admin address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addAdmin(address contract_, address admin_)

        external

        override

        onlyAdmin

    {

        require(address(this) != contract_, "Rights: cannot set this contract");

        _setupRole(packAddress(contract_), admin_);

        emit AdminDefined(admin_, contract_);

    }
```
</details>

### removeAdmin

Remove the existing admin from the Rigths contract

```solidity
function removeAdmin(address admin_) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| admin_ | address | Admin address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function removeAdmin(address admin_) external override onlyAdmin {

        require(msg.sender != admin_, "Rights: cannot clear itself");

        _revokeRole(DEFAULT_ADMIN_ROLE, admin_);

        emit AdminRemoved(admin_);

    }
```
</details>

### removeAdmin

Remove the existing admin from the specified contract

```solidity
function removeAdmin(address contract_, address admin_) external nonpayable onlyAdmin 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contract_ | address | Contract address packed into address | 
| admin_ | address | Admin address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function removeAdmin(address contract_, address admin_)

        external

        override

        onlyAdmin

    {

        require(address(this) != contract_, "Rights: cannot this contract");

        require(msg.sender != admin_, "Rights: cannot clear itself");

        _revokeRole(packAddress(contract_), admin_);

        emit AdminCleared(admin_, contract_);

    }
```
</details>

### haveRights

Get the rights for the contract for the caller

```solidity
function haveRights(address contract_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contract_ | address | Contract address packed into address | 

**Returns**

have rights or not

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function haveRights(address contract_)

        external

        view

        override

        returns (bool)

    {

        return hasRole(packAddress(contract_), msg.sender);

    }
```
</details>

### haveRights

Get the rights for the contract

```solidity
function haveRights(address contract_, address admin_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contract_ | address | Contract address packed into address | 
| admin_ | address | Admin address | 

**Returns**

have rights or not

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function haveRights(address contract_, address admin_)

        external

        view

        override

        returns (bool)

    {

        return hasRole(packAddress(contract_), admin_);

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
