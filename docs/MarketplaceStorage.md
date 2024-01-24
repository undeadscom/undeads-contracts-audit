# MarketplaceStorage.sol

View Source: [\contracts\marketplace\MarketplaceStorage.sol](..\contracts\marketplace\MarketplaceStorage.sol)

**↗ Extends: [IMarketplaceStorage](IMarketplaceStorage.md), [ERC721Holder](ERC721Holder.md), [ERC1155Holder](ERC1155Holder.md), [ReentrancyGuard](ReentrancyGuard.md), [GuardExtension](GuardExtension.md)**

**MarketplaceStorage**

## Contract Members
**Constants & Variables**

```js
//internal members
struct Counters.Counter internal itemsCounter;

//private members
mapping(uint256 => struct IMarketplaceStorage.TokenData) private _allTokens;

//public members
mapping(address => bool) public approvedCollections;

```

## Functions

- [constructor(address rights_)](#)
- [depositTokens(uint256 tokenId_, uint256 amount_, address tokenAddress_, address owner_, enum IMarketplaceStorage.TokenStandard tokenStandard_)](#deposittokens)
- [transferTokens(uint256 packageId_, address receiver_)](#transfertokens)
- [approveCollections(address[] collections_, bool enabled_)](#approvecollections)
- [getTokenData(uint256 id_)](#gettokendata)

### 

Constructor

```solidity
function (address rights_) public nonpayable GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rights_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(address rights_) GuardExtension(rights_) {}
```
</details>

### depositTokens

Function to deposit tokens to marketplace

```solidity
function depositTokens(uint256 tokenId_, uint256 amount_, address tokenAddress_, address owner_, enum IMarketplaceStorage.TokenStandard tokenStandard_) external nonpayable haveRights 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenId_ | uint256 |  | 
| amount_ | uint256 |  | 
| tokenAddress_ | address |  | 
| owner_ | address |  | 
| tokenStandard_ | enum IMarketplaceStorage.TokenStandard |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function depositTokens(

        uint256 tokenId_,

        uint256 amount_,

        address tokenAddress_,

        address owner_,

        TokenStandard tokenStandard_

    ) external haveRights returns (uint256) {

        if (tokenStandard_ == TokenStandard.ERC721) {

            IERC721(tokenAddress_).transferFrom(

                owner_,

                address(this),

                tokenId_

            );

        } else {

            IERC1155(tokenAddress_).safeTransferFrom(

                owner_,

                address(this),

                tokenId_,

                amount_,

                ""

            );

        }

        Counters.increment(itemsCounter);

        uint256 current = Counters.current(itemsCounter);

        _allTokens[current] = TokenData({

            tokenId: tokenId_,

            tokenAddress: tokenAddress_,

            amount: amount_,

            owner: owner_,

            tokenStandard: tokenStandard_

        });

        return current;

    }
```
</details>

### transferTokens

Function to send tokens

```solidity
function transferTokens(uint256 packageId_, address receiver_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| packageId_ | uint256 |  | 
| receiver_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function transferTokens(

        uint256 packageId_,

        address receiver_

    ) external haveRights {

        TokenData memory package = _allTokens[packageId_];

        if (package.tokenStandard == TokenStandard.ERC721) {

            IERC721(package.tokenAddress).safeTransferFrom(

                address(this),

                receiver_,

                package.tokenId

            );

        } else {

            IERC1155(package.tokenAddress).safeTransferFrom(

                address(this),

                receiver_,

                package.tokenId,

                package.amount,

                ""

            );

        }

        delete _allTokens[packageId_];

    }
```
</details>

### approveCollections

```solidity
function approveCollections(address[] collections_, bool enabled_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| collections_ | address[] |  | 
| enabled_ | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function approveCollections(

        address[] calldata collections_,

        bool enabled_

    ) external haveRights {

        for (uint256 index = 0; index < collections_.length; index++) {

            approvedCollections[collections_[index]] = enabled_;

        }

    }
```
</details>

### getTokenData

```solidity
function getTokenData(uint256 id_) external view
returns(struct IMarketplaceStorage.TokenData)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getTokenData(

        uint256 id_

    ) external view returns (TokenData memory) {

        return _allTokens[id_];

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
