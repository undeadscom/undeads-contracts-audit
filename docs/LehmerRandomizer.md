# LehmerRandomizer.sol

View Source: [\contracts\utils\LehmerRandomizer.sol](..\contracts\utils\LehmerRandomizer.sol)

**↗ Extends: [IRandomizer](IRandomizer.md), [OwnableUpgradeable](OwnableUpgradeable.md)**

**LehmerRandomizer**

## Contract Members
**Constants & Variables**

```js
mapping(address => uint256) private _seeds;
mapping(address => uint256) private _last;
uint256[] private A;
uint256[] private B;
uint256[] private C;
uint256[] private D;

```

## Functions

- [initialize()](#initialize)
- [_seed()](#_seed)
- [_randomize()](#_randomize)
- [randomize()](#randomize)
- [randomize(uint256 limit)](#randomize)
- [_weightedDistribution(uint256 target, uint256[] weights)](#_weighteddistribution)
- [distributeRandom(uint256 , uint256[] weights)](#distributerandom)
- [last()](#last)

### initialize

```solidity
function initialize() public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function initialize() public initializer {

        __Ownable_init();

        A = NaturalNum.encode(279470273);

        B = NaturalNum.encode(4294967295);

        C = NaturalNum.encode(5);

        D = NaturalNum.encode(4);

    }
```
</details>

### _seed

```solidity
function _seed() internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _seed() internal {

        uint256 index = uint256(uint160(msg.sender));

        _seeds[msg.sender] = (index << 1) | 1;

    }
```
</details>

### _randomize

```solidity
function _randomize() internal nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _randomize() internal returns (uint256) {

        if (_seeds[msg.sender] == 0) {

            _seed();

        }

        uint256[] memory product = NaturalNum.mul(

            NaturalNum.encode(_seeds[msg.sender]),

            A

        );

        product = NaturalNum.add(

            NaturalNum.and(product, B),

            NaturalNum.mul(C, NaturalNum.shr(product, 32))

        );

        product = NaturalNum.add(D, product);

        _seeds[msg.sender] =

            NaturalNum.decode(product) +

            5 *

            NaturalNum.decode(NaturalNum.shr(product, 32)) -

            4;

        return _seeds[msg.sender];

    }
```
</details>

### randomize

```solidity
function randomize() external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function randomize() external override returns (uint256) {

        _last[msg.sender] = _randomize();

        return _last[msg.sender];

    }
```
</details>

### randomize

```solidity
function randomize(uint256 limit) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| limit | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function randomize(uint256 limit) external override returns (uint256) {

        _last[msg.sender] = _randomize() % limit;

        return _last[msg.sender];

    }
```
</details>

### _weightedDistribution

Returns the weightened distributed value.
 [IMPORTANT]
 ====
 The weights are need to be sorted in descending order.
 target should be less or equal of summ of all weights
 This function uses Hopscotch Selection method (https://blog.bruce-hill.com/a-faster-weighted-random-choice).
 The runtime is O(1)
 ====

```solidity
function _weightedDistribution(uint256 target, uint256[] weights) private pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target | uint256 |  | 
| weights | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _weightedDistribution(uint256 target, uint256[] memory weights)

        private

        pure

        returns (uint256)

    {

        uint256 index = 0;

        while (index < weights.length && weights[index] <= target) {

            target -= weights[index];

            index++;

        }

        return index;

    }
```
</details>

### distributeRandom

Returns Random number
 [IMPORTANT]
 ====
 First parameter removed and unused as Potions during creation pass wrong total number
 ====

```solidity
function distributeRandom(uint256 , uint256[] weights) external nonpayable
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
|  | uint256 |  | 
| weights | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function distributeRandom(uint256, uint256[] memory weights)

        external

        override

        returns (uint256)

    {

        uint256 total = 0;

        for (uint256 i = 0; i < weights.length; i++) {

            total += weights[i];

        }

        require(total > 0, "LehmerRandomizer: zero total");

        uint256 randomValue =  _weightedDistribution(

            _randomize() % total,

            weights

        );

        _last[msg.sender] = randomValue;

        // fix for last item in each level

        // there is another scenario when Potions uses distributeRandom 

        // and pass weights.length == 2, so we should not apply fix for this scenario

        if (weights.length == 5) {

            if (weights[randomValue] > 1) return randomValue;

            if (randomValue > 0) {

                for (uint256 i = randomValue - 1; i >= 0; i--) {

                    if (weights[i] > 1) {

                        return i;

                    }

                }

            }

            for (uint256 i = randomValue + 1; i < weights.length; i++) {

                if (weights[i] > 1) {

                    return i;

                }

            }

        }

        return randomValue;

    }
```
</details>

### last

```solidity
function last() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function last() external view override returns (uint256) {

        return _last[msg.sender];

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
