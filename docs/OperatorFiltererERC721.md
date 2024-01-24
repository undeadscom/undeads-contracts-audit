# OperatorFiltererERC721.sol

View Source: [\contracts\utils\OperatorFiltererERC721.sol](..\contracts\utils\OperatorFiltererERC721.sol)

**↗ Extends: [ERC721](ERC721.md), [DefaultOperatorFilterer](DefaultOperatorFilterer.md), [Ownable](Ownable.md)**
**↘ Derived Contracts: [Actors](Actors.md), [Humans](Humans.md), [MysteryBox](MysteryBox.md), [Potions](Potions.md)**

**OperatorFiltererERC721**

## Functions

- [setApprovalForAll(address operator, bool approved)](#setapprovalforall)
- [approve(address operator, uint256 tokenId)](#approve)
- [transferFrom(address from, address to, uint256 tokenId)](#transferfrom)
- [safeTransferFrom(address from, address to, uint256 tokenId)](#safetransferfrom)
- [safeTransferFrom(address from, address to, uint256 tokenId, bytes data)](#safetransferfrom)

### setApprovalForAll

See {IERC721-setApprovalForAll}.
      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.

```solidity
function setApprovalForAll(address operator, bool approved) public nonpayable onlyAllowedOperatorApproval 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address |  | 
| approved | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setApprovalForAll(address operator, bool approved)

        public

        override

        onlyAllowedOperatorApproval(operator)

    {

        super.setApprovalForAll(operator, approved);

    }
```
</details>

### approve

See {IERC721-approve}.
      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.

```solidity
function approve(address operator, uint256 tokenId) public nonpayable onlyAllowedOperatorApproval 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address |  | 
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function approve(address operator, uint256 tokenId)

        public

        override

        onlyAllowedOperatorApproval(operator)

    {

        super.approve(operator, tokenId);

    }
```
</details>

### transferFrom

See {IERC721-transferFrom}.
      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.

```solidity
function transferFrom(address from, address to, uint256 tokenId) public nonpayable onlyAllowedOperator 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function transferFrom(

        address from,

        address to,

        uint256 tokenId

    ) public override onlyAllowedOperator(from) {

        super.transferFrom(from, to, tokenId);

    }
```
</details>

### safeTransferFrom

See {IERC721-safeTransferFrom}.
      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) public nonpayable onlyAllowedOperator 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId

    ) public override onlyAllowedOperator(from) {

        super.safeTransferFrom(from, to, tokenId);

    }
```
</details>

### safeTransferFrom

See {IERC721-safeTransferFrom}.
      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) public nonpayable onlyAllowedOperator 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| from | address |  | 
| to | address |  | 
| tokenId | uint256 |  | 
| data | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function safeTransferFrom(

        address from,

        address to,

        uint256 tokenId,

        bytes memory data

    ) public override onlyAllowedOperator(from) {

        super.safeTransferFrom(from, to, tokenId, data);

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
