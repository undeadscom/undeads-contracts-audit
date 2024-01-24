# A financial management contract (Management.sol)

View Source: [\contracts\manage\Management.sol](..\contracts\manage\Management.sol)

**↗ Extends: [IManagement](IManagement.md), [AccessControl](AccessControl.md), [Voting](Voting.md)**

**Management**

This contract manage any functions of other contracts using call, and manage local
 properties using built-in functions.
 It support 3 different administrator addresses and any nulber of manager addresses.
 Managers can add only third-party call requests, admins can add and sign any requests
 and sign already added requests with majoritary (2 of 3) logic.
 Each third-party call have limited time for confirmation, local calls have no limitation.

## Structs
### ManageAction

```js
struct ManageAction {
 address target,
 address author,
 uint256 expiration,
 bytes4 signature,
 bytes data,
 bool executed
}
```

## Contract Members
**Constants & Variables**

```js
//private members
struct Counters.Counter private _actionIndex;
contract IERC20 private _token;
address private _initialOwner;
address private _remainsAddress;
string private constant BIG_INDEX;
string private constant SEALED;
string private constant NOT_SEALED;
string private constant NOT_ADMIN;
string private constant PROTECTED;
string private constant NOT_TRUSTED;
string private constant DUP_ADMINS;
string private constant ALL_SET;
string private constant DUP_VOTE;
string private constant SET;
string private constant NOT_ALL;
string private constant ZERO_ADDRESS;
string private constant STRANGE;
string private constant TOO_LATE;
string private constant EXISTING_ADMIN;
string private constant DUP_OFFER;
string private constant EXECUTED;
string private constant FAILED;
string private constant DURATION_NOT_RIGHT;
uint256 private constant ONE_DAY_IN_SECONDS;
uint256 private constant THREE_MONTHS_IN_SECONDS;
address[3] private _admins;
struct EnumerableSet.AddressSet private _managers;
struct EnumerableMap.AddressToUintMap private _promilles;
mapping(uint256 => struct Management.ManageAction) private _actions;
uint256 private _duration;
bool private _sealed;
address private _newAdmin;
address private _newAdminProposer;

//public members
bytes32 public constant ADMIN_ROLE;
bytes32 public constant MANAGER_ROLE;
bytes32 public constant TOKEN;
bytes32 public constant DURATION;
bytes32 public constant TARGET;

```

## Modifiers

- [notSealed](#notsealed)
- [isSealed](#issealed)
- [onlyAdmin](#onlyadmin)
- [protected](#protected)
- [onlyAdminOrManager](#onlyadminormanager)
- [onlyDurationRight](#onlydurationright)

### notSealed

only if contract is not sealed (protected from the "rug pull")

```js
modifier notSealed() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### isSealed

only if contract is sealed (protected from the "rug pull")

```js
modifier isSealed() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### onlyAdmin

only if one of the admins calls

```js
modifier onlyAdmin() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### protected

only if admin called or contract is not sealed and owner called

```js
modifier protected() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### onlyAdminOrManager

only if manager or admin called

```js
modifier onlyAdminOrManager() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

### onlyDurationRight

only if duration has right bounds

```js
modifier onlyDurationRight(uint256 duration) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| duration | uint256 |  | 

## Functions

- [constructor(uint256 duration_, address token_, address remainsAddress_)](#)
- [addAdmin(address newAdmin)](#addadmin)
- [admins()](#admins)
- [duration()](#duration)
- [setDuration(uint256 duration_)](#setduration)
- [token()](#token)
- [setToken(address token_)](#settoken)
- [target()](#target)
- [setTarget(address target_)](#settarget)
- [seal()](#seal)
- [changeAdmin(address newAdmin)](#changeadmin)
- [actionsLength()](#actionslength)
- [getAction(uint256 index)](#getaction)
- [addManager(address manager)](#addmanager)
- [removeManager(address manager)](#removemanager)
- [managers()](#managers)
- [addAction(address target_, bytes4 signature, bytes data)](#addaction)
- [executeAction(uint256 index)](#executeaction)

### 

constructor

```solidity
function (uint256 duration_, address token_, address remainsAddress_) public nonpayable onlyDurationRight 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| duration_ | uint256 | The lifetime of third-party call in seconds | 
| token_ | address | The address of the token distributed | 
| remainsAddress_ | address | The address of the wallet receiving non-distributed tokens amount | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(

        uint256 duration_,

        address token_,

        address remainsAddress_

    ) onlyDurationRight(duration_) {

        _initialOwner = msg.sender;

        _duration = duration_;

        require(token_ != address(0), ZERO_ADDRESS);

        require(remainsAddress_ != address(0), ZERO_ADDRESS);

        _token = IERC20(token_);

        _remainsAddress = remainsAddress_;

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        _setRoleAdmin(MANAGER_ROLE, ADMIN_ROLE);

    }
```
</details>

### addAdmin

Add a new admin from the owner's side (only while contract is not sealed)

```solidity
function addAdmin(address newAdmin) external nonpayable onlyRole notSealed 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newAdmin | address | New admin address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addAdmin(address newAdmin)

        external

        onlyRole(DEFAULT_ADMIN_ROLE)

        notSealed

    {

        require(newAdmin != address(0), ZERO_ADDRESS);

        for (uint256 i = 0; i < 3; ++i) {

            require(_admins[i] != newAdmin, DUP_ADMINS);

            if (_admins[i] == address(0)) {

                _admins[i] = newAdmin;

                grantRole(ADMIN_ROLE, newAdmin);

                emit AdminAdded(newAdmin);

                return;

            }

        }

        require(false, ALL_SET);

    }
```
</details>

### admins

The list of the admins. Can be called only by admin

```solidity
function admins() external view onlyAdmin 
returns(address[3])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function admins() external view onlyAdmin returns (address[3] memory) {

        return _admins;

    }
```
</details>

### duration

Get the lifetime of the third-party call

```solidity
function duration() external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function duration() external view returns (uint256) {

        return _duration;

    }
```
</details>

### setDuration

Set the lifetime of the third-party call

```solidity
function setDuration(uint256 duration_) external nonpayable protected onlyDurationRight 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| duration_ | uint256 | The lifetime of third-party call in seconds | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setDuration(uint256 duration_) external protected onlyDurationRight(duration_) {

        if (!_sealed) {

            _duration = duration_;

            emit DurationChanged(msg.sender, duration_);

            return;

        }

        require(!hasVote(DURATION, msg.sender), DUP_VOTE);

        bytes32 encoded = keccak256(abi.encode(duration_));

        if (!isVoteExists(DURATION)) {

            _openVote(DURATION, 2, encoded);

            emit DurationChangeRequest(msg.sender, duration_);

        }

        _vote(DURATION, encoded);

        if (isVoteResolved(DURATION)) {

            _duration = duration_;

            _closeVote(DURATION);

            emit DurationChanged(msg.sender, duration_);

        }

    }
```
</details>

### token

Get the current token address

```solidity
function token() external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function token() external view returns (address) {

        return address(_token);

    }
```
</details>

### setToken

Set the address of the distributed token

```solidity
function setToken(address token_) external nonpayable protected 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| token_ | address | The address of the token distributed | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setToken(address token_) external protected {

        if (!_sealed) {

            _token = IERC20(token_);

            emit TokenChanged(msg.sender, token_);

            return;

        }

        require(!hasVote(TOKEN, msg.sender), DUP_VOTE);

        bytes32 encodedToken = keccak256(abi.encode(token_));

        if (!isVoteExists(TOKEN)) {

            _openVote(TOKEN, 2, encodedToken);

            emit TokenChangeRequest(msg.sender, token_);

        }

        _vote(TOKEN, encodedToken);

        if (isVoteResolved(TOKEN)) {

            _token = IERC20(token_);

            _closeVote(TOKEN);

            emit TokenChanged(msg.sender, token_);

        }

    }
```
</details>

### target

Get the address where non-distributed tokens should go

```solidity
function target() external view
returns(address)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function target() external view returns (address) {

        return _remainsAddress;

    }
```
</details>

### setTarget

Set the address where non-distributed tokens should go

```solidity
function setTarget(address target_) external nonpayable protected 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | The address of the token distributed | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setTarget(address target_) external protected {

        require(target_ != address(0), ZERO_ADDRESS);

        if (!_sealed) {

            _remainsAddress = target_;

            emit TargetChanged(msg.sender, target_);

            return;

        }

        require(!hasVote(TARGET, msg.sender), DUP_VOTE);

        bytes32 encodedTarget = keccak256(abi.encode(target_));

        if (!isVoteExists(TARGET)) {

            _openVote(TARGET, 2, encodedTarget);

            emit TargetChangeRequest(msg.sender, target_);

        }

        _vote(TARGET, encodedTarget);

        if (isVoteResolved(TARGET)) {

            _remainsAddress = target_;

            _closeVote(TARGET);

            emit TargetChanged(msg.sender, target_);

        }

    }
```
</details>

### seal

Seal the contract (will not be accessible by owner)

```solidity
function seal() external nonpayable onlyRole notSealed 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function seal() external onlyRole(DEFAULT_ADMIN_ROLE) notSealed {

        for (uint256 i = 0; i < 3; ++i) {

            require(_admins[i] != address(0), NOT_ALL);

        }

        _sealed = true;

        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);

        renounceRole(DEFAULT_ADMIN_ROLE, _initialOwner);

    }
```
</details>

### changeAdmin

Set the new admin instead of the one old (with voting)
If two of the different admins offers the same address, the third of
the admins will be changed to the new address. Any admin offering a
new address starting the voting procedure again.

```solidity
function changeAdmin(address newAdmin) external nonpayable onlyAdmin isSealed 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newAdmin | address | The address of the admin wallet | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function changeAdmin(address newAdmin) external onlyAdmin isSealed {

        require(newAdmin != address(0), ZERO_ADDRESS);

        require(!hasRole(ADMIN_ROLE, newAdmin), EXISTING_ADMIN);

        require(

            newAdmin != _newAdmin || _newAdminProposer != msg.sender,

            DUP_OFFER

        );

        if (newAdmin != _newAdmin) {

            _newAdmin = newAdmin;

            _newAdminProposer = msg.sender;

            emit AdminChangePending(msg.sender, newAdmin);

            return;

        }

        for (uint256 i = 0; i < 3; ++i) {

            if (_admins[i] != _newAdminProposer && _admins[i] != msg.sender) {

                address oldAdmin = _admins[i];

                _admins[i] = newAdmin;

                _newAdmin = address(0);

                revokeRole(ADMIN_ROLE, oldAdmin);

                grantRole(ADMIN_ROLE, newAdmin);

                emit AdminChanged(msg.sender, oldAdmin, newAdmin);

                return;

            }

        }

        require(false, STRANGE);

    }
```
</details>

### actionsLength

Get the amount of the actions

```solidity
function actionsLength() public view isSealed 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function actionsLength() public view isSealed returns (uint256) {

        return _actionIndex.current();

    }
```
</details>

### getAction

Get the action

```solidity
function getAction(uint256 index) public view isSealed 
returns(struct Management.ManageAction)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 | The id of the action | 

**Returns**

The action data

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getAction(uint256 index)

        public

        view

        isSealed

        returns (ManageAction memory)

    {

        require(index < _actionIndex.current(), BIG_INDEX);

        return _actions[index];

    }
```
</details>

### addManager

Add the new manager by owner

```solidity
function addManager(address manager) external nonpayable onlyRole 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| manager | address | The address of the manager | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addManager(address manager) external onlyRole(DEFAULT_ADMIN_ROLE) {

        require(manager != address(0), ZERO_ADDRESS);

        grantRole(MANAGER_ROLE, manager);

        _managers.add(manager);

        emit ManagerAdded(manager);

    }
```
</details>

### removeManager

Remove the manager by owner

```solidity
function removeManager(address manager) external nonpayable onlyRole 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| manager | address | The address of the manager | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function removeManager(address manager)

        external

        onlyRole(DEFAULT_ADMIN_ROLE)

    {

        require(manager != address(0), ZERO_ADDRESS);

        revokeRole(MANAGER_ROLE, manager);

        _managers.remove(manager);

        emit ManagerRemoved(manager);

    }
```
</details>

### managers

List of managers

```solidity
function managers() external view onlyRole 
returns(address[])
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function managers()

        external

        view

        onlyRole(DEFAULT_ADMIN_ROLE)

        returns (address[] memory)

    {

        return _managers.values();

    }
```
</details>

### addAction

Add the action. It can be called by manager (with no vote) or admin (with vote)

```solidity
function addAction(address target_, bytes4 signature, bytes data) external nonpayable isSealed onlyAdminOrManager 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| target_ | address | The address of the calling contract | 
| signature | bytes4 | The signature (keccak256(abi.bytesEncoded(function name, parameters))) | 
| data | bytes | The abi.bytesEncoded(data) | 

**Returns**

The id of the new action

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addAction(

        address target_,

        bytes4 signature,

        bytes memory data

    ) external isSealed onlyAdminOrManager returns (uint256) {

        address author = address(0);

        if (hasRole(ADMIN_ROLE, msg.sender)) {

            author = msg.sender;

        }

        require(author != address(0), ZERO_ADDRESS);

        uint256 current = _actionIndex.current();

        _actions[current] = ManageAction({

            target: target_,

            signature: signature,

            data: data,

            author: author,

            executed: false,

            expiration: _duration + block.timestamp

        });

        emit ActionAdded(current, msg.sender, target_, signature);

        if (hasRole(ADMIN_ROLE, msg.sender)) {

            emit ActionSigned(current, msg.sender);

        }

        _actionIndex.increment();

        return current;

    }
```
</details>

### executeAction

Voting and execution of the action (if votes enough)

```solidity
function executeAction(uint256 index) external nonpayable isSealed onlyAdmin 
returns(bytes)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| index | uint256 | The id of the action | 

**Returns**

The result of the call

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function executeAction(uint256 index)

        external

        isSealed

        onlyAdmin

        returns (bytes memory)

    {

        require(index < _actionIndex.current(), BIG_INDEX);

        require(_actions[index].expiration >= block.timestamp, TOO_LATE);

        require(!_actions[index].executed, EXECUTED);

        require(_actions[index].author != msg.sender, DUP_ADMINS);

        if (_actions[index].author == address(0)) {

            _actions[index].author = msg.sender;

            emit ActionSigned(index, msg.sender);

            return "";

        }

        (bool success, bytes memory data) = _actions[index].target.call(

            abi.encodePacked(_actions[index].signature, _actions[index].data)

        );

        require(success, FAILED);

        _actions[index].executed = success;

        emit ActionExecuted(index, msg.sender);

        return data;

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
