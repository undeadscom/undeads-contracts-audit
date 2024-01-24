# EnumerableSet.sol

View Source: [@openzeppelin\contracts\utils\structs\EnumerableSet.sol](..\@openzeppelin\contracts\utils\structs\EnumerableSet.sol)

**EnumerableSet**

Library for managing
 https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 types.
 Sets have the following properties:
 - Elements are added, removed, and checked for existence in constant time
 (O(1)).
 - Elements are enumerated in O(n). No guarantees are made on the ordering.
 ```
 contract Example {
     // Add the library methods
     using EnumerableSet for EnumerableSet.AddressSet;
     // Declare a set state variable
     EnumerableSet.AddressSet private mySet;
 }
 ```
 As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 and `uint256` (`UintSet`) are supported.
 [WARNING]
 ====
 Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 unusable.
 See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 array of EnumerableSet.
 ====

## Structs
### Set

```js
struct Set {
 bytes32[] _values,
 mapping(bytes32 => uint256) _indexes
}
```

### Bytes32Set

```js
struct Bytes32Set {
 struct EnumerableSet.Set _inner
}
```

### AddressSet

```js
struct AddressSet {
 struct EnumerableSet.Set _inner
}
```

### UintSet

```js
struct UintSet {
 struct EnumerableSet.Set _inner
}
```

## Functions

- [_add(struct EnumerableSet.Set set, bytes32 value)](#_add)
- [_remove(struct EnumerableSet.Set set, bytes32 value)](#_remove)
- [_contains(struct EnumerableSet.Set set, bytes32 value)](#_contains)
- [_length(struct EnumerableSet.Set set)](#_length)
- [_at(struct EnumerableSet.Set set, uint256 index)](#_at)
- [_values(struct EnumerableSet.Set set)](#_values)
- [add(struct EnumerableSet.Bytes32Set set, bytes32 value)](#add)
- [remove(struct EnumerableSet.Bytes32Set set, bytes32 value)](#remove)
- [contains(struct EnumerableSet.Bytes32Set set, bytes32 value)](#contains)
- [length(struct EnumerableSet.Bytes32Set set)](#length)
- [at(struct EnumerableSet.Bytes32Set set, uint256 index)](#at)
- [values(struct EnumerableSet.Bytes32Set set)](#values)
- [add(struct EnumerableSet.AddressSet set, address value)](#add)
- [remove(struct EnumerableSet.AddressSet set, address value)](#remove)
- [contains(struct EnumerableSet.AddressSet set, address value)](#contains)
- [length(struct EnumerableSet.AddressSet set)](#length)
- [at(struct EnumerableSet.AddressSet set, uint256 index)](#at)
- [values(struct EnumerableSet.AddressSet set)](#values)
- [add(struct EnumerableSet.UintSet set, uint256 value)](#add)
- [remove(struct EnumerableSet.UintSet set, uint256 value)](#remove)
- [contains(struct EnumerableSet.UintSet set, uint256 value)](#contains)
- [length(struct EnumerableSet.UintSet set)](#length)
- [at(struct EnumerableSet.UintSet set, uint256 index)](#at)
- [values(struct EnumerableSet.UintSet set)](#values)

### _add

Add a value to a set. O(1).
 Returns true if the value was added to the set, that is if it was not
 already present.

```solidity
function _add(struct EnumerableSet.Set set, bytes32 value) private nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }
```
</details>

### _remove

Removes a value from a set. O(1).
 Returns true if the value was removed from the set, that is if it was
 present.

```solidity
function _remove(struct EnumerableSet.Set set, bytes32 value) private nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }
```
</details>

### _contains

Returns true if the value is in the set. O(1).

```solidity
function _contains(struct EnumerableSet.Set set, bytes32 value) private view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }
```
</details>

### _length

Returns the number of values on the set. O(1).

```solidity
function _length(struct EnumerableSet.Set set) private view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }
```
</details>

### _at

Returns the value stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function _at(struct EnumerableSet.Set set, uint256 index) private view
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }
```
</details>

### _values

Return the entire set in an array
 WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
 to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
 this function has an unbounded cost, and using it as part of a state-changing function may render the function
 uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.

```solidity
function _values(struct EnumerableSet.Set set) private view
returns(bytes32[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Set |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }
```
</details>

### add

Add a value to a set. O(1).
 Returns true if the value was added to the set, that is if it was not
 already present.

```solidity
function add(struct EnumerableSet.Bytes32Set set, bytes32 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the value was removed from the set, that is if it was
 present.

```solidity
function remove(struct EnumerableSet.Bytes32Set set, bytes32 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }
```
</details>

### contains

Returns true if the value is in the set. O(1).

```solidity
function contains(struct EnumerableSet.Bytes32Set set, bytes32 value) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 
| value | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }
```
</details>

### length

Returns the number of values in the set. O(1).

```solidity
function length(struct EnumerableSet.Bytes32Set set) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }
```
</details>

### at

Returns the value stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableSet.Bytes32Set set, uint256 index) internal view
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }
```
</details>

### values

Return the entire set in an array
 WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
 to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
 this function has an unbounded cost, and using it as part of a state-changing function may render the function
 uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.

```solidity
function values(struct EnumerableSet.Bytes32Set set) internal view
returns(bytes32[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.Bytes32Set |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
```
</details>

### add

Add a value to a set. O(1).
 Returns true if the value was added to the set, that is if it was not
 already present.

```solidity
function add(struct EnumerableSet.AddressSet set, address value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 
| value | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the value was removed from the set, that is if it was
 present.

```solidity
function remove(struct EnumerableSet.AddressSet set, address value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 
| value | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }
```
</details>

### contains

Returns true if the value is in the set. O(1).

```solidity
function contains(struct EnumerableSet.AddressSet set, address value) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 
| value | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }
```
</details>

### length

Returns the number of values in the set. O(1).

```solidity
function length(struct EnumerableSet.AddressSet set) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }
```
</details>

### at

Returns the value stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableSet.AddressSet set, uint256 index) internal view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }
```
</details>

### values

Return the entire set in an array
 WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
 to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
 this function has an unbounded cost, and using it as part of a state-changing function may render the function
 uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.

```solidity
function values(struct EnumerableSet.AddressSet set) internal view
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.AddressSet |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
```
</details>

### add

Add a value to a set. O(1).
 Returns true if the value was added to the set, that is if it was not
 already present.

```solidity
function add(struct EnumerableSet.UintSet set, uint256 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }
```
</details>

### remove

Removes a value from a set. O(1).
 Returns true if the value was removed from the set, that is if it was
 present.

```solidity
function remove(struct EnumerableSet.UintSet set, uint256 value) internal nonpayable
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }
```
</details>

### contains

Returns true if the value is in the set. O(1).

```solidity
function contains(struct EnumerableSet.UintSet set, uint256 value) internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 
| value | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }
```
</details>

### length

Returns the number of values in the set. O(1).

```solidity
function length(struct EnumerableSet.UintSet set) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }
```
</details>

### at

Returns the value stored at position `index` in the set. O(1).
 Note that there are no guarantees on the ordering of values inside the
 array, and it may change when more values are added or removed.
 Requirements:
 - `index` must be strictly less than {length}.

```solidity
function at(struct EnumerableSet.UintSet set, uint256 index) internal view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 
| index | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
```
</details>

### values

Return the entire set in an array
 WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
 to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
 this function has an unbounded cost, and using it as part of a state-changing function may render the function
 uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.

```solidity
function values(struct EnumerableSet.UintSet set) internal view
returns(uint256[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| set | struct EnumerableSet.UintSet |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
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
