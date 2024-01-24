# AccessControl.sol

View Source: [@openzeppelin\contracts\access\AccessControl.sol](..\@openzeppelin\contracts\access\AccessControl.sol)

**↗ Extends: [Context](Context.md), [IAccessControl](IAccessControl.md), [ERC165](ERC165.md)**
**↘ Derived Contracts: [Management](Management.md), [Rights](Rights.md)**

**AccessControl**

Contract module that allows children to implement role-based access
 control mechanisms. This is a lightweight version that doesn't allow enumerating role
 members except through off-chain means by accessing the contract event logs. Some
 applications may benefit from on-chain enumerability, for those cases see
 {AccessControlEnumerable}.
 Roles are referred to by their `bytes32` identifier. These should be exposed
 in the external API and be unique. The best way to achieve this is by
 using `public constant` hash digests:
 ```
 bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 ```
 Roles can be used to represent a set of permissions. To restrict access to a
 function call, use {hasRole}:
 ```
 function foo() public {
     require(hasRole(MY_ROLE, msg.sender));
     ...
 }
 ```
 Roles can be granted and revoked dynamically via the {grantRole} and
 {revokeRole} functions. Each role has an associated admin role, and only
 accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 that only accounts with this role will be able to grant or revoke other
 roles. More complex role relationships can be created by using
 {_setRoleAdmin}.
 WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 grant and revoke this role. Extra precautions should be taken to secure
 accounts that have been granted it.

## Structs
### RoleData

```js
struct RoleData {
 mapping(address => bool) members,
 bytes32 adminRole
}
```

## Contract Members
**Constants & Variables**

```js
//private members
mapping(bytes32 => struct AccessControl.RoleData) private _roles;

//public members
bytes32 public constant DEFAULT_ADMIN_ROLE;

```

## Modifiers

- [onlyRole](#onlyrole)

### onlyRole

Modifier that checks that an account has a specific role. Reverts
 with a standardized message including the required role.
 The format of the revert reason is given by the following regular expression:
  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
 _Available since v4.1._

```js
modifier onlyRole(bytes32 role) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 

## Functions

- [supportsInterface(bytes4 interfaceId)](#supportsinterface)
- [hasRole(bytes32 role, address account)](#hasrole)
- [_checkRole(bytes32 role)](#_checkrole)
- [_checkRole(bytes32 role, address account)](#_checkrole)
- [getRoleAdmin(bytes32 role)](#getroleadmin)
- [grantRole(bytes32 role, address account)](#grantrole)
- [revokeRole(bytes32 role, address account)](#revokerole)
- [renounceRole(bytes32 role, address account)](#renouncerole)
- [_setupRole(bytes32 role, address account)](#_setuprole)
- [_setRoleAdmin(bytes32 role, bytes32 adminRole)](#_setroleadmin)
- [_grantRole(bytes32 role, address account)](#_grantrole)
- [_revokeRole(bytes32 role, address account)](#_revokerole)

### supportsInterface

See {IERC165-supportsInterface}.

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
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }
```
</details>

### hasRole

Returns `true` if `account` has been granted `role`.

```solidity
function hasRole(bytes32 role, address account) public view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }
```
</details>

### _checkRole

Revert with a standard message if `_msgSender()` is missing `role`.
 Overriding this function changes the behavior of the {onlyRole} modifier.
 Format of the revert message is described in {_checkRole}.
 _Available since v4.6._

```solidity
function _checkRole(bytes32 role) internal view
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }
```
</details>

### _checkRole

Revert with a standard message if `account` is missing `role`.
 The format of the revert reason is given by the following regular expression:
  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/

```solidity
function _checkRole(bytes32 role, address account) internal view
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(account),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }
```
</details>

### getRoleAdmin

Returns the admin role that controls `role`. See {grantRole} and
 {revokeRole}.
 To change a role's admin, use {_setRoleAdmin}.

```solidity
function getRoleAdmin(bytes32 role) public view
returns(bytes32)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }
```
</details>

### grantRole

Grants `role` to `account`.
 If `account` had not been already granted `role`, emits a {RoleGranted}
 event.
 Requirements:
 - the caller must have ``role``'s admin role.
 May emit a {RoleGranted} event.

```solidity
function grantRole(bytes32 role, address account) public nonpayable onlyRole 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }
```
</details>

### revokeRole

Revokes `role` from `account`.
 If `account` had been granted `role`, emits a {RoleRevoked} event.
 Requirements:
 - the caller must have ``role``'s admin role.
 May emit a {RoleRevoked} event.

```solidity
function revokeRole(bytes32 role, address account) public nonpayable onlyRole 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }
```
</details>

### renounceRole

Revokes `role` from the calling account.
 Roles are often managed via {grantRole} and {revokeRole}: this function's
 purpose is to provide a mechanism for accounts to lose their privileges
 if they are compromised (such as when a trusted device is misplaced).
 If the calling account had been revoked `role`, emits a {RoleRevoked}
 event.
 Requirements:
 - the caller must be `account`.
 May emit a {RoleRevoked} event.

```solidity
function renounceRole(bytes32 role, address account) public nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }
```
</details>

### _setupRole

Grants `role` to `account`.
 If `account` had not been already granted `role`, emits a {RoleGranted}
 event. Note that unlike {grantRole}, this function doesn't perform any
 checks on the calling account.
 May emit a {RoleGranted} event.
 [WARNING]
 ====
 This function should only be called from the constructor when setting
 up the initial roles for the system.
 Using this function in any other way is effectively circumventing the admin
 system imposed by {AccessControl}.
 ====
 NOTE: This function is deprecated in favor of {_grantRole}.

```solidity
function _setupRole(bytes32 role, address account) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }
```
</details>

### _setRoleAdmin

Sets `adminRole` as ``role``'s admin role.
 Emits a {RoleAdminChanged} event.

```solidity
function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| adminRole | bytes32 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }
```
</details>

### _grantRole

Grants `role` to `account`.
 Internal function without access restriction.
 May emit a {RoleGranted} event.

```solidity
function _grantRole(bytes32 role, address account) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }
```
</details>

### _revokeRole

Revokes `role` from `account`.
 Internal function without access restriction.
 May emit a {RoleRevoked} event.

```solidity
function _revokeRole(bytes32 role, address account) internal nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| role | bytes32 |  | 
| account | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
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
