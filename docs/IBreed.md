# IBreed.sol

View Source: [\contracts\persons\interfaces\IBreed.sol](..\contracts\persons\interfaces\IBreed.sol)

**↘ Derived Contracts: [Breed](Breed.md)**

**IBreed**

**Events**

```js
event DeviationUpdated(uint256  downPromille, uint256  upPromille);
event SignatureCanceled(address indexed signer, bytes  signature);
event LimitUpdated(uint16  limitPromille);
event FeesUpdated(address indexed asset, uint256  serviceFee, uint256  growPrice);
event FeeAddressUpdated(address indexed feeAddress);
event ServerAddressUpdated(address indexed serverAddress);
event GrowPeriodUpdated(uint256  interval);
event Grow(uint256 indexed kidId, address indexed user, uint256  amount, uint256  adultTime);
event Adult(uint256 indexed kidId, address indexed user, uint256  amount);
event BreedingCompleted(uint256 indexed kidId, uint256 indexed breedingId, uint256 indexed sessionId, uint256  motherId, uint256  fatherId, uint256  breedingFee, uint256  serviceFee);
```

## Functions

- [setFeeAddress(address feeAddress_)](#setfeeaddress)
- [setFees(uint256 serviceFee_, uint256 growPrice_, address asset_)](#setfees)
- [setGrowPeriod(uint256 growPeriod_)](#setgrowperiod)
- [setPropertyLimit(uint16 limitPromille_)](#setpropertylimit)
- [setDeviation(uint16 deviationDownPromille_, uint16 deviationUpPromille_)](#setdeviation)
- [getFeeAddress()](#getfeeaddress)
- [getAsset()](#getasset)
- [getServiceFee()](#getservicefee)
- [getGrowPeriod()](#getgrowperiod)
- [getPropertyLimit()](#getpropertylimit)
- [getDeviation()](#getdeviation)
- [getCounter()](#getcounter)
- [cancelSignature(bytes32 hash_, bytes signature_)](#cancelsignature)
- [breed(struct Structures.BreedingParams params_, bytes partnerSignature_)](#breed)
- [breed(struct Structures.BreedingParams params_, uint256 serviceFee_, bytes adminSignature_)](#breed)
- [growUp(uint256 id_, uint256 amount_, uint256 days_, uint256 nonce_, bytes adminSignature_)](#growup)
- [growUp(uint256 id_, uint256 amount_)](#growup)
- [calcGrowDays(uint256 amount_)](#calcgrowdays)
- [calcGrowPrice(uint256 growDays_)](#calcgrowprice)

### setFeeAddress

Set the fee receiving address

```solidity
function setFeeAddress(address feeAddress_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| feeAddress_ | address | Fee receiving address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setFeeAddress(address feeAddress_) external;
```
</details>

### setFees

Set the breeding and growing fees

```solidity
function setFees(uint256 serviceFee_, uint256 growPrice_, address asset_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| serviceFee_ | uint256 | Service fee value | 
| growPrice_ | uint256 | Growing up price per day | 
| asset_ | address | ERC20 contract address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setFees(uint256 serviceFee_, uint256 growPrice_, address asset_) external;
```
</details>

### setGrowPeriod

Set the growing up period in seconds

```solidity
function setGrowPeriod(uint256 growPeriod_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| growPeriod_ | uint256 | Growing up period value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setGrowPeriod(uint256 growPeriod_) external;
```
</details>

### setPropertyLimit

Set the maximum allowed limit of the actor property in ppm

```solidity
function setPropertyLimit(uint16 limitPromille_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| limitPromille_ | uint16 | Limit value in ppm | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setPropertyLimit(uint16 limitPromille_) external;
```
</details>

### setDeviation

Set the maximum deviation of the actor property in ppm

```solidity
function setDeviation(uint16 deviationDownPromille_, uint16 deviationUpPromille_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| deviationDownPromille_ | uint16 | The deviation to down of the actor property, in ppm | 
| deviationUpPromille_ | uint16 | The deviation to up of the actor property in ppm | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setDeviation(

        uint16 deviationDownPromille_,

        uint16 deviationUpPromille_

    ) external;
```
</details>

### getFeeAddress

Get the fee address

```solidity
function getFeeAddress() external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getFeeAddress() external view returns(address);
```
</details>

### getAsset

Get the breeding ERC20 asset address

```solidity
function getAsset() external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getAsset() external view returns(address);
```
</details>

### getServiceFee

Get the service fee value

```solidity
function getServiceFee() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getServiceFee() external view returns(uint256);
```
</details>

### getGrowPeriod

Get the growing up period in seconds

```solidity
function getGrowPeriod() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getGrowPeriod() external view returns(uint256);
```
</details>

### getPropertyLimit

Get the current limit of the actor properties

```solidity
function getPropertyLimit() external view
returns(uint16)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getPropertyLimit() external view returns (uint16);
```
</details>

### getDeviation

Get the current maximal deviation of the actor property, in promille

```solidity
function getDeviation() external view
returns(uint16, uint16)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getDeviation() external view returns (uint16, uint16);
```
</details>

### getCounter

Get the current zombie kid id

```solidity
function getCounter() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getCounter() external view returns (uint256);
```
</details>

### cancelSignature

Cancel signature.

```solidity
function cancelSignature(bytes32 hash_, bytes signature_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash_ | bytes32 | The packed data keccak256 hash | 
| signature_ | bytes | The data signature | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function cancelSignature(bytes32 hash_, bytes calldata signature_) external;
```
</details>

### breed

Breed a new actor from the father and mother.

```solidity
function breed(struct Structures.BreedingParams params_, bytes partnerSignature_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams | The breeding params | 
| partnerSignature_ | bytes | The partner params signature. Not required if sender is mother and father. | 

**Returns**

The id of breeded actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function breed(        

        Structures.BreedingParams calldata params_, 

        bytes calldata partnerSignature_

    ) external returns(uint256);
```
</details>

### breed

Breed a new actor with administrator signed params without service fee.

```solidity
function breed(struct Structures.BreedingParams params_, uint256 serviceFee_, bytes adminSignature_) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams | The breeding params | 
| serviceFee_ | uint256 | The service fee value | 
| adminSignature_ | bytes | The admin params signature | 

**Returns**

The id of breeded actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function breed(

        Structures.BreedingParams calldata params_,

        uint256 serviceFee_,

        bytes calldata adminSignature_

    ) external returns (uint256);
```
</details>

### growUp

Grow the non-adult zombie with administrtor signature.
Takes the provided amount of tokens from the caller account.

```solidity
function growUp(uint256 id_, uint256 amount_, uint256 days_, uint256 nonce_, bytes adminSignature_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Zombie token id | 
| amount_ | uint256 | Amount of tokens transferred | 
| days_ | uint256 | Number of days to reduce adult time | 
| nonce_ | uint256 | Random non-repeating number | 
| adminSignature_ | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function growUp(

        uint256 id_,

        uint256 amount_,

        uint256 days_,

        uint256 nonce_,

        bytes calldata adminSignature_

    ) external;
```
</details>

### growUp

Grow the non-adult zombie. Takes the provided amount of tokens from 
the caller account, but not more than needed

```solidity
function growUp(uint256 id_, uint256 amount_) external nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| id_ | uint256 | Zombie token id | 
| amount_ | uint256 | Amount of tokens transferred | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function growUp(uint256 id_, uint256 amount_) external;
```
</details>

### calcGrowDays

Calculates the number of days for which the child will grow up for a given amount

```solidity
function calcGrowDays(uint256 amount_) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| amount_ | uint256 | Amount of tokens | 

**Returns**

Number of days

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function calcGrowDays(uint256 amount_) external view returns(uint256);
```
</details>

### calcGrowPrice

Calculates the amount required to grow up for a given number of days

```solidity
function calcGrowPrice(uint256 growDays_) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| growDays_ | uint256 | Number of days | 

**Returns**

Amount of tokens

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function calcGrowPrice(uint256 growDays_) external view returns(uint256);
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
