# Initializable.sol

View Source: [@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol](..\@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol)

**↘ Derived Contracts: [AccessControlEnumerableUpgradeable](AccessControlEnumerableUpgradeable.md), [AccessControlUpgradeable](AccessControlUpgradeable.md), [AggregationFunds](AggregationFunds.md), [ContextUpgradeable](ContextUpgradeable.md), [ERC165Upgradeable](ERC165Upgradeable.md), [GuardExtensionUpgradeable](GuardExtensionUpgradeable.md), [OwnableUpgradeable](OwnableUpgradeable.md), [ReentrancyGuardUpgradeable](ReentrancyGuardUpgradeable.md)**

**Initializable**

This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 case an upgrade adds a module that needs to be initialized.
 For example:
 [.hljs-theme-light.nopadding]
 ```
 contract MyToken is ERC20Upgradeable {
     function initialize() initializer public {
         __ERC20_init("MyToken", "MTK");
     }
 }
 contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
     function initializeV2() reinitializer(2) public {
         __ERC20Permit_init("MyToken");
     }
 }
 ```
 TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 [CAUTION]
 ====
 Avoid leaving a contract uninitialized.
 An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 [.hljs-theme-light.nopadding]
 ```
 ///

## Contract Members
**Constants & Variables**

```js
uint8 private _initialized;
bool private _initializing;

```

**Events**

```js
event Initialized(uint8  version);
```

## Modifiers

- [initializer](#initializer)
- [reinitializer](#reinitializer)
- [onlyInitializing](#onlyinitializing)

### initializer

A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
 `onlyInitializing` functions can be used to initialize parent contracts.
 Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
 constructor.
 Emits an {Initialized} event.

```js
modifier initializer() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### reinitializer

A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
 contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
 used to initialize parent contracts.
 A reinitializer may be used after the original initialization step. This is essential to configure modules that
 are added through upgrades and that require initialization.
 When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
 cannot be nested. If one is invoked in the context of another, execution will revert.
 Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
 a contract, executing them in the right order is up to the developer or operator.
 WARNING: setting the version to 255 will prevent any future reinitialization.
 Emits an {Initialized} event.

```js
modifier reinitializer(uint8 version) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| version | uint8 |  | 

### onlyInitializing

Modifier to protect an initialization function so that it can only be invoked by functions with the
 {initializer} and {reinitializer} modifiers, directly or indirectly.

```js
modifier onlyInitializing() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [_disableInitializers()](#_disableinitializers)
- [_getInitializedVersion()](#_getinitializedversion)
- [_isInitializing()](#_isinitializing)

### _disableInitializers

Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
 Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
 to any version. It is recommended to use this to lock implementation contracts that are designed to be called
 through proxies.
 Emits an {Initialized} event the first time it is successfully executed.

```solidity
function _disableInitializers() internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized < type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }
```
</details>

### _getInitializedVersion

Returns the highest version that has been initialized. See {reinitializer}.

```solidity
function _getInitializedVersion() internal view
returns(uint8)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }
```
</details>

### _isInitializing

Returns `true` if the contract is currently initializing. See {onlyInitializing}.

```solidity
function _isInitializing() internal view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _isInitializing() internal view returns (bool) {
        return _initializing;
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
