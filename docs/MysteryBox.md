# MysteryBox.sol

View Source: [\contracts\persons\MysteryBox.sol](..\contracts\persons\MysteryBox.sol)

**↗ Extends: [GuardExtension](GuardExtension.md), [OperatorFiltererERC721](OperatorFiltererERC721.md), [EIP2981](EIP2981.md), [Claimable](Claimable.md), [IMysteryBox](IMysteryBox.md)**

**MysteryBox**

## Contract Members
**Constants & Variables**

```js
uint256 private _tokenIds;
uint256 private _total;
uint256 private _commonLimit;
uint256 private _rareLimit;
uint256 private _commonPrice;
uint256 private _rarePrice;
uint256 private _rarePriceIncrease;
mapping(address => uint256) private _commonIssued;
mapping(address => uint256) private _rareIssued;
contract IPotions private _potion;
contract IBenefits private _benefits;
mapping(address => uint256) private _commonLimits;
mapping(address => uint256) private _rareLimits;
mapping(uint256 => bool) private _rare;
string private constant INCORRECT_PRICE;
string private constant SOLD_OUT;
string private constant NO_MORE_RARE;
string private constant NO_MORE_COMMON;
string private constant SOLD_OUT_RARE;
string private constant SOLD_OUT_COMMON;
string private constant WRONG_OWNER;
string private constant WRONG_ID;
string private constant SAME_VALUE;
string private constant ZERO_ADDRESS;
string private constant BASE_META_HASH;

```

## Modifiers

- [correctId](#correctid)

### correctId

validate the id

```js
modifier correctId(uint256 id_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

## Functions

- [constructor(string name_, string symbol_, address rights_, address potion_, address benefits_, uint256 commonLimit_, uint256 rareLimit_, uint256 commonPrice_, uint256 rarePrice_, uint256 rarePriceIncrease_)](#)
- [total()](#total)
- [setCommonLimit(uint256 value_)](#setcommonlimit)
- [setCommonPrice(uint256 value_)](#setcommonprice)
- [setPotion(address value_)](#setpotion)
- [setBenefits(address value_)](#setbenefits)
- [setRareLimit(uint256 value_)](#setrarelimit)
- [setRarePrice(uint256 value_)](#setrareprice)
- [setRarePriceIncrease(uint256 value_)](#setrarepriceincrease)
- [getRarePrice()](#getrareprice)
- [getIssued(address account_)](#getissued)
- [create(address target_, bool rare_)](#create)
- [_create(address account_, uint8 level_)](#_create)
- [rarity(uint256 tokenId_)](#rarity)
- [deposit()](#deposit)
- [constructor()](#)
- [_create(address account_, uint8 level_, address benTarget_, uint256 benId_, bool benIsFound_, uint256 newTokenId_)](#_create)
- [open(uint256 id_)](#open)
- [tokenURI(uint256 id_)](#tokenuri)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### 

Constructor

```solidity
function (string name_, string symbol_, address rights_, address potion_, address benefits_, uint256 commonLimit_, uint256 rareLimit_, uint256 commonPrice_, uint256 rarePrice_, uint256 rarePriceIncrease_) public nonpayable Guard ERC721 GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name_ | string | The name | 
| symbol_ | string | The symbol | 
| rights_ | address | The rights address | 
| potion_ | address | The potion address | 
| benefits_ | address | The benefits address | 
| commonLimit_ | uint256 | The maximum number of the common potions saled for one account | 
| rareLimit_ | uint256 | The maximum number of the rare potions saled for one account | 
| commonPrice_ | uint256 | The price of the common potion | 
| rarePrice_ | uint256 | The price of the rare potion | 
| rarePriceIncrease_ | uint256 | The increase of the price for each bought rare box | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        string memory name_,

        string memory symbol_,

        address rights_,

        address potion_,

        address benefits_,

        uint256 commonLimit_,

        uint256 rareLimit_,

        uint256 commonPrice_,

        uint256 rarePrice_,

        uint256 rarePriceIncrease_

    ) Guard() ERC721(name_, symbol_) GuardExtension(rights_) {

        require(potion_ != address(0), ZERO_ADDRESS);

        require(benefits_ != address(0), ZERO_ADDRESS);

        _commonLimit = commonLimit_;

        _rareLimit = rareLimit_;

        _commonPrice = commonPrice_;

        _rarePrice = rarePrice_;

        _rarePriceIncrease = rarePriceIncrease_;

        _potion = IPotions(potion_);

        _benefits = IBenefits(benefits_);

        emit CommonLimitDefined(_commonLimit);

        emit CommonPriceDefined(_commonPrice);

        emit RareLimitDefined(_rareLimit);

        emit RarePriceDefined(_rarePrice);

        emit RarePriceIncreaseDefined(_rarePriceIncrease);

    }
```
</details>

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
function total() external view override returns (uint256) {

        return _total;

    }
```
</details>

### setCommonLimit

Set the maximum amount of the common potions saled for one account

```solidity
function setCommonLimit(uint256 value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setCommonLimit(uint256 value_) external override haveRights {

        _commonLimit = value_;

        emit CommonLimitDefined(value_);

    }
```
</details>

### setCommonPrice

Set the price of the common potions for the account

```solidity
function setCommonPrice(uint256 value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New price | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setCommonPrice(uint256 value_) external override haveRights {

        _commonPrice = value_;

        emit CommonPriceDefined(value_);

    }
```
</details>

### setPotion

Set new address of Potion contract

```solidity
function setPotion(address value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | address | New address value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setPotion(address value_) external haveRights {

        require(address(_potion) != value_, SAME_VALUE);

        require(value_ != address(0), ZERO_ADDRESS);

        _potion = IPotions(value_);

    }
```
</details>

### setBenefits

Set new address of Benefits contract

```solidity
function setBenefits(address value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | address | New address value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setBenefits(address value_) external haveRights {

        require(address(_benefits) != value_, SAME_VALUE);

        require(value_ != address(0), ZERO_ADDRESS);

        _benefits = IBenefits(value_);

    }
```
</details>

### setRareLimit

Set the maximum amount of the rare potions saled for one account

```solidity
function setRareLimit(uint256 value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRareLimit(uint256 value_) external override haveRights {

        _rareLimit = value_;

        emit RareLimitDefined(value_);

    }
```
</details>

### setRarePrice

Set the maximum amount of the common potions saled for one account

```solidity
function setRarePrice(uint256 value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRarePrice(uint256 value_) external override haveRights {

        _rarePrice = value_;

        emit RarePriceDefined(value_);

    }
```
</details>

### setRarePriceIncrease

Set the increase of the rare price

```solidity
function setRarePriceIncrease(uint256 value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | uint256 | New amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRarePriceIncrease(uint256 value_) external override haveRights {

        _rarePriceIncrease = value_;

        emit RarePriceIncreaseDefined(_rarePriceIncrease);

    }
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
function getRarePrice() external view override returns (uint256) {

        return _rarePrice;

    }
```
</details>

### getIssued

Get the amount of the tokens account can buy

```solidity
function getIssued(address account_) external view
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account_ | address |  | 

**Returns**

The two uint's - amount of the common potions and amount of the rare potions

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getIssued(address account_)

        external

        view

        override

        returns (uint256, uint256)

    {

        return (_commonIssued[account_], _rareIssued[account_]);

    }
```
</details>

### create

Create the packed id with rare or not (admin only)

```solidity
function create(address target_, bool rare_) external nonpayable haveRights 
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
function create(address target_, bool rare_)

        external

        override

        haveRights

        returns (uint256)

    {

        return _create(target_, rare_ ? 1 : 0);

    }
```
</details>

### _create

```solidity
function _create(address account_, uint8 level_) private nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account_ | address |  | 
| level_ | uint8 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _create(address account_, uint8 level_) private returns (uint256) {

        return _create(account_, level_, account_, 0, false, 0);

    }
```
</details>

### rarity

Get the rarity of the box

```solidity
function rarity(uint256 tokenId_) external view correctId 
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
function rarity(uint256 tokenId_)

        external

        view

        override

        correctId(tokenId_)

        returns (bool)

    {

        return _rare[tokenId_];

    }
```
</details>

### deposit

Deposit the funds (payable function)

```solidity
function deposit() external payable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function deposit() external payable override haveRights {}
```
</details>

### 

Receive the funds and give the box with rarity according to the amount of funds transferred
Look the event to get the ID (receive functions cannot return values)

```solidity
function () external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
receive() external payable {

        (

            address target,

            uint256 benId,

            uint256 price,

            uint16 tokenId,

            uint8 level,

            bool isBenFound

        ) = _benefits.get(msg.sender, 0, msg.value);

        // found benefit with custom price

        if (price > 0) {

            require(price == msg.value, INCORRECT_PRICE);

            if (target == address(0) && level == 0) {

                require(

                    _commonLimit > _commonIssued[msg.sender],

                    NO_MORE_COMMON

                );

            }

            // here the first reserved item must be

            _create(msg.sender, level, target, benId, isBenFound, tokenId);

            return;

        }

        require(

            _rarePrice == msg.value || _commonPrice == msg.value,

            INCORRECT_PRICE

        );

        if (isBenFound) {

            if (level > 0) {

                require(_rarePrice == msg.value, INCORRECT_PRICE);

                _create(msg.sender, level, target, benId, isBenFound, tokenId);

            } else {

                require(_commonPrice == msg.value, INCORRECT_PRICE);

                _create(

                    msg.sender,

                    level,

                    target,

                    benId,

                    isBenFound,

                    tokenId == 0 ? _tokenIds : tokenId

                );

            }

            return;

        }

        // nothing found, let's check ordinary

        if (_rarePrice == msg.value) {

            _create(msg.sender, level, target, benId, false, tokenId);

        } else {

            require(_commonLimit > _commonIssued[msg.sender], NO_MORE_COMMON);

            _create(msg.sender, level, target, benId, false, tokenId);

        }

    }
```
</details>

### _create

```solidity
function _create(address account_, uint8 level_, address benTarget_, uint256 benId_, bool benIsFound_, uint256 newTokenId_) private nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| account_ | address |  | 
| level_ | uint8 |  | 
| benTarget_ | address |  | 
| benId_ | uint256 |  | 
| benIsFound_ | bool |  | 
| newTokenId_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _create(

        address account_,

        uint8 level_,

        address benTarget_,

        uint256 benId_,

        bool benIsFound_,

        uint256 newTokenId_

    ) private returns (uint256) {

        bool isRare = level_ > 0;

        if (isRare && newTokenId_ != 1) {

            _rarePrice = _rarePrice + _rarePriceIncrease;

        }

        IBenefits benefits = _benefits;

        if (isRare) {

            require(_rareLimit > _rareIssued[account_], NO_MORE_RARE);

            require(_potion.decreaseAmount(true), SOLD_OUT_RARE);

            _rareIssued[account_] = _rareIssued[account_] + 1;

        } else {

            require(_potion.decreaseAmount(false), SOLD_OUT_COMMON);

            _commonIssued[account_] = _commonIssued[account_] + 1;

        }

        uint256 newId = newTokenId_ == 0 ? _tokenIds : newTokenId_;

        if (newTokenId_ == 0) {

            do {

                newId = newId + 1;

            } while (benefits.denied(newId));

            _tokenIds = newId;

        }

        _rare[newId] = isRare;

        _mint(account_, newId);

        if (benIsFound_) {

            benefits.set(benTarget_, benId_);

        }

        emit Created(account_, newId, isRare);

        _total += 1;

        return newId;

    }
```
</details>

### open

Open the packed box

```solidity
function open(uint256 id_) external nonpayable correctId 
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
function open(uint256 id_)

        external

        override

        correctId(id_)

        returns (uint256)

    {

        require(ownerOf(id_) == msg.sender, WRONG_OWNER);

        uint256 newId = _potion.create(msg.sender, _rare[id_], id_);

        delete _rare[id_];

        _burn(id_);

        emit Opened(msg.sender, newId);

        return newId;

    }
```
</details>

### tokenURI

Returns the Uniform Resource Identifier (URI) for `tokenId` token.

```solidity
function tokenURI(uint256 id_) public view correctId 
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenURI(uint256 id_)

        public

        view

        override(ERC721, IERC721Metadata)

        correctId(id_)

        returns (string memory)

    {

        if (id_ < 12) {

            return

                string(

                    abi.encodePacked(

                        BASE_META_HASH,

                        "legendary/",

                        id_.toString(),

                        "/meta.json"

                    )

                );

        } else {

            return

                string(

                    abi.encodePacked(

                        BASE_META_HASH,

                        "mystery/",

                        id_.toString(),

                        "/meta.json"

                    )

                );

        }

    }
```
</details>

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| interfaceId | bytes4 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function supportsInterface(bytes4 interfaceId)

        public

        view

        virtual

        override(IERC165, ERC721, ERC2981)

        returns (bool)

    {

        return super.supportsInterface(interfaceId);

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
