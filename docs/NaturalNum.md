# NaturalNum.sol

View Source: [solidity-big-number\project\contracts\NaturalNum.sol](..\solidity-big-number\project\contracts\NaturalNum.sol)

**NaturalNum**

## Functions

- [encode(uint256 val)](#encode)
- [decode(uint256[] num)](#decode)
- [eq(uint256[] x, uint256[] y)](#eq)
- [gt(uint256[] x, uint256[] y)](#gt)
- [lt(uint256[] x, uint256[] y)](#lt)
- [gte(uint256[] x, uint256[] y)](#gte)
- [lte(uint256[] x, uint256[] y)](#lte)
- [and(uint256[] x, uint256[] y)](#and)
- [or(uint256[] x, uint256[] y)](#or)
- [xor(uint256[] x, uint256[] y)](#xor)
- [add(uint256[] x, uint256[] y)](#add)
- [sub(uint256[] x, uint256[] y)](#sub)
- [mul(uint256[] x, uint256[] y)](#mul)
- [div(uint256[] x, uint256[] y)](#div)
- [mod(uint256[] x, uint256[] y)](#mod)
- [pow(uint256[] x, uint256 n)](#pow)
- [shl(uint256[] x, uint256 n)](#shl)
- [shr(uint256[] x, uint256 n)](#shr)
- [bitLength(uint256[] x)](#bitlength)
- [add(uint256 x, uint256 y, uint256 carry)](#add)
- [add(uint256 x, uint256 y)](#add)
- [sub(uint256 x, uint256 y, uint256 carry)](#sub)
- [sub(uint256 x, uint256 y)](#sub)
- [mul(uint256 x, uint256 y)](#mul)
- [bitLength(uint256 n)](#bitlength)
- [allocate(uint256 length)](#allocate)
- [compress(uint256[] num)](#compress)
- [cast(bool b)](#cast)

### encode

```solidity
function encode(uint256 val) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| val | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function encode(uint256 val) internal pure returns (uint256[] memory) { unchecked {
        uint256[] memory num;
        if (val > 0) {
            num = allocate(1);
            num[0] = val;
        }
        return num;
    }}
```
</details>

### decode

```solidity
function decode(uint256[] num) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| num | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function decode(uint256[] memory num) internal pure returns (uint256) { unchecked {
        if (num.length == 0)
            return 0;
        if (num.length == 1)
            return num[0];
        revert("overflow");
    }}
```
</details>

### eq

```solidity
function eq(uint256[] x, uint256[] y) internal pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function eq(uint256[] memory x, uint256[] memory y) internal pure returns (bool) { unchecked {
        if (x.length != y.length)
            return false;
        for (uint256 i = x.length; i > 0; --i)
            if (x[i - 1] != y[i - 1])
                return false;
        return true;
    }}
```
</details>

### gt

```solidity
function gt(uint256[] x, uint256[] y) internal pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function gt(uint256[] memory x, uint256[] memory y) internal pure returns (bool) { unchecked {
        if (x.length != y.length)
            return x.length > y.length;
        for (uint256 i = x.length; i > 0; --i)
            if (x[i - 1] != y[i - 1])
                return x[i - 1] > y[i - 1];
        return false;
    }}
```
</details>

### lt

```solidity
function lt(uint256[] x, uint256[] y) internal pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function lt(uint256[] memory x, uint256[] memory y) internal pure returns (bool) { unchecked {
        if (x.length != y.length)
            return x.length < y.length;
        for (uint256 i = x.length; i > 0; --i)
            if (x[i - 1] != y[i - 1])
                return x[i - 1] < y[i - 1];
        return false;
    }}
```
</details>

### gte

```solidity
function gte(uint256[] x, uint256[] y) internal pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function gte(uint256[] memory x, uint256[] memory y) internal pure returns (bool) { unchecked {
        return !lt(x, y);
    }}
```
</details>

### lte

```solidity
function lte(uint256[] x, uint256[] y) internal pure
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function lte(uint256[] memory x, uint256[] memory y) internal pure returns (bool) { unchecked {
        return !gt(x, y);
    }}
```
</details>

### and

```solidity
function and(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function and(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        (uint256[] memory min, uint256[] memory max) = x.length < y.length ? (x, y) : (y, x);

        for (uint256 i = 0; i < min.length; ++i)
            min[i] &= max[i];

        return compress(min);
    }}
```
</details>

### or

```solidity
function or(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function or(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        (uint256[] memory min, uint256[] memory max) = x.length < y.length ? (x, y) : (y, x);

        for (uint256 i = 0; i < min.length; ++i)
            max[i] |= min[i];

        return max;
    }}
```
</details>

### xor

```solidity
function xor(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function xor(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        (uint256[] memory min, uint256[] memory max) = x.length < y.length ? (x, y) : (y, x);

        for (uint256 i = 0; i < min.length; ++i)
            max[i] ^= min[i];

        return compress(max);
    }}
```
</details>

### add

```solidity
function add(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        (uint256[] memory min, uint256[] memory max) = x.length < y.length ? (x, y) : (y, x);

        uint256[] memory result = allocate(max.length + 1);
        uint256 carry = 0;

        for (uint256 i = 0; i < min.length; ++i)
            (result[i], carry) = add(min[i], max[i], carry);

        for (uint256 i = min.length; i < max.length; ++i)
            (result[i], carry) = add(0, max[i], carry);

        result[max.length] = carry;
        return compress(result);
    }}
```
</details>

### sub

```solidity
function sub(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function sub(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        require(x.length >= y.length, "underflow");

        uint256[] memory result = allocate(x.length);
        uint256 carry = 0;

        for (uint256 i = 0; i < y.length; ++i)
            (result[i], carry) = sub(x[i], y[i], carry);

        for (uint256 i = y.length; i < x.length; ++i)
            (result[i], carry) = sub(x[i], 0, carry);

        require(carry == 0, "underflow");
        return compress(result);
    }}
```
</details>

### mul

```solidity
function mul(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mul(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        uint256[] memory result;

        for (uint256 i = 0; i < x.length; i++)
            for (uint256 j = 0; j < y.length; j++)
                result = add(result, shl(mul(x[i], y[j]), (i + j) * 256));

        return result;
    }}
```
</details>

### div

```solidity
function div(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function div(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        require(y.length > 0, "division by zero");

        uint256[] memory result;
        uint256[] memory one = encode(1);

        uint256 xBitLength = bitLength(x);
        uint256 yBitLength = bitLength(y);

        while (xBitLength > yBitLength) {
            uint256 shift = xBitLength - yBitLength - 1;
            result = add(result, shl(one, shift));
            x = sub(x, shl(y, shift));
            xBitLength = bitLength(x);
        }

        if (gte(x, y))
            return add(result, one);
        return result;
    }}
```
</details>

### mod

```solidity
function mod(uint256[] x, uint256[] y) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| y | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mod(uint256[] memory x, uint256[] memory y) internal pure returns (uint256[] memory) { unchecked {
        return sub(x, mul(div(x, y), y));
    }}
```
</details>

### pow

```solidity
function pow(uint256[] x, uint256 n) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| n | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function pow(uint256[] memory x, uint256 n) internal pure returns (uint256[] memory) { unchecked {
        require(x.length > 0 || n > 0, "not a number");
        if (x.length == 0 /* && n > 0 */)
            return encode(0);
        if (/* x.length > 0 && */ n == 0)
            return encode(1);

        uint256[] memory result = encode(1);
        uint256[][] memory factors = new uint256[][](bitLength(n));

        factors[0] = x;
        for (uint256 i = 0; (n >> i) > 1; ++i)
            factors[i + 1] = mul(factors[i], factors[i]);

        for (uint256 i = 0; (n >> i) > 0; ++i)
            if (((n >> i) & 1) > 0)
                result = mul(result, factors[i]);

        return result;
    }}
```
</details>

### shl

```solidity
function shl(uint256[] x, uint256 n) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| n | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function shl(uint256[] memory x, uint256 n) internal pure returns (uint256[] memory) { unchecked {
        if (x.length == 0 || n == 0)
            return x;

        uint256 uintShift = n / 256;
        uint256 bitsShift = n % 256;
        uint256 compShift = 256 - bitsShift;

        uint256[] memory result = allocate(x.length + uintShift + 1);
        uint256 lastIndex = result.length - 1;
        uint256 remainder = 0;

        for (uint256 i = uintShift; i < lastIndex; ++i) {
            uint256 u = x[i - uintShift];
            result[i] = (u << bitsShift) | remainder;
            remainder = u >> compShift;
        }

        result[lastIndex] = remainder;
        return compress(result);
    }}
```
</details>

### shr

```solidity
function shr(uint256[] x, uint256 n) internal pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 
| n | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function shr(uint256[] memory x, uint256 n) internal pure returns (uint256[] memory) { unchecked {
        if (x.length == 0 || n == 0)
            return x;

        uint256 uintShift = n / 256;
        uint256 bitsShift = n % 256;
        uint256 compShift = 256 - bitsShift;

        if (uintShift >= x.length)
            return encode(0);

        uint256[] memory result = allocate(x.length - uintShift);
        uint256 lastIndex = result.length - 1;

        for (uint256 i = 0; i < lastIndex; ++i) {
            uint256 k = i + uintShift;
            result[i] = (x[k] >> bitsShift) | (x[k + 1] << compShift);
        }

        result[lastIndex] = x[lastIndex + uintShift] >> bitsShift;
        return compress(result);
    }}
```
</details>

### bitLength

```solidity
function bitLength(uint256[] x) internal pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function bitLength(uint256[] memory x) internal pure returns (uint256) { unchecked {
        if (x.length > 0)
            return (x.length - 1) * 256 + bitLength(x[x.length - 1]);
        return 0;
    }}
```
</details>

### add

```solidity
function add(uint256 x, uint256 y, uint256 carry) private pure
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256 |  | 
| y | uint256 |  | 
| carry | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(uint256 x, uint256 y, uint256 carry) private pure returns (uint256, uint256) { unchecked {
        if (x < type(uint256).max)
            return add(x + carry, y);
        if (y < type(uint256).max)
            return add(x, y + carry);
        return (type(uint256).max - 1 + carry, 1);
    }}
```
</details>

### add

```solidity
function add(uint256 x, uint256 y) private pure
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256 |  | 
| y | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(uint256 x, uint256 y) private pure returns (uint256, uint256) { unchecked {
        uint256 z = x + y;
        return (z, cast(z < x));
    }}
```
</details>

### sub

```solidity
function sub(uint256 x, uint256 y, uint256 carry) private pure
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256 |  | 
| y | uint256 |  | 
| carry | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function sub(uint256 x, uint256 y, uint256 carry) private pure returns (uint256, uint256) { unchecked {
        if (x > 0)
            return sub(x - carry, y);
        if (y < type(uint256).max)
            return sub(x, y + carry);
        return (1 - carry, 1);
    }}
```
</details>

### sub

```solidity
function sub(uint256 x, uint256 y) private pure
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256 |  | 
| y | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function sub(uint256 x, uint256 y) private pure returns (uint256, uint256) { unchecked {
        uint256 z = x - y;
        return (z, cast(z > x));
    }}
```
</details>

### mul

```solidity
function mul(uint256 x, uint256 y) private pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| x | uint256 |  | 
| y | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function mul(uint256 x, uint256 y) private pure returns (uint256[] memory) { unchecked {
        uint256[] memory result = allocate(2);

        uint256 p = mulmod(x, y, type(uint256).max);
        uint256 q = x * y;

        result[0] = q;
        result[1] = p - q - cast(p < q);

        return compress(result);
    }}
```
</details>

### bitLength

```solidity
function bitLength(uint256 n) private pure
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| n | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function bitLength(uint256 n) private pure returns (uint256) { unchecked {
        uint256 m;

        for (uint256 s = 128; s > 0; s >>= 1) {
            if (n >= 1 << s) {
                n >>= s;
                m |= s;
            }
        }

        return m + 1;
    }}
```
</details>

### allocate

```solidity
function allocate(uint256 length) private pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| length | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function allocate(uint256 length) private pure returns (uint256[] memory) { unchecked {
        return new uint256[](length);
    }}
```
</details>

### compress

```solidity
function compress(uint256[] num) private pure
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| num | uint256[] |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function compress(uint256[] memory num) private pure returns (uint256[] memory) { unchecked {
        uint256 length = num.length;

        while (length > 0 && num[length - 1] == 0)
            --length;

        assembly { mstore(num, length) }
        return num;
    }}
```
</details>

### cast

```solidity
function cast(bool b) private pure
returns(u uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| b | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function cast(bool b) private pure returns (uint256 u) { unchecked {
        assembly { u := b }
    }}
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
