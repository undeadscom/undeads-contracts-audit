# A rights access contract (Benefits.sol)

View Source: [\contracts\persons\Benefits.sol](..\contracts\persons\Benefits.sol)

**↗ Extends: [IBenefits](IBenefits.md), [GuardExtensionUpgradeable](GuardExtensionUpgradeable.md)**

**Benefits**

This contract manage all user's benefits

## Contract Members
**Constants & Variables**

```js
struct Counters.Counter private _ids;
struct Counters.Counter private _deletedIds;
struct BitMaps.BitMap private _used;
mapping(address => struct Structures.Benefit[]) private _benefits;
mapping(address => uint256) private _receiverIds;
mapping(uint256 => address) private _receivers;
string private constant ALREADY_SET;
string private constant WRONG_TARGET;
string private constant OVERUSAGE;
mapping(address => mapping(uint256 => uint256)) private _additionalIssued;

```

## Functions

- [initialize(address rights_)](#initialize)
- [addBatch(address[] targets_, uint256[] prices_, uint16[] ids_, uint16[] amounts_, uint8[] levels_, uint256[] froms_, uint256[] untils_)](#addbatch)
- [add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_)](#add)
- [_add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_)](#_add)
- [clear(address target_)](#clear)
- [denied(uint256 current_)](#denied)
- [get(address target_, uint256 current_, uint256 price_)](#get)
- [_get(address target_, uint256 current_, uint256 price_)](#_get)
- [set(address target_, uint256 id_)](#set)
- [read(address target_, uint256 id_)](#read)
- [totalReceivers()](#totalreceivers)
- [listReceivers()](#listreceivers)

### initialize

constructor

```solidity
function initialize(address rights_) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rights_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function initialize(address rights_) public initializer {

        __GuardExtensionUpgradeable_init(rights_);

    }
```
</details>

### addBatch

```solidity
function addBatch(address[] targets_, uint256[] prices_, uint16[] ids_, uint16[] amounts_, uint8[] levels_, uint256[] froms_, uint256[] untils_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| targets_ | address[] |  | 
| prices_ | uint256[] |  | 
| ids_ | uint16[] |  | 
| amounts_ | uint16[] |  | 
| levels_ | uint8[] |  | 
| froms_ | uint256[] |  | 
| untils_ | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addBatch(

        address[] calldata targets_,

        uint256[] calldata prices_,

        uint16[] calldata ids_,

        uint16[] calldata amounts_,

        uint8[] calldata levels_,

        uint256[] calldata froms_,

        uint256[] calldata untils_

    ) external haveRights {

        for (uint256 i = 0; i < targets_.length; i++) {

            _add(

                targets_[i],

                prices_[i],

                ids_[i],

                amounts_[i],

                levels_[i],

                froms_[i],

                untils_[i]

            );

        }

    }
```
</details>

### add

Add a benefit

```solidity
function add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_) external nonpayable haveRights 
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

    ) external override haveRights {

        _add(target_, price_, id_, amount_, level_, from_, until_);

    }
```
</details>

### _add

```solidity
function _add(address target_, uint256 price_, uint16 id_, uint16 amount_, uint8 level_, uint256 from_, uint256 until_) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address |  | 
| price_ | uint256 |  | 
| id_ | uint16 |  | 
| amount_ | uint16 |  | 
| level_ | uint8 |  | 
| from_ | uint256 |  | 
| until_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _add(

        address target_,

        uint256 price_,

        uint16 id_,

        uint16 amount_,

        uint8 level_,

        uint256 from_,

        uint256 until_

    ) private {

        require(!_used.get(id_), ALREADY_SET);

        if (_receiverIds[target_] == 0) {

            _ids.increment();

            _receiverIds[target_] = _ids.current();

            _receivers[_ids.current()] = target_;

        }

        _benefits[target_].push(

            Structures.Benefit(price_, from_, until_, id_, amount_, level_, 0)

        );

        if (id_ > 0) {

            _used.set(id_);

        }

        emit BenefitAdded(target_, from_, until_, price_, id_, amount_, level_);

    }
```
</details>

### clear

Clear user's benefits for the contract

```solidity
function clear(address target_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function clear(address target_) external override haveRights {

        if (_receiverIds[target_] > 0) {

            _deletedIds.increment();

            delete _receivers[_receiverIds[target_]];

            delete _receiverIds[target_];

        }

        if (_benefits[target_].length > 0) {

            for (uint256 i = 0; i < _benefits[target_].length; i++) {

                if (_benefits[target_][i].id > 0) {

                    _used.unset(_benefits[target_][i].id);

                }

            }

        }

        delete _benefits[target_];

        emit BenefitsCleared(target_);

    }
```
</details>

### denied

Check if denied to buy an nft with specific id for specific target address

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
function denied(uint256 current_) external view returns (bool) {

        if (_used.get(current_)) return true; // this item is not denied

        return false; // any other case - allowed

    }
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

        override

        returns (

            address,

            uint256,

            uint256,

            uint16,

            uint8,

            bool

        )

    {

        (

            address target,

            uint256 id,

            uint256 price,

            uint16 tokenId,

            uint8 level,

            bool isFound

        ) = _get(target_, current_, price_);

        if (target == address(0)) {

            return _get(target, current_, price_);

        }

        return (target, id, price, tokenId, level, isFound);

    }
```
</details>

### _get

```solidity
function _get(address target_, uint256 current_, uint256 price_) internal view
returns(address, uint256, uint256, uint16, uint8, bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address |  | 
| current_ | uint256 |  | 
| price_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _get(

        address target_,

        uint256 current_,

        uint256 price_

    )

        internal

        view

        returns (

            address,

            uint256,

            uint256,

            uint16,

            uint8,

            bool // bennefit found

        )

    {

        if (_benefits[target_].length == 0)

            return (address(0), 0, 0, 0, 0, false);

        uint256 i = 0;

        for (; i < _benefits[target_].length; i++) {

            if (

                _benefits[target_][i].from <= block.timestamp &&

                (_benefits[target_][i].until == 0 ||

                    _benefits[target_][i].until >= block.timestamp) &&

                (_benefits[target_][i].amount >

                    _benefits[target_][i].issued +

                        _additionalIssued[target_][i]) &&

                (_benefits[target_][i].id == 0 ||

                    _benefits[target_][i].id >= current_) &&

                price_ == _benefits[target_][i].price

            ) {

                return (

                    target_,

                    i,

                    _benefits[target_][i].price,

                    _benefits[target_][i].id,

                    _benefits[target_][i].level,

                    true

                );

            }

        }

        return (address(0), 0, 0, 0, 0, false);

    }
```
</details>

### set

Set user benefit

```solidity
function set(address target_, uint256 id_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | target address | 
| id_ | uint256 | benefit id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(address target_, uint256 id_) external override haveRights {

        require(_benefits[target_].length > id_, WRONG_TARGET);

        require(

            _benefits[target_][id_].amount >

                (_benefits[target_][id_].issued +

                    _additionalIssued[target_][id_]),

            OVERUSAGE

        );

        if (_benefits[target_][id_].issued < 254) {

            _benefits[target_][id_].issued = _benefits[target_][id_].issued + 1;

        } else {

            _additionalIssued[target_][id_] =

                _additionalIssued[target_][id_] +

                1;

        }

        emit BenefitUsed(target_, id_);

    }
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

        override

        returns (Structures.Benefit memory)

    {

        require(_benefits[target_].length > id_, WRONG_TARGET);

        return _benefits[target_][id_];

    }
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
function totalReceivers() external view override returns (uint256) {

        return _ids.current() - _deletedIds.current() - 1;

    }
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
function listReceivers() external view override returns (address[] memory) {

        address[] memory out = new address[](

            _ids.current() - _deletedIds.current() - 1

        );

        uint256 counter = 0;

        uint256 total = _ids.current();

        for (uint256 i = 1; i <= total; i++) {

            if (_receivers[i] != address(0)) {

                out[counter] = _receivers[i];

                counter = counter + 1;

            }

        }

        return out;

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
