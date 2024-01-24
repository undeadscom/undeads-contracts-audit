# IERC721.sol

View Source: [@openzeppelin\contracts\token\ERC721\IERC721.sol](..\@openzeppelin\contracts\token\ERC721\IERC721.sol)

**↗ Extends: [IERC165](IERC165.md)**
**↘ Derived Contracts: [ERC721](ERC721.md), [IERC721Metadata](IERC721Metadata.md)**

**IERC721**

Required interface of an ERC721 compliant contract.

**Events**

```js
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
event ApprovalForAll(address indexed owner, address indexed operator, bool  approved);
```

## Functions

- [balanceOf(address owner)](#balanceof)
- [ownerOf(uint256 tokenId)](#ownerof)
- [safeTransferFrom(address from, address to, uint256 tokenId, bytes data)](#safetransferfrom)
- [safeTransferFrom(address from, address to, uint256 tokenId)](#safetransferfrom)
- [transferFrom(address from, address to, uint256 tokenId)](#transferfrom)
- [approve(address to, uint256 tokenId)](#approve)
- [setApprovalForAll(address operator, bool _approved)](#setapprovalforall)
- [getApproved(uint256 tokenId)](#getapproved)
- [isApprovedForAll(address owner, address operator)](#isapprovedforall)

### balanceOf

Returns the number of tokens in ``owner``'s account.

```solidity
function balanceOf(address owner) external view
returns(balance uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function balanceOf(address owner) external view returns (uint256 balance);
```
</details>

### ownerOf

Returns the owner of the `tokenId` token.
 Requirements:
 - `tokenId` must exist.

```solidity
function ownerOf(uint256 tokenId) external view
returns(owner address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function ownerOf(uint256 tokenId) external view returns (address owner);
```
</details>

### safeTransferFrom

Safely transfers `tokenId` token from `from` to `to`.
 Requirements:
 - `from` cannot be the zero address.
 - `to` cannot be the zero address.
 - `tokenId` token must exist and be owned by `from`.
 - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
 - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
 Emits a {Transfer} event.

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) external nonpayable
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
        bytes calldata data
    ) external;
```
</details>

### safeTransferFrom

Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
 are aware of the ERC721 protocol to prevent tokens from being forever locked.
 Requirements:
 - `from` cannot be the zero address.
 - `to` cannot be the zero address.
 - `tokenId` token must exist and be owned by `from`.
 - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
 - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
 Emits a {Transfer} event.

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) external nonpayable
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
    ) external;
```
</details>

### transferFrom

Transfers `tokenId` token from `from` to `to`.
 WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
 or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
 understand this adds an external call which potentially creates a reentrancy vulnerability.
 Requirements:
 - `from` cannot be the zero address.
 - `to` cannot be the zero address.
 - `tokenId` token must be owned by `from`.
 - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
 Emits a {Transfer} event.

```solidity
function transferFrom(address from, address to, uint256 tokenId) external nonpayable
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
    ) external;
```
</details>

### approve

Gives permission to `to` to transfer `tokenId` token to another account.
 The approval is cleared when the token is transferred.
 Only a single account can be approved at a time, so approving the zero address clears previous approvals.
 Requirements:
 - The caller must own the token or be an approved operator.
 - `tokenId` must exist.
 Emits an {Approval} event.

```solidity
function approve(address to, uint256 tokenId) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| to | address |  | 
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function approve(address to, uint256 tokenId) external;
```
</details>

### setApprovalForAll

Approve or remove `operator` as an operator for the caller.
 Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
 Requirements:
 - The `operator` cannot be the caller.
 Emits an {ApprovalForAll} event.

```solidity
function setApprovalForAll(address operator, bool _approved) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| operator | address |  | 
| _approved | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setApprovalForAll(address operator, bool _approved) external;
```
</details>

### getApproved

Returns the account approved for `tokenId` token.
 Requirements:
 - `tokenId` must exist.

```solidity
function getApproved(uint256 tokenId) external view
returns(operator address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getApproved(uint256 tokenId) external view returns (address operator);
```
</details>

### isApprovedForAll

Returns if the `operator` is allowed to manage all of the assets of `owner`.
 See {setApprovalForAll}

```solidity
function isApprovedForAll(address owner, address operator) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner | address |  | 
| operator | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isApprovedForAll(address owner, address operator) external view returns (bool);
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
