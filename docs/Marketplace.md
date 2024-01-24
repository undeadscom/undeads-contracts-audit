# Marketplace.sol

View Source: [\contracts\marketplace\Marketplace.sol](..\contracts\marketplace\Marketplace.sol)

**↗ Extends: [ReentrancyGuard](ReentrancyGuard.md), [GuardExtension](GuardExtension.md)**

**Marketplace**

## Structs
### Listing

```js
struct Listing {
 uint256 price,
 address paymentAsset
}
```

## Contract Members
**Constants & Variables**

```js
//private members
string private constant SAME_VALUE;
mapping(uint256 => struct Marketplace.Listing) private _prices;

//public members
contract IMarketplaceStorage public marketplaceStorage;
contract IMarketplaceTreasury public marketplaceTreasury;

```

**Events**

```js
event ItemListed(address indexed seller, address indexed tokenAddress, uint256 indexed tokenId, uint256  id, uint256  amount, uint256  price, address  paymentAsset);
event ItemUpdated(address indexed seller, address indexed tokenAddress, uint256 indexed tokenId, uint256  id, uint256  amount, uint256  price, address  paymentAsset);
event ItemCanceled(address indexed seller, address indexed tokenAddress, uint256 indexed tokenId, uint256  id);
event ItemBought(address indexed buyer, address indexed tokenAddress, uint256 indexed tokenId, uint256  id, uint256  amount, uint256  price, address  paymentAsset);
```

## Modifiers

- [validatePrice](#validateprice)
- [validateAmount](#validateamount)
- [validatePaymentAsset](#validatepaymentasset)
- [ensureERC721](#ensureerc721)
- [ensureERC1155](#ensureerc1155)

### validatePrice

```js
modifier validatePrice(uint256 price_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| price_ | uint256 |  | 

### validateAmount

```js
modifier validateAmount(uint256 amount_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| amount_ | uint256 |  | 

### validatePaymentAsset

```js
modifier validatePaymentAsset(address paymentAsset_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| paymentAsset_ | address |  | 

### ensureERC721

```js
modifier ensureERC721(address tokenAddress_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenAddress_ | address |  | 

### ensureERC1155

```js
modifier ensureERC1155(address tokenAddress_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenAddress_ | address |  | 

## Functions

- [constructor(address marketplaceStorage_, address payable marketplaceTreasury_, address rights_)](#)
- [listERC1155Item(address tokenAddress_, uint256 tokenId_, uint256 amount_, uint256 price_, address paymentAsset_)](#listerc1155item)
- [listERC721Item(address tokenAddress_, uint256 tokenId_, uint256 price_, address paymentAsset_)](#listerc721item)
- [cancelListing(uint256 id_)](#cancellisting)
- [buyItem(uint256 id_)](#buyitem)
- [updateListing(uint256 id_, uint256 newPrice_, address newPaymentAsset_)](#updatelisting)
- [getListing(uint256 id_)](#getlisting)

### 

Constructor

```solidity
function (address marketplaceStorage_, address payable marketplaceTreasury_, address rights_) public nonpayable GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| marketplaceStorage_ | address |  | 
| marketplaceTreasury_ | address payable |  | 
| rights_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        address marketplaceStorage_,

        address payable marketplaceTreasury_,

        address rights_

    ) GuardExtension(rights_) {

        marketplaceStorage = IMarketplaceStorage(marketplaceStorage_);

        marketplaceTreasury = IMarketplaceTreasury(marketplaceTreasury_);

    }
```
</details>

### listERC1155Item

```solidity
function listERC1155Item(address tokenAddress_, uint256 tokenId_, uint256 amount_, uint256 price_, address paymentAsset_) external nonpayable validatePrice validateAmount validatePaymentAsset ensureERC1155 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenAddress_ | address |  | 
| tokenId_ | uint256 |  | 
| amount_ | uint256 |  | 
| price_ | uint256 |  | 
| paymentAsset_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function listERC1155Item(

        address tokenAddress_,

        uint256 tokenId_,

        uint256 amount_,

        uint256 price_,

        address paymentAsset_

    )

        external

        validatePrice(price_)

        validateAmount(amount_)

        validatePaymentAsset(paymentAsset_)

        ensureERC1155(tokenAddress_)

    {

        IERC1155 nft = IERC1155(tokenAddress_);

        require(

            nft.balanceOf(msg.sender, tokenId_) >= amount_,

            "Not enought nfts"

        );

        uint256 id = marketplaceStorage.depositTokens(

            tokenId_,

            amount_,

            tokenAddress_,

            msg.sender,

            IMarketplaceStorage.TokenStandard.ERC1155

        );

        _prices[id] = Listing({price: price_, paymentAsset: paymentAsset_});

        emit ItemListed(

            msg.sender,

            tokenAddress_,

            tokenId_,

            id,

            amount_,

            price_,

            paymentAsset_

        );

    }
```
</details>

### listERC721Item

```solidity
function listERC721Item(address tokenAddress_, uint256 tokenId_, uint256 price_, address paymentAsset_) external nonpayable validatePrice validatePaymentAsset ensureERC721 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| tokenAddress_ | address |  | 
| tokenId_ | uint256 |  | 
| price_ | uint256 |  | 
| paymentAsset_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function listERC721Item(

        address tokenAddress_,

        uint256 tokenId_,

        uint256 price_,

        address paymentAsset_

    )

        external

        validatePrice(price_)

        validatePaymentAsset(paymentAsset_)

        ensureERC721(tokenAddress_)

    {

        IERC721 nft = IERC721(tokenAddress_);

        require(nft.ownerOf(tokenId_) == msg.sender, "Not owner");

        uint256 id = marketplaceStorage.depositTokens(

            tokenId_,

            1,

            tokenAddress_,

            msg.sender,

            IMarketplaceStorage.TokenStandard.ERC721

        );

        _prices[id] = Listing({price: price_, paymentAsset: paymentAsset_});

        emit ItemListed(

            msg.sender,

            tokenAddress_,

            tokenId_,

            id,

            1,

            price_,

            paymentAsset_

        );

    }
```
</details>

### cancelListing

```solidity
function cancelListing(uint256 id_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function cancelListing(uint256 id_) external {

        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage

            .getTokenData(id_);

        require(msg.sender == tokenData.owner, "Not owner");

        marketplaceStorage.transferTokens(id_, tokenData.owner);

        delete _prices[id_];

        emit ItemCanceled(

            tokenData.owner,

            tokenData.tokenAddress,

            tokenData.tokenId,

            id_

        );

    }
```
</details>

### buyItem

```solidity
function buyItem(uint256 id_) external payable nonReentrant 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function buyItem(uint256 id_) external payable nonReentrant {

        Listing memory listing = _prices[id_];

        require(listing.price > 0, "Item not exists");

        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage

            .getTokenData(id_);

        require(tokenData.owner != msg.sender, "Trying to buy own item");

        // send funds to the treasury

        if (listing.paymentAsset == address(0x0)) {

            require(msg.value >= listing.price, "Price not met");

            payable(address(marketplaceTreasury)).sendValue(msg.value);

        } else {

            bool success = IERC20(listing.paymentAsset).transferFrom(

                msg.sender,

                address(marketplaceTreasury),

                listing.price

            );

            require(success, "Can't transfer to treasury");

        }

        if (

            IERC165(tokenData.tokenAddress).supportsInterface(

                type(IERC2981).interfaceId

            )

        ) {

            (address receiver, uint256 royaltyAmount) = IERC2981(

                tokenData.tokenAddress

            ).royaltyInfo(tokenData.tokenId, listing.price);

            marketplaceTreasury.addFunds(

                listing.paymentAsset,

                receiver,

                royaltyAmount

            );

            marketplaceTreasury.addFunds(

                listing.paymentAsset,

                tokenData.owner,

                listing.price - royaltyAmount

            );

        } else {

            marketplaceTreasury.addFunds(

                listing.paymentAsset,

                tokenData.owner,

                listing.price

            );

        }

        delete _prices[id_];

        marketplaceStorage.transferTokens(id_, msg.sender);

        emit ItemBought(

            msg.sender,

            tokenData.tokenAddress,

            tokenData.tokenId,

            id_,

            tokenData.amount,

            listing.price,

            listing.paymentAsset

        );

    }
```
</details>

### updateListing

```solidity
function updateListing(uint256 id_, uint256 newPrice_, address newPaymentAsset_) external nonpayable validatePrice validatePaymentAsset 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 
| newPrice_ | uint256 |  | 
| newPaymentAsset_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function updateListing(

        uint256 id_,

        uint256 newPrice_,

        address newPaymentAsset_

    ) external validatePrice(newPrice_) validatePaymentAsset(newPaymentAsset_) {

        IMarketplaceStorage.TokenData memory tokenData = marketplaceStorage

            .getTokenData(id_);

        require(tokenData.owner == msg.sender, "Not owner");

        _prices[id_] = Listing({

            price: newPrice_,

            paymentAsset: newPaymentAsset_

        });

        emit ItemUpdated(

            msg.sender,

            tokenData.tokenAddress,

            tokenData.tokenId,

            id_,

            tokenData.amount,

            newPrice_,

            newPaymentAsset_

        );

    }
```
</details>

### getListing

```solidity
function getListing(uint256 id_) external view
returns(tokenData struct IMarketplaceStorage.TokenData, listing struct Marketplace.Listing)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getListing(

        uint256 id_

    )

        external

        view

        returns (

            IMarketplaceStorage.TokenData memory tokenData,

            Listing memory listing

        )

    {

        tokenData = marketplaceStorage.getTokenData(id_);

        listing = _prices[id_];

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
