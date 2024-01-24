# EnumerableMap.sol

View Source: [@openzeppelin\contracts\utils\structs\EnumerableMap.sol](..\@openzeppelin\contracts\utils\structs\EnumerableMap.sol)

**EnumerableMap**

Library for managing an enumerable variant of Solidity's
 https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
 type.
 Maps have the following properties:
 - Entries are added, removed, and checked for existence in constant time
 (O(1)).
 - Entries are enumerated in O(n). No guarantees are made on the ordering.
 ```
 contract Example {
     // Add the library methods
     using EnumerableMap for EnumerableMap.UintToAddressMap;
     // Declare a set state variable
     EnumerableMap.UintToAddressMap private myMap;
 }
 ```
 The following map types are supported:
 - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
 - `address -> uint256` (`AddressToUintMap`) since v4.6.0
 - `bytes32 -> bytes32` (`Bytes32ToBytes32Map`) since v4.6.0
 - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
 - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
 [WARNING]
 ====
 Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 unusable.
 See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an
 array of EnumerableMap.
 ====

## Structs
### Bytes32ToBytes32Map

```js
struct Bytes32ToBytes32Map {
 struct EnumerableSet.Bytes32Set _keys,
 mapping(bytes32 => bytes32) _values
}
```

### UintToUintMap

```js
struct UintToUintMap {
 struct EnumerableMap.Bytes32ToBytes32Map _inner
}
```

### UintToAddressMap

```js
struct UintToAddressMap {
 struct EnumerableMap.Bytes32ToBytes32Map _inner
}
```

### AddressToUintMap

```js
struct AddressToUintMap {
 struct EnumerableMap.Bytes32ToBytes32Map _inner
}
```

### Bytes32ToUintMap

```js
struct Bytes32ToUintMap {
 struct EnumerableMap.Bytes32ToBytes32Map _inner
}
```

## Functions

- [set(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key, bytes32 value)](#set)
- [remove(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key)](#remove)
- [contains(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key)](#contains)
- [length(struct EnumerableMap.Bytes32ToBytes32Map map)](#length)
- [at(struct EnumerableMap.Bytes32ToBytes32Map map, uint256 index)](#at)
- [tryGet(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key)](#tryget)
- [get(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key)](#get)
- [get(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key, string errorMessage)](#get)
- [set(struct EnumerableMap.UintToUintMap map, uint256 key, uint256 value)](#set)
- [remove(struct EnumerableMap.UintToUintMap map, uint256 key)](#remove)
- [contains(struct EnumerableMap.UintToUintMap map, uint256 key)](#contains)
- [length(struct EnumerableMap.UintToUintMap map)](#length)
- [at(struct EnumerableMap.UintToUintMap map, uint256 index)](#at)
- [tryGet(struct EnumerableMap.UintToUintMap map, uint256 key)](#tryget)
- [get(struct EnumerableMap.UintToUintMap map, uint256 key)](#get)
- [get(struct EnumerableMap.UintToUintMap map, uint256 key, string errorMessage)](#get)
- [set(struct EnumerableMap.UintToAddressMap map, uint256 key, address value)](#set)
- [remove(struct EnumerableMap.UintToAddressMap map, uint256 key)](#remove)
- [contains(struct EnumerableMap.UintToAddressMap map, uint256 key)](#contains)
- [length(struct EnumerableMap.UintToAddressMap map)](#length)
- [at(struct EnumerableMap.UintToAddressMap map, uint256 index)](#at)
- [tryGet(struct EnumerableMap.UintToAddressMap map, uint256 key)](#tryget)
- [get(struct EnumerableMap.UintToAddressMap map, uint256 key)](#get)
- [get(struct EnumerableMap.UintToAddressMap map, uint256 key, string errorMessage)](#get)
- [set(struct EnumerableMap.AddressToUintMap map, address key, uint256 value)](#set)
- [remove(struct EnumerableMap.AddressToUintMap map, address key)](#remove)
- [contains(struct EnumerableMap.AddressToUintMap map, address key)](#contains)
- [length(struct EnumerableMap.AddressToUintMap map)](#length)
- [at(struct EnumerableMap.AddressToUintMap map, uint256 index)](#at)
- [tryGet(struct EnumerableMap.AddressToUintMap map, address key)](#tryget)
- [get(struct EnumerableMap.AddressToUintMap map, address key)](#get)
- [get(struct EnumerableMap.AddressToUintMap map, address key, string errorMessage)](#get)
- [set(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key, uint256 value)](#set)
- [remove(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key)](#remove)
- [contains(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key)](#contains)
- [length(struct EnumerableMap.Bytes32ToUintMap map)](#length)
- [at(struct EnumerableMap.Bytes32ToUintMap map, uint256 index)](#at)
- [tryGet(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key)](#tryget)
- [get(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key)](#get)
- [get(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key, string errorMessage)](#get)

### set

Adds a key-value pair to a map, or updates the value for an existing
 key. O(1).
 Returns true if the key was added to the map, that is if it was not
 already present.

```solidity
function set(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key, bytes32 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(
        Bytes32ToBytes32Map storage map,
        bytes32 key,
        bytes32 value
    ) internal returns (bool) {
        map._values[key] = value;
        return map._keys.add(key);
    }
```
</details>

### remove

Removes a key-value pair from a map. O(1).
 Returns true if the key was removed from the map, that is if it was present.

```solidity
function remove(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
        delete map._values[key];
        return map._keys.remove(key);
    }
```
</details>

### contains

Returns true if the key is in the map. O(1).

```solidity
function contains(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
        return map._keys.contains(key);
    }
```
</details>

### length

Returns the number of key-value pairs in the map. O(1).

```solidity
function length(struct EnumerableMap.Bytes32ToBytes32Map map) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
        return map._keys.length();
    }
```
</details>

### at

Returns the key-value pair stored at position `index` in the map. O(1).
 Note that there are no guarantees on the ordering of entries inside the
 array, and it may change when more entries are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableMap.Bytes32ToBytes32Map map, uint256 index) internal view
returns(bytes32, bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
        bytes32 key = map._keys.at(index);
        return (key, map._values[key]);
    }
```
</details>

### tryGet

Tries to returns the value associated with `key`. O(1).
 Does not revert if `key` is not in the map.

```solidity
function tryGet(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key) internal view
returns(bool, bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
        bytes32 value = map._values[key];
        if (value == bytes32(0)) {
            return (contains(map, key), bytes32(0));
        } else {
            return (true, value);
        }
    }
```
</details>

### get

Returns the value associated with `key`. O(1).
 Requirements:
 - `key` must be in the map.

```solidity
function get(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key) internal view
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
        bytes32 value = map._values[key];
        require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
        return value;
    }
```
</details>

### get

Same as {get}, with a custom error message when `key` is not in the map.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryGet}.

```solidity
function get(struct EnumerableMap.Bytes32ToBytes32Map map, bytes32 key, string errorMessage) internal view
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToBytes32Map |  | 
| key | bytes32 |  | 
| errorMessage | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(
        Bytes32ToBytes32Map storage map,
        bytes32 key,
        string memory errorMessage
    ) internal view returns (bytes32) {
        bytes32 value = map._values[key];
        require(value != 0 || contains(map, key), errorMessage);
        return value;
    }
```
</details>

### set

Adds a key-value pair to a map, or updates the value for an existing
 key. O(1).
 Returns true if the key was added to the map, that is if it was not
 already present.

```solidity
function set(struct EnumerableMap.UintToUintMap map, uint256 key, uint256 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(
        UintToUintMap storage map,
        uint256 key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, bytes32(key), bytes32(value));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the key was removed from the map, that is if it was present.

```solidity
function remove(struct EnumerableMap.UintToUintMap map, uint256 key) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
        return remove(map._inner, bytes32(key));
    }
```
</details>

### contains

Returns true if the key is in the map. O(1).

```solidity
function contains(struct EnumerableMap.UintToUintMap map, uint256 key) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
        return contains(map._inner, bytes32(key));
    }
```
</details>

### length

Returns the number of elements in the map. O(1).

```solidity
function length(struct EnumerableMap.UintToUintMap map) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(UintToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }
```
</details>

### at

Returns the element stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableMap.UintToUintMap map, uint256 index) internal view
returns(uint256, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (uint256(key), uint256(value));
    }
```
</details>

### tryGet

Tries to returns the value associated with `key`. O(1).
 Does not revert if `key` is not in the map.

```solidity
function tryGet(struct EnumerableMap.UintToUintMap map, uint256 key) internal view
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
        return (success, uint256(value));
    }
```
</details>

### get

Returns the value associated with `key`. O(1).
 Requirements:
 - `key` must be in the map.

```solidity
function get(struct EnumerableMap.UintToUintMap map, uint256 key) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(key)));
    }
```
</details>

### get

Same as {get}, with a custom error message when `key` is not in the map.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryGet}.

```solidity
function get(struct EnumerableMap.UintToUintMap map, uint256 key, string errorMessage) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToUintMap |  | 
| key | uint256 |  | 
| errorMessage | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(
        UintToUintMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(key), errorMessage));
    }
```
</details>

### set

Adds a key-value pair to a map, or updates the value for an existing
 key. O(1).
 Returns true if the key was added to the map, that is if it was not
 already present.

```solidity
function set(struct EnumerableMap.UintToAddressMap map, uint256 key, address value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 
| value | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(
        UintToAddressMap storage map,
        uint256 key,
        address value
    ) internal returns (bool) {
        return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the key was removed from the map, that is if it was present.

```solidity
function remove(struct EnumerableMap.UintToAddressMap map, uint256 key) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return remove(map._inner, bytes32(key));
    }
```
</details>

### contains

Returns true if the key is in the map. O(1).

```solidity
function contains(struct EnumerableMap.UintToAddressMap map, uint256 key) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return contains(map._inner, bytes32(key));
    }
```
</details>

### length

Returns the number of elements in the map. O(1).

```solidity
function length(struct EnumerableMap.UintToAddressMap map) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(UintToAddressMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }
```
</details>

### at

Returns the element stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableMap.UintToAddressMap map, uint256 index) internal view
returns(uint256, address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (uint256(key), address(uint160(uint256(value))));
    }
```
</details>

### tryGet

Tries to returns the value associated with `key`. O(1).
 Does not revert if `key` is not in the map.

```solidity
function tryGet(struct EnumerableMap.UintToAddressMap map, uint256 key) internal view
returns(bool, address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
        return (success, address(uint160(uint256(value))));
    }
```
</details>

### get

Returns the value associated with `key`. O(1).
 Requirements:
 - `key` must be in the map.

```solidity
function get(struct EnumerableMap.UintToAddressMap map, uint256 key) internal view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint160(uint256(get(map._inner, bytes32(key)))));
    }
```
</details>

### get

Same as {get}, with a custom error message when `key` is not in the map.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryGet}.

```solidity
function get(struct EnumerableMap.UintToAddressMap map, uint256 key, string errorMessage) internal view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.UintToAddressMap |  | 
| key | uint256 |  | 
| errorMessage | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(
        UintToAddressMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (address) {
        return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
    }
```
</details>

### set

Adds a key-value pair to a map, or updates the value for an existing
 key. O(1).
 Returns true if the key was added to the map, that is if it was not
 already present.

```solidity
function set(struct EnumerableMap.AddressToUintMap map, address key, uint256 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(
        AddressToUintMap storage map,
        address key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the key was removed from the map, that is if it was present.

```solidity
function remove(struct EnumerableMap.AddressToUintMap map, address key) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(AddressToUintMap storage map, address key) internal returns (bool) {
        return remove(map._inner, bytes32(uint256(uint160(key))));
    }
```
</details>

### contains

Returns true if the key is in the map. O(1).

```solidity
function contains(struct EnumerableMap.AddressToUintMap map, address key) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
        return contains(map._inner, bytes32(uint256(uint160(key))));
    }
```
</details>

### length

Returns the number of elements in the map. O(1).

```solidity
function length(struct EnumerableMap.AddressToUintMap map) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(AddressToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }
```
</details>

### at

Returns the element stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableMap.AddressToUintMap map, uint256 index) internal view
returns(address, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (address(uint160(uint256(key))), uint256(value));
    }
```
</details>

### tryGet

Tries to returns the value associated with `key`. O(1).
 Does not revert if `key` is not in the map.

```solidity
function tryGet(struct EnumerableMap.AddressToUintMap map, address key) internal view
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
        return (success, uint256(value));
    }
```
</details>

### get

Returns the value associated with `key`. O(1).
 Requirements:
 - `key` must be in the map.

```solidity
function get(struct EnumerableMap.AddressToUintMap map, address key) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
    }
```
</details>

### get

Same as {get}, with a custom error message when `key` is not in the map.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryGet}.

```solidity
function get(struct EnumerableMap.AddressToUintMap map, address key, string errorMessage) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.AddressToUintMap |  | 
| key | address |  | 
| errorMessage | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(
        AddressToUintMap storage map,
        address key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
    }
```
</details>

### set

Adds a key-value pair to a map, or updates the value for an existing
 key. O(1).
 Returns true if the key was added to the map, that is if it was not
 already present.

```solidity
function set(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key, uint256 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function set(
        Bytes32ToUintMap storage map,
        bytes32 key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, key, bytes32(value));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the key was removed from the map, that is if it was present.

```solidity
function remove(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
        return remove(map._inner, key);
    }
```
</details>

### contains

Returns true if the key is in the map. O(1).

```solidity
function contains(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
        return contains(map._inner, key);
    }
```
</details>

### length

Returns the number of elements in the map. O(1).

```solidity
function length(struct EnumerableMap.Bytes32ToUintMap map) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }
```
</details>

### at

Returns the element stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableMap.Bytes32ToUintMap map, uint256 index) internal view
returns(bytes32, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (key, uint256(value));
    }
```
</details>

### tryGet

Tries to returns the value associated with `key`. O(1).
 Does not revert if `key` is not in the map.

```solidity
function tryGet(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key) internal view
returns(bool, uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, key);
        return (success, uint256(value));
    }
```
</details>

### get

Returns the value associated with `key`. O(1).
 Requirements:
 - `key` must be in the map.

```solidity
function get(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
        return uint256(get(map._inner, key));
    }
```
</details>

### get

Same as {get}, with a custom error message when `key` is not in the map.
 CAUTION: This function is deprecated because it requires allocating memory for the error
 message unnecessarily. For custom revert reasons use {tryGet}.

```solidity
function get(struct EnumerableMap.Bytes32ToUintMap map, bytes32 key, string errorMessage) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| map | struct EnumerableMap.Bytes32ToUintMap |  | 
| key | bytes32 |  | 
| errorMessage | string |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function get(
        Bytes32ToUintMap storage map,
        bytes32 key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, key, errorMessage));
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
