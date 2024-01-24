# IOperatorFilterRegistry.sol

View Source: [operator-filter-registry\src\IOperatorFilterRegistry.sol](..\operator-filter-registry\src\IOperatorFilterRegistry.sol)

**IOperatorFilterRegistry**

## Functions

- [isOperatorAllowed(address registrant, address operator)](#isoperatorallowed)
- [register(address registrant)](#register)
- [registerAndSubscribe(address registrant, address subscription)](#registerandsubscribe)
- [registerAndCopyEntries(address registrant, address registrantToCopy)](#registerandcopyentries)
- [unregister(address addr)](#unregister)
- [updateOperator(address registrant, address operator, bool filtered)](#updateoperator)
- [updateOperators(address registrant, address[] operators, bool filtered)](#updateoperators)
- [updateCodeHash(address registrant, bytes32 codehash, bool filtered)](#updatecodehash)
- [updateCodeHashes(address registrant, bytes32[] codeHashes, bool filtered)](#updatecodehashes)
- [subscribe(address registrant, address registrantToSubscribe)](#subscribe)
- [unsubscribe(address registrant, bool copyExistingEntries)](#unsubscribe)
- [subscriptionOf(address addr)](#subscriptionof)
- [subscribers(address registrant)](#subscribers)
- [subscriberAt(address registrant, uint256 index)](#subscriberat)
- [copyEntriesOf(address registrant, address registrantToCopy)](#copyentriesof)
- [isOperatorFiltered(address registrant, address operator)](#isoperatorfiltered)
- [isCodeHashOfFiltered(address registrant, address operatorWithCode)](#iscodehashoffiltered)
- [isCodeHashFiltered(address registrant, bytes32 codeHash)](#iscodehashfiltered)
- [filteredOperators(address addr)](#filteredoperators)
- [filteredCodeHashes(address addr)](#filteredcodehashes)
- [filteredOperatorAt(address registrant, uint256 index)](#filteredoperatorat)
- [filteredCodeHashAt(address registrant, uint256 index)](#filteredcodehashat)
- [isRegistered(address addr)](#isregistered)
- [codeHashOf(address addr)](#codehashof)

### isOperatorAllowed

```solidity
function isOperatorAllowed(address registrant, address operator) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| operator | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isOperatorAllowed(address registrant, address operator) external view returns (bool);
```
</details>

### register

```solidity
function register(address registrant) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function register(address registrant) external;
```
</details>

### registerAndSubscribe

```solidity
function registerAndSubscribe(address registrant, address subscription) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| subscription | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function registerAndSubscribe(address registrant, address subscription) external;
```
</details>

### registerAndCopyEntries

```solidity
function registerAndCopyEntries(address registrant, address registrantToCopy) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| registrantToCopy | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function registerAndCopyEntries(address registrant, address registrantToCopy) external;
```
</details>

### unregister

```solidity
function unregister(address addr) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function unregister(address addr) external;
```
</details>

### updateOperator

```solidity
function updateOperator(address registrant, address operator, bool filtered) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| operator | address |  | 
| filtered | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function updateOperator(address registrant, address operator, bool filtered) external;
```
</details>

### updateOperators

```solidity
function updateOperators(address registrant, address[] operators, bool filtered) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| operators | address[] |  | 
| filtered | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
```
</details>

### updateCodeHash

```solidity
function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| codehash | bytes32 |  | 
| filtered | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
```
</details>

### updateCodeHashes

```solidity
function updateCodeHashes(address registrant, bytes32[] codeHashes, bool filtered) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| codeHashes | bytes32[] |  | 
| filtered | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
```
</details>

### subscribe

```solidity
function subscribe(address registrant, address registrantToSubscribe) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| registrantToSubscribe | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function subscribe(address registrant, address registrantToSubscribe) external;
```
</details>

### unsubscribe

```solidity
function unsubscribe(address registrant, bool copyExistingEntries) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| copyExistingEntries | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function unsubscribe(address registrant, bool copyExistingEntries) external;
```
</details>

### subscriptionOf

```solidity
function subscriptionOf(address addr) external nonpayable
returns(registrant address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function subscriptionOf(address addr) external returns (address registrant);
```
</details>

### subscribers

```solidity
function subscribers(address registrant) external nonpayable
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function subscribers(address registrant) external returns (address[] memory);
```
</details>

### subscriberAt

```solidity
function subscriberAt(address registrant, uint256 index) external nonpayable
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function subscriberAt(address registrant, uint256 index) external returns (address);
```
</details>

### copyEntriesOf

```solidity
function copyEntriesOf(address registrant, address registrantToCopy) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| registrantToCopy | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function copyEntriesOf(address registrant, address registrantToCopy) external;
```
</details>

### isOperatorFiltered

```solidity
function isOperatorFiltered(address registrant, address operator) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| operator | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isOperatorFiltered(address registrant, address operator) external returns (bool);
```
</details>

### isCodeHashOfFiltered

```solidity
function isCodeHashOfFiltered(address registrant, address operatorWithCode) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| operatorWithCode | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
```
</details>

### isCodeHashFiltered

```solidity
function isCodeHashFiltered(address registrant, bytes32 codeHash) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| codeHash | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
```
</details>

### filteredOperators

```solidity
function filteredOperators(address addr) external nonpayable
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function filteredOperators(address addr) external returns (address[] memory);
```
</details>

### filteredCodeHashes

```solidity
function filteredCodeHashes(address addr) external nonpayable
returns(bytes32[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function filteredCodeHashes(address addr) external returns (bytes32[] memory);
```
</details>

### filteredOperatorAt

```solidity
function filteredOperatorAt(address registrant, uint256 index) external nonpayable
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function filteredOperatorAt(address registrant, uint256 index) external returns (address);
```
</details>

### filteredCodeHashAt

```solidity
function filteredCodeHashAt(address registrant, uint256 index) external nonpayable
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| registrant | address |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
```
</details>

### isRegistered

```solidity
function isRegistered(address addr) external nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isRegistered(address addr) external returns (bool);
```
</details>

### codeHashOf

```solidity
function codeHashOf(address addr) external nonpayable
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| addr | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function codeHashOf(address addr) external returns (bytes32);
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
