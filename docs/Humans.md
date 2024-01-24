# Humans.sol

View Source: [\contracts\persons\Humans.sol](..\contracts\persons\Humans.sol)

**↗ Extends: [OperatorFiltererERC721](OperatorFiltererERC721.md), [IHumans](IHumans.md), [EIP2981](EIP2981.md), [GuardExtension](GuardExtension.md)**

**Humans**

## Contract Members
**Constants & Variables**

```js
struct Counters.Counter private _tokenCounter;
mapping(uint256 => string) private _metadataHashes;
mapping(uint256 => uint16[10]) private _props;
string private _baseTokenURI;
string private constant IPFS_PREFIX;

```

## Functions

- [constructor(string baseURI_, address rights_)](#)
- [mint(address owner_, uint16[10] props_)](#mint)
- [getProps(uint256 id_)](#getprops)
- [getRank(uint256 id_)](#getrank)
- [totalSupply()](#totalsupply)
- [setMetadataHash(uint256 id_, string ipfsHash_)](#setmetadatahash)
- [tokenURI(uint256 id_)](#tokenuri)
- [setBaseUri(string uri_)](#setbaseuri)
- [supportsInterface(bytes4 interfaceId)](#supportsinterface)

### 

Constructor

```solidity
function (string baseURI_, address rights_) public nonpayable ERC721 GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| baseURI_ | string | The base token URI | 
| rights_ | address | The address of the rights contract | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        string memory baseURI_,

        address rights_

    ) ERC721("UndeadsHumans", "UDHT") GuardExtension(rights_) {

        _baseTokenURI = baseURI_;

    }
```
</details>

### mint

Mint a new human

```solidity
function mint(address owner_, uint16[10] props_) external nonpayable haveRights 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address | Owner of new human | 
| props_ | uint16[10] | Array of the actor properties | 

**Returns**

The id of created human

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mint(

        address owner_,

        uint16[10] memory props_

    ) external override haveRights returns(uint256) {

        _tokenCounter.increment();

        uint256 id = _tokenCounter.current();

        _props[id] = props_;

        _mint(owner_, id);

        emit Created(owner_, id);

        return id;

    }
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
function getProps(

        uint256 id_

    ) external view override returns (uint16[10] memory)

    {

        return _props[id_];

    }
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
function getRank(

        uint256 id_

    ) external view override returns (uint16)

    {

        _requireMinted(id_);

        uint16[10] memory props = _props[id_];

        uint16 rank;

        for (uint256 i; i < 10;) {

            rank += props[i];

            unchecked {

                ++i;

            }

        }

        rank = rank / 10;

        return rank;

    }
```
</details>

### totalSupply

Get a total amount of issued tokens

```solidity
function totalSupply() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function totalSupply() external view override returns(uint256) {

        return _tokenCounter.current();

    }
```
</details>

### setMetadataHash

Set an uri for the human

```solidity
function setMetadataHash(uint256 id_, string ipfsHash_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 
| ipfsHash_ | string | ipfs hash of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMetadataHash(

        uint256 id_,

        string calldata ipfsHash_

    ) external override haveRights

    {

        _requireMinted(id_);

        _metadataHashes[id_] = ipfsHash_;

        emit TokenUriDefined(id_, string(abi.encodePacked(IPFS_PREFIX, ipfsHash_)));

    }
```
</details>

### tokenURI

Returns the URI for `tokenId` token.

```solidity
function tokenURI(uint256 id_) public view
returns(string)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | token id | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tokenURI(

        uint256 id_

    ) public view override(ERC721, IHumans) returns(string memory)

    {

        _requireMinted(id_);

        string memory metadataHash = _metadataHashes[id_];

        if (bytes(metadataHash).length != 0) {

            return string(abi.encodePacked(IPFS_PREFIX, metadataHash));

        }

        return string(abi.encodePacked(_baseTokenURI, "/", Strings.toString(id_), ".json"));

    }
```
</details>

### setBaseUri

Set an base uri for the token

```solidity
function setBaseUri(string uri_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| uri_ | string | base URI of the metadata | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setBaseUri(string calldata uri_) external override haveRights {

        _baseTokenURI = uri_;

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
function supportsInterface(

        bytes4 interfaceId

    ) public view virtual override(ERC2981, ERC721, IERC165) returns (bool) {

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
