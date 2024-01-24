# Voting.sol

View Source: [\contracts\manage\Voting.sol](..\contracts\manage\Voting.sol)

**↘ Derived Contracts: [Management](Management.md)**

**Voting**

## Structs
### VoteData

```js
struct VoteData {
 mapping(address => bool) voters,
 uint256 minimal,
 uint256 voted,
 bytes32 value,
 bool closed
}
```

## Contract Members
**Constants & Variables**

```js
mapping(bytes32 => struct Voting.VoteData) internal _votes;

```

## Modifiers

- [notVoted](#notvoted)

### notVoted

```js
modifier notVoted(bytes32 code) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 

## Functions

- [hasVote(bytes32 code, address account)](#hasvote)
- [_closeVote(bytes32 code)](#_closevote)
- [_openVote(bytes32 code, uint256 minimal, bytes32 value)](#_openvote)
- [_vote(bytes32 code, bytes32 value)](#_vote)
- [_vote(bytes32 code, address voter, bytes32 value)](#_vote)
- [isVoteExists(bytes32 code)](#isvoteexists)
- [isVoteResolved(bytes32 code)](#isvoteresolved)

### hasVote

```solidity
function hasVote(bytes32 code, address account) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function hasVote(bytes32 code, address account) public view returns (bool) {

        return _votes[code].voters[account];

    }
```
</details>

### _closeVote

```solidity
function _closeVote(bytes32 code) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _closeVote(bytes32 code) internal {

        _votes[code].closed = true;

    }
```
</details>

### _openVote

```solidity
function _openVote(bytes32 code, uint256 minimal, bytes32 value) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 
| minimal | uint256 |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _openVote(

        bytes32 code,

        uint256 minimal,

        bytes32 value

    ) internal {

        require(!isVoteExists(code), "Voting: already initialized");

        require(minimal > 0, "Voting: at least 1 vote needed");

        VoteData storage v = _votes[code];

        v.minimal = minimal;

        v.value = value;

        v.voted = 0;

    }
```
</details>

### _vote

```solidity
function _vote(bytes32 code, bytes32 value) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _vote(bytes32 code, bytes32 value) internal {

        _vote(code, msg.sender, value);

    }
```
</details>

### _vote

```solidity
function _vote(bytes32 code, address voter, bytes32 value) internal nonpayable notVoted 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 
| voter | address |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _vote(

        bytes32 code,

        address voter,

        bytes32 value

    ) internal notVoted(code) {

        require(isVoteExists(code), "Voting: no voting");

        require(_votes[code].value == value, "Voting: wrong value");

        _votes[code].voted = _votes[code].voted + 1;

        _votes[code].voters[voter] = true;

    }
```
</details>

### isVoteExists

```solidity
function isVoteExists(bytes32 code) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isVoteExists(bytes32 code) public view virtual returns (bool) {

        return !_votes[code].closed && _votes[code].minimal > 0;

    }
```
</details>

### isVoteResolved

```solidity
function isVoteResolved(bytes32 code) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| code | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isVoteResolved(bytes32 code) public view virtual returns (bool) {

        return _votes[code].voted >= _votes[code].minimal;

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
