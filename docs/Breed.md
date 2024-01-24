# Breed (Breed.sol)

View Source: [\contracts\persons\Breed.sol](..\contracts\persons\Breed.sol)

**↗ Extends: [IBreed](IBreed.md), [GuardExtensionUpgradeable](GuardExtensionUpgradeable.md)**

**Breed**

The contract is used for the breeding of the zombies

## Contract Members
**Constants & Variables**

```js
contract IActors private _zombie;
contract IRandaoRandomizer private _random;
contract IERC20 private _asset;
address private _feeAddress;
uint16 private _deviationDownPromille;
uint16 private _deviationUpPromille;
uint16 private _propertyLimit;
uint256 private _serviceFee;
uint256 private _growPeriod;
uint256 private _growPrice;
uint256 private _counter;
struct BitMaps.BitMap private _completedBreedings;
struct BitMaps.BitMap private _completedSessions;
mapping(bytes32 => bool) private _canceledSignatures;
uint16 private constant MINIMAL_PROPERTY_VALUE;
string private constant TOO_YOUNG;
string private constant INVALID_SIGNATURE;
string private constant DEAL_EXPIRED;
string private constant WRONG_OWNER;
string private constant BREEDING_ALREADY_COMPLETED;
string private constant SESSION_ALREADY_COMPLETED;
string private constant ONLY_IMMACULATE;
string private constant SIGNATURE_CANCELED;
string private constant INVALID_ASSET;
string private constant INVALID_MOTHER_GENDER;
string private constant INVALID_FATHER_GENDER;
string private constant ALREADY_ADULT;
string private constant NOT_ENOUGH;
string private constant NOT_ENOUGH_ALLOWED;
string private constant LEAST_ONE_DAY;

```

## Modifiers

- [validParams](#validparams)

### validParams

```js
modifier validParams(struct Structures.BreedingParams params_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams |  | 

## Functions

- [initialize(address rights_, address zombies_, address random_, address asset_, address feeAddress_, uint16 deviationDownPromille_, uint16 deviationUpPromille_, uint16 propertyLimit_, uint256 serviceFee_, uint256 growPeriod_, uint256 growPrice_, uint256 startFrom_)](#initialize)
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
- [_breed(struct Structures.BreedingParams params_, uint256 serviceFee_, address motherAccount_, address fatherAccount_)](#_breed)
- [growUp(uint256 id_, uint256 amount_, uint256 days_, uint256 nonce_, bytes adminSignature_)](#growup)
- [growUp(uint256 id_, uint256 amount_)](#growup)
- [calcGrowDays(uint256 amount_)](#calcgrowdays)
- [calcGrowPrice(uint256 growDays_)](#calcgrowprice)
- [_validateParams(struct Structures.BreedingParams params_)](#_validateparams)
- [_recoverAddress(bytes32 hash_, bytes signature_)](#_recoveraddress)
- [_calcProps(uint16[10] motherProps, uint16[10] fatherProps)](#_calcprops)

### initialize

constructor

```solidity
function initialize(address rights_, address zombies_, address random_, address asset_, address feeAddress_, uint16 deviationDownPromille_, uint16 deviationUpPromille_, uint16 propertyLimit_, uint256 serviceFee_, uint256 growPeriod_, uint256 growPrice_, uint256 startFrom_) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rights_ | address | , The address of the rights | 
| zombies_ | address | The address of the zombies | 
| random_ | address | The address of the random | 
| asset_ | address |  | 
| feeAddress_ | address |  | 
| deviationDownPromille_ | uint16 | The deviation to down of the actor property, in promille | 
| deviationUpPromille_ | uint16 | The deviation to up of the actor property, in promille | 
| propertyLimit_ | uint16 |  | 
| serviceFee_ | uint256 |  | 
| growPeriod_ | uint256 |  | 
| growPrice_ | uint256 |  | 
| startFrom_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function initialize(

        address rights_,

        address zombies_,

        address random_,

        address asset_,

        address feeAddress_,

        uint16 deviationDownPromille_,

        uint16 deviationUpPromille_,

        uint16 propertyLimit_,

        uint256 serviceFee_,

        uint256 growPeriod_,

        uint256 growPrice_,

        uint256 startFrom_

    ) public initializer {

        __GuardExtensionUpgradeable_init(rights_);

        _zombie = IActors(zombies_);

        _random = IRandaoRandomizer(random_);

        _asset = IERC20(asset_);

        _feeAddress = feeAddress_;

        _deviationDownPromille = deviationDownPromille_;

        _deviationUpPromille = deviationUpPromille_;

        _propertyLimit = propertyLimit_;

        _serviceFee = serviceFee_;

        _growPeriod = growPeriod_;

        _growPrice = growPrice_;

        _counter = startFrom_;

        emit DeviationUpdated(deviationDownPromille_, deviationUpPromille_);

        emit LimitUpdated(propertyLimit_);

        emit FeeAddressUpdated(feeAddress_);

        emit FeesUpdated(asset_, serviceFee_, growPrice_);

    }
```
</details>

### setFeeAddress

Set the fee receiving address

```solidity
function setFeeAddress(address feeAddress_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| feeAddress_ | address | Fee receiving address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setFeeAddress(address feeAddress_) external override haveRights {

        _feeAddress = feeAddress_;

        emit FeeAddressUpdated(feeAddress_);

    }
```
</details>

### setFees

Set the breeding and growing fees

```solidity
function setFees(uint256 serviceFee_, uint256 growPrice_, address asset_) external nonpayable haveRights 
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
function setFees(

        uint256 serviceFee_,

        uint256 growPrice_,

        address asset_

    ) external override haveRights {

        _serviceFee = serviceFee_;

        _growPrice = growPrice_;

        _asset = IERC20(asset_);

        emit FeesUpdated(asset_, serviceFee_, growPrice_);

    }
```
</details>

### setGrowPeriod

Set the growing up period in seconds

```solidity
function setGrowPeriod(uint256 growPeriod_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| growPeriod_ | uint256 | Growing up period value | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setGrowPeriod(uint256 growPeriod_) external override haveRights {

        _growPeriod = growPeriod_;

        emit GrowPeriodUpdated(growPeriod_);

    }
```
</details>

### setPropertyLimit

Set the maximum allowed limit of the actor property in ppm

```solidity
function setPropertyLimit(uint16 limitPromille_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| limitPromille_ | uint16 | Limit value in ppm | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setPropertyLimit(uint16 limitPromille_) external override haveRights {

        _propertyLimit = limitPromille_;

        emit LimitUpdated(limitPromille_);

    }
```
</details>

### setDeviation

Set the maximum deviation of the actor property in ppm

```solidity
function setDeviation(uint16 deviationDownPromille_, uint16 deviationUpPromille_) external nonpayable haveRights 
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

    ) external override haveRights {

        _deviationDownPromille = deviationDownPromille_;

        _deviationUpPromille = deviationUpPromille_;

        emit DeviationUpdated(deviationDownPromille_, deviationUpPromille_);

    }
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
function getFeeAddress() external view override returns(address) {

        return _feeAddress;

    }
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
function getAsset() external view override returns(address) {

        return address(_asset);

    }
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
function getServiceFee() external view override returns(uint256) {

        return _serviceFee;

    }
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
function getGrowPeriod() external view override returns(uint256) {

        return _growPeriod;

    }
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
function getPropertyLimit() external view override returns (uint16) {

        return _propertyLimit;

    }
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
function getDeviation() external view override returns (uint16, uint16) {

        return (_deviationDownPromille, _deviationUpPromille);

    }
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
function getCounter() external view override returns (uint256) {

        return _counter;

    }
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
function cancelSignature(bytes32 hash_, bytes calldata signature_) external {        

        // administrator can cancel any signatures

        if (!_rights().haveRights(address(this), msg.sender)) {

            require(_recoverAddress(hash_, signature_) == msg.sender, INVALID_SIGNATURE);

        }

        _canceledSignatures[keccak256(signature_)] = true;

        emit SignatureCanceled(msg.sender, signature_);

    }
```
</details>

### breed

Breed a new actor from the father and mother.

```solidity
function breed(struct Structures.BreedingParams params_, bytes partnerSignature_) external nonpayable validParams 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams | The breeding params | 
| partnerSignature_ | bytes | The partner params signature.  Not required if sender is mother and father. | 

**Returns**

The id of breeded actor

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function breed(        

        Structures.BreedingParams calldata params_,

        bytes calldata partnerSignature_

    ) external override validParams(params_) returns(uint256) {        

        address motherAccount = _zombie.ownerOf(params_.motherId);

        address fatherAccount = _zombie.ownerOf(params_.fatherId);

        if (motherAccount != fatherAccount) {

            address signer = _recoverAddress(keccak256(abi.encode(params_)), partnerSignature_);

            if (motherAccount == msg.sender) {

                require(signer == fatherAccount, INVALID_SIGNATURE);

            } else if (fatherAccount == msg.sender) {

                require(signer == motherAccount, INVALID_SIGNATURE);

            } else {

                revert(WRONG_OWNER);

            }

        } else {

            require(motherAccount == msg.sender, WRONG_OWNER);

        }

        return _breed(params_, _serviceFee, motherAccount, fatherAccount);

    }
```
</details>

### breed

Breed a new actor with administrator signed params. 
The admin sets the service fee.

```solidity
function breed(struct Structures.BreedingParams params_, uint256 serviceFee_, bytes adminSignature_) external nonpayable validParams 
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

    ) external override validParams(params_) returns (uint256) {

        // administrator can allow any breedings

        address signer = _recoverAddress(keccak256(abi.encode(params_, serviceFee_)), adminSignature_);

        require(_rights().haveRights(address(this), signer), INVALID_SIGNATURE);

        IActors zombie = _zombie;

        address motherAccount = zombie.ownerOf(params_.motherId);

        address fatherAccount = zombie.ownerOf(params_.fatherId);

        return _breed(params_, serviceFee_, motherAccount, fatherAccount);

    }
```
</details>

### _breed

```solidity
function _breed(struct Structures.BreedingParams params_, uint256 serviceFee_, address motherAccount_, address fatherAccount_) internal nonpayable
returns(kidId uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams |  | 
| serviceFee_ | uint256 |  | 
| motherAccount_ | address |  | 
| fatherAccount_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _breed(

        Structures.BreedingParams calldata params_,

        uint256 serviceFee_,

        address motherAccount_,

        address fatherAccount_

    ) internal returns(uint256 kidId) {

        _completedBreedings.set(params_.breedingId);

        _completedSessions.set(params_.sessionId);

        IActors zombie = _zombie;

        IERC20 asset = _asset;

        zombie.breedChild(params_.motherId);

        uint16[10] memory props = _calcProps(

            zombie.getProps(params_.motherId), 

            zombie.getProps(params_.fatherId)

        );

        address kidOwner;

        address breedingFeeOwner;

        if (params_.isKidForMother) {

            kidOwner = motherAccount_;

            breedingFeeOwner = fatherAccount_;

        } else {

            kidOwner = fatherAccount_;

            breedingFeeOwner = motherAccount_;

        }

        uint256 breedingFee =  motherAccount_ != fatherAccount_

            ? params_.breedingFee

            : 0;

        if (breedingFee > 0) {

            asset.transferFrom(kidOwner, breedingFeeOwner, breedingFee);

        }

        if (serviceFee_ > 0) {

            asset.transferFrom(kidOwner, _feeAddress, serviceFee_);

        }

        ++_counter;

        kidId = zombie.mint(_counter, kidOwner, props, true, true, block.timestamp + _growPeriod, 0, false);

        emit BreedingCompleted(

            kidId, 

            params_.breedingId, 

            params_.sessionId,

            params_.motherId, 

            params_.fatherId, 

            breedingFee, 

            serviceFee_

        );

    }
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

    ) external {

        IActors zombie = _zombie;

        IERC20 asset = _asset;

        require(!zombie.isAdult(id_), ALREADY_ADULT);

        // administrator can allow growing up any zombie 

        address signer = _recoverAddress(keccak256(abi.encode(id_, days_, nonce_)), adminSignature_);

        require(_rights().haveRights(address(this), signer), INVALID_SIGNATURE);

        _canceledSignatures[keccak256(adminSignature_)] = true;

        if (amount_ > 0) {

            require(asset.balanceOf(msg.sender) >= amount_, NOT_ENOUGH);

            require(asset.allowance(msg.sender, address(this)) >= amount_, NOT_ENOUGH_ALLOWED);

            asset.transferFrom(msg.sender, _feeAddress, amount_); 

        }

        uint256 adultTime = zombie.getAdultTime(id_);

        uint256 growInterval = adultTime - block.timestamp;

        if (growInterval <= days_ * 1 days) {

            zombie.setAdultTime(id_, block.timestamp);

            emit Adult(id_, msg.sender, amount_);

        } else {

            uint256 newAdultTime = adultTime - days_ * 1 days;

            zombie.setAdultTime(id_, newAdultTime);

            emit Grow(id_, msg.sender, amount_, newAdultTime);

        }

    }
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
function growUp(uint256 id_, uint256 amount_) external { 

        IActors zombie = _zombie;

        IERC20 asset = _asset;

        require(!zombie.isAdult(id_), ALREADY_ADULT);

        require(amount_ >= _growPrice, LEAST_ONE_DAY);

        uint256 adultTime = zombie.getAdultTime(id_);

        uint256 growInterval = adultTime - block.timestamp;

        // Always round up

        uint256 daysToAdult = growInterval / 1 days + 1;

        uint256 paidDays = calcGrowDays(amount_);

        if (paidDays >= daysToAdult) {

            uint256 price = calcGrowPrice(daysToAdult);

            require(asset.balanceOf(msg.sender) >= price, NOT_ENOUGH);

            require(asset.allowance(msg.sender, address(this)) >= price, NOT_ENOUGH_ALLOWED);

            asset.transferFrom(msg.sender, _feeAddress, price);

            zombie.setAdultTime(id_, block.timestamp);

            emit Adult(id_, msg.sender, price);

        } else {

            uint256 price = calcGrowPrice(paidDays);

            uint256 newAdultTime = adultTime - paidDays * 1 days;

            require(asset.balanceOf(msg.sender) >= price, NOT_ENOUGH);

            require(asset.allowance(msg.sender, address(this)) >= price, NOT_ENOUGH_ALLOWED);

            asset.transferFrom(msg.sender, _feeAddress, price); 

            zombie.setAdultTime(id_, newAdultTime);

            emit Grow(id_, msg.sender, price, newAdultTime);

        }        

    }
```
</details>

### calcGrowDays

Calculates the number of days for which the child will grow up for a given amount

```solidity
function calcGrowDays(uint256 amount_) public view
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
function calcGrowDays(uint256 amount_) public view override returns(uint256) {

        return amount_ / _growPrice; 

    }
```
</details>

### calcGrowPrice

Calculates the amount required to grow up for a given number of days

```solidity
function calcGrowPrice(uint256 growDays_) public view
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
function calcGrowPrice(uint256 growDays_) public view override returns(uint256) {

        return growDays_ * _growPrice; 

    }
```
</details>

### _validateParams

```solidity
function _validateParams(struct Structures.BreedingParams params_) internal view
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| params_ | struct Structures.BreedingParams |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _validateParams(        

        Structures.BreedingParams calldata params_

    ) internal view {

        IActors zombie = _zombie;

        require(block.timestamp <= params_.deadline, DEAL_EXPIRED);

        require(zombie.isAdult(params_.motherId) && zombie.isAdult(params_.fatherId), TOO_YOUNG);

        require(zombie.getImmaculate(params_.motherId), ONLY_IMMACULATE);

        require(zombie.getImmaculate(params_.fatherId), ONLY_IMMACULATE);

        require(!_completedBreedings.get(params_.breedingId), BREEDING_ALREADY_COMPLETED);

        require(!_completedSessions.get(params_.sessionId), SESSION_ALREADY_COMPLETED);

        require(zombie.getSex(params_.fatherId), INVALID_FATHER_GENDER);

        require(!zombie.getSex(params_.motherId), INVALID_MOTHER_GENDER);

        require(params_.asset == address(_asset), INVALID_ASSET);

    }
```
</details>

### _recoverAddress

```solidity
function _recoverAddress(bytes32 hash_, bytes signature_) internal view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash_ | bytes32 |  | 
| signature_ | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _recoverAddress(

        bytes32 hash_, 

        bytes calldata signature_

    ) internal view returns(address) {

        require(!_canceledSignatures[keccak256(signature_)], SIGNATURE_CANCELED);

        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash_);

        return ECDSA.recover(ethSignedMessageHash, signature_);

    }
```
</details>

### _calcProps

```solidity
function _calcProps(uint16[10] motherProps, uint16[10] fatherProps) internal nonpayable
returns(props uint16[10])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| motherProps | uint16[10] |  | 
| fatherProps | uint16[10] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _calcProps(

        uint16[10] memory motherProps,

        uint16[10] memory fatherProps

    ) internal returns (uint16[10] memory props) {

        uint256 randomValue = _random.randomize();

        for (uint8 i; i < 10;) {            

            uint256 middle = (uint256(fatherProps[i]) + motherProps[i]) / 2;

            uint256 minimal = middle - (middle * _deviationDownPromille / 1000);

            uint256 maximal = middle + (middle * _deviationUpPromille / 1000);

            uint256 range = maximal - minimal;

            uint256 deviationRandom = randomValue % 10 ** (6 + i) / 10 ** i;

            uint256 value = deviationRandom % range + minimal;

            if (value >= type(uint16).max) {

                props[i] = type(uint16).max;

            } else if (value <= MINIMAL_PROPERTY_VALUE) {

                props[i] = MINIMAL_PROPERTY_VALUE;

            } else {

                props[i] = uint16(value);

            }

            unchecked { ++i; }

        }

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
