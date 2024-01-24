# The Actor NFT contract (Actors.sol)

View Source: [\contracts\persons\Actors.sol](..\contracts\persons\Actors.sol)

**↗ Extends: [OperatorFiltererERC721](OperatorFiltererERC721.md), [EIP2981](EIP2981.md), [GuardExtension](GuardExtension.md), [IActors](IActors.md)**
**↘ Derived Contracts: [Zombies](Zombies.md)**

**Actors**

This contract manage properties of the game actor, including birth and childhood.
The new actor comes from the Breed or Box contracts

## Contract Members
**Constants & Variables**

```js
struct Counters.Counter private _total;
uint256 private _counter;
bytes32 private constant ZERO_STRING;
string private constant WRONG_ID;
string private constant ALREADY_SET;
string private constant NOT_BORN;
string private constant META_ALREADY_USED;
string private constant ONLY_NON_IMMACULATE;
string private constant ONLY_IMMACULATE;
string private constant IPFS_PREFIX;
string private constant TOO_MUCH_CHILDS;
string private constant FALLBACK_META_HASH;
mapping(uint256 => struct Structures.ActorData) private _actors;
mapping(bytes32 => bool) private _usedMetadata;

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

- [constructor(string name_, string symbol_, address rights_, uint256 start_)](#)
- [total()](#total)
- [setMetadataHash(uint256 id_, string adultHash_)](#setmetadatahash)
- [setMetadataHashes(uint256 id_, string kidHash_, string adultHash_)](#setmetadatahashes)
- [tokenURI(uint256 id_)](#tokenuri)
- [tokenKidURI(uint256 id_)](#tokenkiduri)
- [tokenAdultURI(uint256 id_)](#tokenadulturi)
- [_getPlaceholderSubFolder()](#_getplaceholdersubfolder)
- [mint(uint256 id_, address owner_, uint16[10] props_, bool sex_, bool born_, uint256 adultTime_, uint8 childs_, bool immaculate_)](#mint)
- [getProps(uint256 id_)](#getprops)
- [getActor(uint256 id_)](#getactor)
- [getSex(uint256 id_)](#getsex)
- [getChilds(uint256 id_)](#getchilds)
- [breedChild(uint256 id_)](#breedchild)
- [getImmaculate(uint256 id_)](#getimmaculate)
- [getBornTime(uint256 id_)](#getborntime)
- [isBorn(uint256 id_)](#isborn)
- [born(uint256 id_, uint256 adultTime_)](#born)
- [setAdultTime(uint256 id_, uint256 time_)](#setadulttime)
- [_isAdult(uint256 id_)](#_isadult)
- [getAdultTime(uint256 id_)](#getadulttime)
- [isAdult(uint256 id_)](#isadult)
- [getRank(uint256 id_)](#getrank)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### 

constructor

```solidity
function (string name_, string symbol_, address rights_, uint256 start_) internal nonpayable ERC721 GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| name_ | string | The name of the token | 
| symbol_ | string | The short name (symbol) of the token | 
| rights_ | address | The address of the rights contract | 
| start_ | uint256 | The first started id for counting | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        string memory name_,

        string memory symbol_,

        address rights_,

        uint256 start_

    ) ERC721(name_, symbol_) GuardExtension(rights_) {

        _counter = start_;

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

        return _total.current();

    }
```
</details>

### setMetadataHash

Set an uri for the adult token (only for non immaculate)

```solidity
function setMetadataHash(uint256 id_, string adultHash_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| adultHash_ | string | ipfs hash of the kids metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(uint256 id_, string calldata adultHash_)

        external

        override

        haveRights

        correctId(id_)

    {

        require(_actors[id_].immaculate, ONLY_IMMACULATE);

        require(

            keccak256(bytes(_actors[id_].adultTokenUriHash)) == ZERO_STRING,

            ALREADY_SET

        );

        require(

            !_usedMetadata[keccak256(bytes(adultHash_))],

            META_ALREADY_USED

        );

        _usedMetadata[keccak256(bytes(adultHash_))] = true;

        _actors[id_].adultTokenUriHash = adultHash_;

        emit TokenUriDefined(

            id_,

            "",

            string(abi.encodePacked(IPFS_PREFIX, adultHash_))

        );

    }
```
</details>

### setMetadataHashes

Set an uri for the adult and kid token (only for immaculate)

```solidity
function setMetadataHashes(uint256 id_, string kidHash_, string adultHash_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| kidHash_ | string | ipfs hash of the kids metadata | 
| adultHash_ | string | ipfs hash of the adult metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHashes(

        uint256 id_,

        string calldata kidHash_,

        string calldata adultHash_

    ) external override haveRights correctId(id_) {

        require(!_actors[id_].immaculate, ONLY_NON_IMMACULATE);

        require(

            keccak256(bytes(_actors[id_].adultTokenUriHash)) == ZERO_STRING,

            ALREADY_SET

        );

        require(!_usedMetadata[keccak256(bytes(kidHash_))], META_ALREADY_USED);

        require(

            !_usedMetadata[keccak256(bytes(adultHash_))],

            META_ALREADY_USED

        );

        _usedMetadata[keccak256(bytes(kidHash_))] = true;

        _usedMetadata[keccak256(bytes(adultHash_))] = true;

        _actors[id_].kidTokenUriHash = kidHash_;

        _actors[id_].adultTokenUriHash = adultHash_;

        emit TokenUriDefined(

            id_,

            string(abi.encodePacked(IPFS_PREFIX, kidHash_)),

            string(abi.encodePacked(IPFS_PREFIX, adultHash_))

        );

    }
```
</details>

### tokenURI

Get an uri for the token

```solidity
function tokenURI(uint256 id_) public view correctId 
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

**Returns**

The current payment token address

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

        string memory tokenHash;

        if (_isAdult(id_)) {

            tokenHash = _actors[id_].adultTokenUriHash;

        } else {

            tokenHash = _actors[id_].kidTokenUriHash;

        }

        if (keccak256(bytes(tokenHash)) == ZERO_STRING) {

            Structures.ActorData memory actor = _actors[id_];

            string memory personType;

            if (_isAdult(id_)) {

                // am - adult male, af - adult female

                personType = actor.sex ? "am" : "af";

            } else {

                personType = "kid";

            }

            return

                string(

                    abi.encodePacked(

                        IPFS_PREFIX,

                        FALLBACK_META_HASH,

                        "/",

                        _getPlaceholderSubFolder(),

                        "/",

                        personType,

                        "/",

                        "meta.json"

                    )

                );

        }

        return string(abi.encodePacked(IPFS_PREFIX, tokenHash));

    }
```
</details>

### tokenKidURI

Get an uri for the kid token

```solidity
function tokenKidURI(uint256 id_) external view correctId 
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

**Returns**

The current payment token address

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenKidURI(uint256 id_)

        external

        view

        correctId(id_)

        returns (string memory)

    {

        string memory tokenHash = _actors[id_].kidTokenUriHash;

        if (keccak256(bytes(tokenHash)) == ZERO_STRING) {

            return "";

        }

        return string(abi.encodePacked(IPFS_PREFIX, tokenHash));

    }
```
</details>

### tokenAdultURI

Get an uri for the adult token

```solidity
function tokenAdultURI(uint256 id_) external view correctId 
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

**Returns**

The current payment token address

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenAdultURI(uint256 id_)

        external

        view

        correctId(id_)

        returns (string memory)

    {

        Structures.ActorData memory actor = _actors[id_];

        string memory tokenHash = actor.adultTokenUriHash;

        if (keccak256(bytes(tokenHash)) == ZERO_STRING) {

            return "";

        }

        return string(abi.encodePacked(IPFS_PREFIX, tokenHash));

    }
```
</details>

### _getPlaceholderSubFolder

Method that returns sub folder for placeholders metadata

```solidity
function _getPlaceholderSubFolder() internal pure
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _getPlaceholderSubFolder()

        internal

        pure

        virtual

        returns (string memory);
```
</details>

### mint

Create a new person token (not born yet)

```solidity
function mint(uint256 id_, address owner_, uint16[10] props_, bool sex_, bool born_, uint256 adultTime_, uint8 childs_, bool immaculate_) external nonpayable haveRights 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | The id of new minted token | 
| owner_ | address | Owner of the token | 
| props_ | uint16[10] | Array of the actor properties | 
| sex_ | bool | The person sex (true = male, false = female) | 
| born_ | bool | Is the child born or not | 
| adultTime_ | uint256 | When child become adult actor, if 0 actor is not born yet | 
| childs_ | uint8 | The amount of childs can be born (only for female) | 
| immaculate_ | bool | True only for potion-breeded | 

**Returns**

The new id

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mint(

        uint256 id_,

        address owner_,

        uint16[10] memory props_,

        bool sex_,

        bool born_,

        uint256 adultTime_,

        uint8 childs_,

        bool immaculate_

    ) external override haveRights returns (uint256) {

        _total.increment();

        uint256 newId;

        if (id_ > 0) {

            newId = id_;

        } else {

            _counter = _counter + 1;

            newId = _counter;

        }

        _mint(owner_, newId);

        uint16 rank = (props_[0] +

            props_[1] +

            props_[2] +

            props_[3] +

            props_[4] +

            props_[5] +

            props_[6] +

            props_[7] +

            props_[8] +

            props_[9]) / 10;

        uint256 bornTime = 0;

        uint256 adultTime = 0;

        if (born_) {

            bornTime = block.timestamp;

            if (adultTime_ > block.timestamp) {

                adultTime = adultTime_;

            } else {

                adultTime = block.timestamp;

            }

        }

        _actors[newId] = Structures.ActorData({

            bornTime: bornTime,

            adultTime: adultTime,

            kidTokenUriHash: "",

            adultTokenUriHash: "",

            props: props_,

            sex: sex_,

            childs: childs_,

            childsPossible: childs_,

            born: born_,

            immaculate: immaculate_,

            rank: rank,

            initialOwner: owner_

        });

        if (immaculate_) {

            emit MintedImmaculate(owner_, newId);

        } else {

            emit Minted(owner_, newId);

        }

        return newId;

    }
```
</details>

### getProps

Get the person props

```solidity
function getProps(uint256 id_) external view correctId 
returns(uint16[10])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

Array of the props

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getProps(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint16[10] memory)

    {

        return _actors[id_].props;

    }
```
</details>

### getActor

Get the actor

```solidity
function getActor(uint256 id_) external view correctId 
returns(struct Structures.ActorData)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

Structures.ActorData full struct of actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getActor(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (Structures.ActorData memory)

    {

        return _actors[id_];

    }
```
</details>

### getSex

Get the person sex

```solidity
function getSex(uint256 id_) external view correctId 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

true = male, false = female

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getSex(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (bool)

    {

        return _actors[id_].sex;

    }
```
</details>

### getChilds

Get the person childs

```solidity
function getChilds(uint256 id_) external view correctId 
returns(uint8, uint8)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

childs and possible available childs

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getChilds(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint8, uint8)

    {

        return (_actors[id_].childs, _actors[id_].childsPossible);

    }
```
</details>

### breedChild

Breed a child

```solidity
function breedChild(uint256 id_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function breedChild(uint256 id_)

        external

        override

        haveRights

        correctId(id_)

    {

        if (!_actors[id_].sex) {

            require(_actors[id_].childsPossible > 0, TOO_MUCH_CHILDS);

            _actors[id_].childsPossible = _actors[id_].childsPossible - 1;

        }

    }
```
</details>

### getImmaculate

Get the person immaculate status

```solidity
function getImmaculate(uint256 id_) external view correctId 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getImmaculate(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (bool)

    {

        return (_actors[id_].immaculate);

    }
```
</details>

### getBornTime

Get the person adult state

```solidity
function getBornTime(uint256 id_) external view correctId 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

0 = complete adult, or amount of tokens needed to be paid for

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getBornTime(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint256)

    {

        require(_actors[id_].born, NOT_BORN);

        return _actors[id_].bornTime;

    }
```
</details>

### isBorn

Get the person born state

```solidity
function isBorn(uint256 id_) external view correctId 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

true = person is born

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isBorn(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (bool)

    {

        return _actors[id_].born;

    }
```
</details>

### born

Birth the person

```solidity
function born(uint256 id_, uint256 adultTime_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 
| adultTime_ | uint256 | When person becomes adult | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function born(uint256 id_, uint256 adultTime_)

        external

        override

        haveRights

        correctId(id_)

    {

        require(!_actors[id_].born, ALREADY_SET);

        _actors[id_].born = true;

        _actors[id_].bornTime = block.timestamp;

        emit ActorWasBorn(id_, block.timestamp);

        if (adultTime_ < block.timestamp) {

            _actors[id_].adultTime = block.timestamp;

        } else {

            _actors[id_].adultTime = adultTime_;

        }

    }
```
</details>

### setAdultTime

Grow the

```solidity
function setAdultTime(uint256 id_, uint256 time_) external nonpayable haveRights correctId 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 
| time_ | uint256 | the deadline to grow | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setAdultTime(uint256 id_, uint256 time_)

        external

        override

        haveRights

        correctId(id_)

    {

        require(_actors[id_].born, NOT_BORN);

        _actors[id_].adultTime = time_;

    }
```
</details>

### _isAdult

```solidity
function _isAdult(uint256 id_) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _isAdult(uint256 id_) internal view returns (bool) {

        return _actors[id_].born && _actors[id_].adultTime <= block.timestamp;

    }
```
</details>

### getAdultTime

Get the person adult time

```solidity
function getAdultTime(uint256 id_) external view correctId 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

timestamp

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getAdultTime(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint256)

    {

        return _actors[id_].adultTime;

    }
```
</details>

### isAdult

Get the person adult state

```solidity
function isAdult(uint256 id_) external view correctId 
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

true = person is adult (price is 0 and current date > person's grow deadline)

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isAdult(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (bool)

    {

        return _isAdult(id_);

    }
```
</details>

### getRank

Get the person rank

```solidity
function getRank(uint256 id_) external view correctId 
returns(uint16)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

**Returns**

person rank value

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getRank(uint256 id_)

        external

        view

        override

        correctId(id_)

        returns (uint16)

    {

        return _actors[id_].rank;

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
