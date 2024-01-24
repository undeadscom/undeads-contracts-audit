# IActors.sol

View Source: [\contracts\persons\interfaces\IActors.sol](..\contracts\persons\interfaces\IActors.sol)

**↗ Extends: [IERC721Metadata](IERC721Metadata.md)**
**↘ Derived Contracts: [Actors](Actors.md)**

**IActors**

**Events**

```js
event Minted(address indexed owner, uint256 indexed id);
event MintedImmaculate(address indexed owner, uint256 indexed id);
event TokenUriDefined(uint256 indexed id, string  kidUri, string  adultUri);
event ActorWasBorn(uint256 indexed id, uint256  bornTime);
```

## Functions

- [total()](#total)
- [setMetadataHash(uint256 id_, string adultHash_)](#setmetadatahash)
- [setMetadataHashes(uint256 id_, string kidHash_, string adultHash_)](#setmetadatahashes)
- [tokenKidURI(uint256 id_)](#tokenkiduri)
- [tokenAdultURI(uint256 id_)](#tokenadulturi)
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
- [getAdultTime(uint256 id_)](#getadulttime)
- [setAdultTime(uint256 id_, uint256 time_)](#setadulttime)
- [isAdult(uint256 id_)](#isadult)
- [getRank(uint256 id_)](#getrank)

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
function total() external view returns (uint256);
```
</details>

### setMetadataHash

Set an uri for the adult token (only for non immaculate)

```solidity
function setMetadataHash(uint256 id_, string adultHash_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| adultHash_ | string | ipfs hash of the kids metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(uint256 id_, string calldata adultHash_) external;
```
</details>

### setMetadataHashes

Set an uri for the adult and kid token (only for immaculate)

```solidity
function setMetadataHashes(uint256 id_, string kidHash_, string adultHash_) external nonpayable
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

    ) external;
```
</details>

### tokenKidURI

Get an uri for the kid token

```solidity
function tokenKidURI(uint256 id_) external view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

**Returns**

Token uri for the kid actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenKidURI(uint256 id_) external view returns (string memory);
```
</details>

### tokenAdultURI

Get an uri for the adult token

```solidity
function tokenAdultURI(uint256 id_) external view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

**Returns**

Token uri for the adult actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenAdultURI(uint256 id_) external view returns (string memory);
```
</details>

### mint

Create a new person token (not born yet)

```solidity
function mint(uint256 id_, address owner_, uint16[10] props_, bool sex_, bool born_, uint256 adultTime_, uint8 childs_, bool immaculate_) external nonpayable
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

    ) external returns (uint256);
```
</details>

### getProps

Get the person props

```solidity
function getProps(uint256 id_) external view
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
function getProps(uint256 id_) external view returns (uint16[10] memory);
```
</details>

### getActor

Get the actor

```solidity
function getActor(uint256 id_) external view
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

        returns (Structures.ActorData memory);
```
</details>

### getSex

Get the person sex

```solidity
function getSex(uint256 id_) external view
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
function getSex(uint256 id_) external view returns (bool);
```
</details>

### getChilds

Get the person childs

```solidity
function getChilds(uint256 id_) external view
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
function getChilds(uint256 id_) external view returns (uint8, uint8);
```
</details>

### breedChild

Breed a child

```solidity
function breedChild(uint256 id_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function breedChild(uint256 id_) external;
```
</details>

### getImmaculate

Get the person immaculate status

```solidity
function getImmaculate(uint256 id_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getImmaculate(uint256 id_) external view returns (bool);
```
</details>

### getBornTime

Get the person born time

```solidity
function getBornTime(uint256 id_) external view
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
function getBornTime(uint256 id_) external view returns (uint256);
```
</details>

### isBorn

Get the person born state

```solidity
function isBorn(uint256 id_) external view
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
function isBorn(uint256 id_) external view returns (bool);
```
</details>

### born

Birth the person

```solidity
function born(uint256 id_, uint256 adultTime_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 
| adultTime_ | uint256 | When person becomes adult | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function born(uint256 id_, uint256 adultTime_) external;
```
</details>

### getAdultTime

Get the person adult timestamp

```solidity
function getAdultTime(uint256 id_) external view
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
function getAdultTime(uint256 id_) external view returns (uint256);
```
</details>

### setAdultTime

Grow the

```solidity
function setAdultTime(uint256 id_, uint256 time_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Person token id | 
| time_ | uint256 | the deadline to grow | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setAdultTime(uint256 id_, uint256 time_) external;
```
</details>

### isAdult

Get the person adult state

```solidity
function isAdult(uint256 id_) external view
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
function isAdult(uint256 id_) external view returns (bool);
```
</details>

### getRank

Get the person rank

```solidity
function getRank(uint256 id_) external view
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
function getRank(uint256 id_) external view returns (uint16);
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
