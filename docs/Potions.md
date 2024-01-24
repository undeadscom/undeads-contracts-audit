# Potions.sol

View Source: [\contracts\persons\Potions.sol](..\contracts\persons\Potions.sol)

**↗ Extends: [OperatorFiltererERC721](OperatorFiltererERC721.md), [IPotions](IPotions.md), [EIP2981](EIP2981.md), [GuardExtension](GuardExtension.md)**

**Potions**

## Contract Members
**Constants & Variables**

```js
struct Counters.Counter private _tokenIds;
uint256 private _childs;
uint256 private _unissued;
uint256[] private _amounts;
mapping(uint256 => uint256) private _total;
mapping(uint256 => uint256) private _women;
contract IActors private _zombie;
contract IRandomizer private _random;
address private _mysteryBoxAddress;
bytes32 private constant ZERO_STRING;
string private constant WRONG_LEVEL;
string private constant WRONG_OWNER;
string private constant NOT_A_BOX;
string private constant TRY_AGAIN;
string private constant SOLD_OUT;
string private constant WRONG_ID;
string private constant NO_ZERO_LEVEL;
string private constant META_ALREADY_USED;
string private constant ALREADY_SET;
string private constant BOX_NOT_SET;
string private constant SAME_VALUE;
string private constant ZERO_ADDRESS;
string private constant IPFS_PREFIX;
string private constant PLACEHOLDERS_META_HASH;
mapping(bytes32 => bool) private _usedMetadata;
mapping(uint256 => string) private _tokensHashes;
mapping(uint256 => uint256) private _issuedLevels;
uint256[] private _limits;
mapping(address => uint256) private _last;

```

## Modifiers

- [onlyBox](#onlybox)
- [correctId](#correctid)

### onlyBox

only if one of the admins calls

```js
modifier onlyBox() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

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

- [constructor(string name_, string symbol_, address rights_, address zombie_, address random_, uint256[] limits_, uint256[] amounts_, uint256[] women_, uint256 childs_)](#)
- [total()](#total)
- [_saveAmounts(uint256[] amounts_)](#_saveamounts)
- [_saveWomen(uint256[] women_)](#_savewomen)
- [_saveLimits(uint256[] limits_)](#_savelimits)
- [unissued()](#unissued)
- [level(uint256 id_)](#level)
- [_create(address owner_, uint256 level_, uint256 id_)](#_create)
- [setChilds(uint256 childs_)](#setchilds)
- [setZombie(address value_)](#setzombie)
- [setRandom(address value_)](#setrandom)
- [setMysteryBox(address value_)](#setmysterybox)
- [getChilds()](#getchilds)
- [_getLimits(uint256 level_)](#_getlimits)
- [getLimits(uint256 level_)](#getlimits)
- [calcSex(IRandomizer random_, uint256 total_, uint256 womenAvailable_)](#calcsex)
- [calcProps(IRandomizer random, uint256 minRange, uint256 maxRange)](#calcprops)
- [callMint(uint256 id_, uint16[10] props_, bool sex_, uint256 power_, uint8 childs_)](#callmint)
- [open(uint256 id_)](#open)
- [getMaxLevel()](#getmaxlevel)
- [create(address target, bool rare, uint256 id_)](#create)
- [createPotion(address target, uint256 level_, uint256 id_)](#createpotion)
- [getLast(address target)](#getlast)
- [decreaseAmount(bool rare)](#decreaseamount)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)
- [tokenURI(uint256 id_)](#tokenuri)
- [setMetadataHash(uint256 id_, string metadataHash_)](#setmetadatahash)

### 

Constructor

```solidity
function (string name_, string symbol_, address rights_, address zombie_, address random_, uint256[] limits_, uint256[] amounts_, uint256[] women_, uint256 childs_) public nonpayable ERC721 GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name_ | string | The name | 
| symbol_ | string | The symbol | 
| rights_ | address | The address of the rights contract | 
| zombie_ | address | The address of the zombie contract | 
| random_ | address | The address of the random contract | 
| limits_ | uint256[] | The maximum possible limits for the each parameter | 
| amounts_ | uint256[] | The amounts of the actors according level (zero-based) | 
| women_ | uint256[] |  | 
| childs_ | uint256 | The maximum number of the childs (for woman actors only) | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        string memory name_,

        string memory symbol_,

        address rights_,

        address zombie_,

        address random_,

        uint256[] memory limits_,

        uint256[] memory amounts_,

        uint256[] memory women_,

        uint256 childs_

    ) ERC721(name_, symbol_) GuardExtension(rights_) {

        require(random_ != address(0), ZERO_ADDRESS);

        require(zombie_ != address(0), ZERO_ADDRESS);

        _childs = childs_;

        _random = IRandomizer(random_);

        _zombie = IActors(zombie_);

        _saveAmounts(amounts_);

        _saveLimits(limits_);

        _saveWomen(women_);

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

        return _tokenIds.current();

    }
```
</details>

### _saveAmounts

```solidity
function _saveAmounts(uint256[] amounts_) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| amounts_ | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _saveAmounts(uint256[] memory amounts_) private {

        uint256 len = amounts_.length;

        _unissued = 0;

        _amounts = amounts_;

        for (uint256 i = 0; i < len; ++i) {

            _unissued = _unissued + amounts_[i];

        }

    }
```
</details>

### _saveWomen

```solidity
function _saveWomen(uint256[] women_) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| women_ | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _saveWomen(uint256[] memory women_) private {

        for (uint256 i = 0; i < women_.length; i++) {

            _women[i] = women_[i];

        }

    }
```
</details>

### _saveLimits

```solidity
function _saveLimits(uint256[] limits_) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| limits_ | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _saveLimits(uint256[] memory limits_) private {

        _limits = limits_;

    }
```
</details>

### unissued

Get the amount of the actors remains to be created

```solidity
function unissued() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function unissued() external view override returns (uint256) {

        return _unissued;

    }
```
</details>

### level

Get the level of the potion

```solidity
function level(uint256 id_) external view correctId 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | potion id | 

**Returns**

The level of the potion

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function level(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint256)

    {

        return _issuedLevels[id_];

    }
```
</details>

### _create

```solidity
function _create(address owner_, uint256 level_, uint256 id_) private nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address |  | 
| level_ | uint256 |  | 
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _create(

        address owner_,

        uint256 level_,

        uint256 id_

    ) private returns (uint256) {

        require(level_ > 0, NO_ZERO_LEVEL);

        _tokenIds.increment();

        _issuedLevels[id_] = level_;

        _mint(owner_, id_);

        emit Created(owner_, id_, level_);

        return id_;

    }
```
</details>

### setChilds

Set the maximum amount of the childs for the woman actor

```solidity
function setChilds(uint256 childs_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| childs_ | uint256 | New childs amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setChilds(uint256 childs_) external override haveRights {

        _childs = childs_;

        emit ChildsDefined(childs_);

    }
```
</details>

### setZombie

Set new address of Zombie contract

```solidity
function setZombie(address value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | address | New address value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setZombie(address value_) external haveRights {

        require(address(_zombie) != value_, SAME_VALUE);

        require(value_ != address(0), ZERO_ADDRESS);

        _zombie = IActors(value_);

    }
```
</details>

### setRandom

Set new address of Randomizer contract

```solidity
function setRandom(address value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | address | New address value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setRandom(address value_) external haveRights {

        require(address(_random) != value_, SAME_VALUE);

        require(value_ != address(0), ZERO_ADDRESS);

        _random = IRandomizer(value_);

    }
```
</details>

### setMysteryBox

Set new address of MysteryBox contract

```solidity
function setMysteryBox(address value_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| value_ | address | New address value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMysteryBox(address value_) external haveRights {

        require(address(_mysteryBoxAddress) != value_, SAME_VALUE);

        require(value_ != address(0), ZERO_ADDRESS);

        _mysteryBoxAddress = value_;

    }
```
</details>

### getChilds

Get the current  maximum amount of the childs

```solidity
function getChilds() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getChilds() external view override returns (uint256) {

        return _childs;

    }
```
</details>

### _getLimits

```solidity
function _getLimits(uint256 level_) private view
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| level_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _getLimits(uint256 level_)

        private

        view

        returns (uint256, uint256)

    {

        require(level_ > 0, NO_ZERO_LEVEL);

        require(level_ <= _limits.length, WRONG_LEVEL);

        if (level_ == 1) {

            return (Constants.MINIMAL, _limits[0]);

        }

        return (_limits[level_ - 2], _limits[level_ - 1]);

    }
```
</details>

### getLimits

Get the limits of the properties for the level

```solidity
function getLimits(uint256 level_) external view
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| level_ | uint256 | The desired level | 

**Returns**

Minimum and maximum level available

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getLimits(uint256 level_)

        external

        view

        returns (uint256, uint256)

    {

        return _getLimits(level_);

    }
```
</details>

### calcSex

```solidity
function calcSex(IRandomizer random_, uint256 total_, uint256 womenAvailable_) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| random_ | IRandomizer |  | 
| total_ | uint256 |  | 
| womenAvailable_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function calcSex(

        IRandomizer random_,

        uint256 total_,

        uint256 womenAvailable_

    ) internal returns (bool) {

        uint256[] memory weights = new uint256[](2);

        weights[0] = total_ - womenAvailable_;

        weights[1] = womenAvailable_;

        uint256 isWoman = random_.distributeRandom(total_, weights);

        return (isWoman == 0);

    }
```
</details>

### calcProps

```solidity
function calcProps(IRandomizer random, uint256 minRange, uint256 maxRange) internal nonpayable
returns(uint256, uint16[10])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| random | IRandomizer |  | 
| minRange | uint256 |  | 
| maxRange | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function calcProps(

        IRandomizer random,

        uint256 minRange,

        uint256 maxRange

    ) internal returns (uint256, uint16[10] memory) {

        uint16[10] memory props;

        uint256 range = maxRange - minRange;

        uint256 power = 0;

        for (uint256 i = 0; i < 10; i++) {

            props[i] = uint16(random.randomize(range) + minRange);

            power = power + props[i];

        }

        return (power, props);

    }
```
</details>

### callMint

```solidity
function callMint(uint256 id_, uint16[10] props_, bool sex_, uint256 power_, uint8 childs_) internal nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 
| props_ | uint16[10] |  | 
| sex_ | bool |  | 
| power_ | uint256 |  | 
| childs_ | uint8 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function callMint(

        uint256 id_,

        uint16[10] memory props_,

        bool sex_,

        uint256 power_,

        uint8 childs_

    ) internal returns (uint256) {

        _zombie.mint(id_, msg.sender, props_, sex_, true, 0, childs_, true);

        emit Opened(msg.sender, id_);

        return id_;

    }
```
</details>

### open

Open the packed id with the random values

```solidity
function open(uint256 id_) external nonpayable correctId 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | The pack id | 

**Returns**

The new actor id

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

        uint256 level_ = _issuedLevels[id_];

        IRandomizer random = _random;

        (uint256 minRange, uint256 maxRange) = _getLimits(level_);

        (uint256 power, uint16[10] memory props) = calcProps(

            random,

            minRange,

            maxRange

        );

        bool sex = true;

        if (_women[level_ - 1] > 0) {

            sex = calcSex(

                random,

                _total[level_ - 1] + _amounts[level_ - 1],

                _women[level_ - 1]

            );

            if (!sex) {

                _women[level_ - 1] = _women[level_ - 1] - 1;

            }

        }

        uint8 childs = sex ? 0 : uint8(random.randomize(_childs + 1));

        _burn(id_);

        delete _issuedLevels[id_];

        return callMint(id_, props, sex, power, childs);

    }
```
</details>

### getMaxLevel

return max potion level

```solidity
function getMaxLevel() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getMaxLevel() external view override returns (uint256) {

        return _amounts.length - 1;

    }
```
</details>

### create

Create the potion by box (rare or not)

```solidity
function create(address target, bool rare, uint256 id_) external nonpayable onlyBox 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The potion owner | 
| rare | bool | The rarity sign | 
| id_ | uint256 | The id of a new token | 

**Returns**

The new pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function create(

        address target,

        bool rare,

        uint256 id_

    ) external override onlyBox returns (uint256) {

        uint256 level_ = _amounts.length - 1;

        if (!rare) {

            level_ = _random.distributeRandom(_unissued, _amounts);

            require(_amounts[level_] > 0, TRY_AGAIN);

            _amounts[level_] = _amounts[level_] - 1;

        }

        require(_amounts[level_] > 0, SOLD_OUT);

        _total[level_] = _total[level_] + 1;

        return _create(target, level_ + 1, id_);

    }
```
</details>

### createPotion

Create the packed potion with desired level (admin only)

```solidity
function createPotion(address target, uint256 level_, uint256 id_) external nonpayable haveRights 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The pack owner | 
| level_ | uint256 | The pack level | 
| id_ | uint256 | The id of a new token | 

**Returns**

The new pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function createPotion(

        address target,

        uint256 level_,

        uint256 id_

    ) external override haveRights returns (uint256) {

        require(level_ > 0, NO_ZERO_LEVEL);

        require(_unissued > 0, SOLD_OUT);

        require(_amounts[level_ - 1] > 0, SOLD_OUT);

        _amounts[level_ - 1] = _amounts[level_ - 1] - 1;

        _unissued = _unissued - 1;

        uint256 created = _create(target, level_, id_);

        _last[target] = created;

        return created;

    }
```
</details>

### getLast

get the last pack for the address

```solidity
function getLast(address target) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | address | The  owner | 

**Returns**

The  pack id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getLast(address target) external view override returns (uint256) {

        return _last[target];

    }
```
</details>

### decreaseAmount

Decrease the amount of the common or rare tokens or fails

```solidity
function decreaseAmount(bool rare) external nonpayable onlyBox 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rare | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function decreaseAmount(bool rare)

        external

        override

        onlyBox

        returns (bool)

    {

        if (_unissued == 0) return false;

        if (rare) {

            uint256 aLevel = _amounts.length - 1;

            if (_amounts[aLevel] == 0) return false;

            _amounts[aLevel] = _amounts[aLevel] - 1;

        }

        _unissued = _unissued - 1;

        return true;

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

        override(IERC165, ERC2981, ERC721)

        returns (bool)

    {

        return super.supportsInterface(interfaceId);

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

        uint256 level_ = _issuedLevels[id_];

        if (keccak256(bytes(_tokensHashes[id_])) == ZERO_STRING) {

            return

                string(

                    abi.encodePacked(

                        IPFS_PREFIX,

                        PLACEHOLDERS_META_HASH,

                        "/po/",

                        level_.toString(),

                        "/meta.json"

                    )

                );

        } else {

            return string(abi.encodePacked(IPFS_PREFIX, _tokensHashes[id_]));

        }

    }
```
</details>

### setMetadataHash

Set an uri for the token

```solidity
function setMetadataHash(uint256 id_, string metadataHash_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| metadataHash_ | string | ipfs hash of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(uint256 id_, string calldata metadataHash_)

        external

        override

        haveRights

        correctId(id_)

    {

        require(

            keccak256(bytes(_tokensHashes[id_])) == ZERO_STRING,

            ALREADY_SET

        );

        require(

            !_usedMetadata[keccak256(bytes(metadataHash_))],

            META_ALREADY_USED

        );

        _usedMetadata[keccak256(bytes(metadataHash_))] = true;

        _tokensHashes[id_] = metadataHash_;

        emit TokenUriDefined(

            id_,

            string(abi.encodePacked(IPFS_PREFIX, metadataHash_))

        );

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
