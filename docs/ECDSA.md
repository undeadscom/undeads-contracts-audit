# ECDSA.sol

View Source: [@openzeppelin\contracts\utils\cryptography\ECDSA.sol](..\@openzeppelin\contracts\utils\cryptography\ECDSA.sol)

**ECDSA**

Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 These functions can be used to verify that a message was signed by the holder
 of the private keys of a given address.

**Enums**
### RecoverError

```js
enum RecoverError {
 NoError,
 InvalidSignature,
 InvalidSignatureLength,
 InvalidSignatureS,
 InvalidSignatureV
}
```

## Functions

- [_throwError(enum ECDSA.RecoverError error)](#_throwerror)
- [tryRecover(bytes32 hash, bytes signature)](#tryrecover)
- [recover(bytes32 hash, bytes signature)](#recover)
- [tryRecover(bytes32 hash, bytes32 r, bytes32 vs)](#tryrecover)
- [recover(bytes32 hash, bytes32 r, bytes32 vs)](#recover)
- [tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)](#tryrecover)
- [recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)](#recover)
- [toEthSignedMessageHash(bytes32 hash)](#toethsignedmessagehash)
- [toEthSignedMessageHash(bytes s)](#toethsignedmessagehash)
- [toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)](#totypeddatahash)

### _throwError

```solidity
function _throwError(enum ECDSA.RecoverError error) private pure
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| error | enum ECDSA.RecoverError |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        }
    }
```
</details>

### tryRecover

Returns the address that signed a hashed message (`hash`) with
 `signature` or error string. This address can then be used for verification purposes.
 The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
 this function rejects them by requiring the `s` value to be in the lower
 half order, and the `v` value to be either 27 or 28.
 IMPORTANT: `hash` _must_ be the result of a hash operation for the
 verification to be secure: it is possible to craft signatures that
 recover to arbitrary addresses for non-hashed data. A safe way to ensure
 this is by receiving a hash of the original message (which may otherwise
 be too long), and then calling {toEthSignedMessageHash} on it.
 Documentation for signature generation:
 - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
 - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
 _Available since v4.3._

```solidity
function tryRecover(bytes32 hash, bytes signature) internal pure
returns(address, enum ECDSA.RecoverError)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| signature | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }
```
</details>

### recover

Returns the address that signed a hashed message (`hash`) with
 `signature`. This address can then be used for verification purposes.
 The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
 this function rejects them by requiring the `s` value to be in the lower
 half order, and the `v` value to be either 27 or 28.
 IMPORTANT: `hash` _must_ be the result of a hash operation for the
 verification to be secure: it is possible to craft signatures that
 recover to arbitrary addresses for non-hashed data. A safe way to ensure
 this is by receiving a hash of the original message (which may otherwise
 be too long), and then calling {toEthSignedMessageHash} on it.

```solidity
function recover(bytes32 hash, bytes signature) internal pure
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| signature | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }
```
</details>

### tryRecover

Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
 See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
 _Available since v4.3._

```solidity
function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure
returns(address, enum ECDSA.RecoverError)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| r | bytes32 |  | 
| vs | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }
```
</details>

### recover

Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
 _Available since v4.2._

```solidity
function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| r | bytes32 |  | 
| vs | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }
```
</details>

### tryRecover

Overload of {ECDSA-tryRecover} that receives the `v`,
 `r` and `s` signature fields separately.
 _Available since v4.3._

```solidity
function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure
returns(address, enum ECDSA.RecoverError)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| v | uint8 |  | 
| r | bytes32 |  | 
| s | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

```
</details>

### recover

Overload of {ECDSA-recover} that receives the `v`,
 `r` and `s` signature fields separately.

```solidity
function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 
| v | uint8 |  | 
| r | bytes32 |  | 
| s | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
ction recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

```
</details>

### toEthSignedMessageHash

Returns an Ethereum Signed Message, created from a `hash`. This
 produces hash corresponding to the one signed with the
 https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
 JSON-RPC method as part of EIP-191.
 See {recover}.

```solidity
function toEthSignedMessageHash(bytes32 hash) internal pure
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| hash | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
ction toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

```
</details>

### toEthSignedMessageHash

Returns an Ethereum Signed Message, created from `s`. This
 produces hash corresponding to the one signed with the
 https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
 JSON-RPC method as part of EIP-191.
 See {recover}.

```solidity
function toEthSignedMessageHash(bytes s) internal pure
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| s | bytes |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
ction toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
    }

```
</details>

### toTypedDataHash

Returns an Ethereum Signed Typed Data, created from a
 `domainSeparator` and a `structHash`. This produces hash corresponding
 to the one signed with the
 https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
 JSON-RPC method as part of EIP-712.
 See {recover}.

```solidity
function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| domainSeparator | bytes32 |  | 
| structHash | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
ction toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
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
