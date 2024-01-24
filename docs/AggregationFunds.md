# AggregationFunds.sol

View Source: [\contracts\manage\AggregationFunds.sol](..\contracts\manage\AggregationFunds.sol)

**↗ Extends: [Initializable](Initializable.md), [GuardExtensionUpgradeable](GuardExtensionUpgradeable.md)**

**AggregationFunds**

## Structs
### Limits

```js
struct Limits {
 uint256 min,
 uint256 max
}
```

## Contract Members
**Constants & Variables**

```js
//private members
string private constant SAME_VALUE;
contract IERC20 private _uds;
contract IERC20 private _ugold;
mapping(address => struct AggregationFunds.Limits) private _limits;

//public members
mapping(address => contract IClaimableFunds[]) public claimableContracts;
address payable public coldWallet;
address payable public hotWallet;

```

**Events**

```js
event TransferToHotWallet(address indexed asset, uint256  amount);
event TransferToColdWallet(address indexed asset, uint256  amount);
```

## Modifiers

- [onlySupportedAsset](#onlysupportedasset)
- [walletsDefined](#walletsdefined)

### onlySupportedAsset

only existing asset

```js
modifier onlySupportedAsset(address asset) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset | address |  | 

### walletsDefined

only if destination wallets are defined

```js
modifier walletsDefined() internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

## Functions

- [initialize(address[] claimableEthContracts_, address[] claimableUDSContracts_, address[] claimableUGLDContracts_, address rights_, address uds_, address ugold_)](#initialize)
- [constructor()](#)
- [setclaimableEthContracts(IClaimableFunds[] contracts_)](#setclaimableethcontracts)
- [setclaimableUDSContracts(IClaimableFunds[] contracts_)](#setclaimableudscontracts)
- [setclaimableUGLDContracts(IClaimableFunds[] contracts_)](#setclaimableugldcontracts)
- [setUgold(IERC20 newValue_)](#setugold)
- [setUds(IERC20 newValue_)](#setuds)
- [setHotWallet(address payable newValue_)](#sethotwallet)
- [setColdWallet(address payable newValue_)](#setcoldwallet)
- [setMinMax(address asset_, uint256 min_, uint256 max_)](#setminmax)
- [getMinMax(address asset_)](#getminmax)
- [getAvailableBalance(address asset_)](#getavailablebalance)
- [withdraw()](#withdraw)
- [_calculateDistribution(uint256 currentContractBalance_, uint256 currentHotWalletBalance_, uint256 max_)](#_calculatedistribution)
- [_claimTokens(address asset_)](#_claimtokens)

### initialize

Constructor

```solidity
function initialize(address[] claimableEthContracts_, address[] claimableUDSContracts_, address[] claimableUGLDContracts_, address rights_, address uds_, address ugold_) public nonpayable initializer 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| claimableEthContracts_ | address[] | Contracts that support claim of eth, like mystery box | 
| claimableUDSContracts_ | address[] | Contracts that support claim of uds marketplace, like mystery box | 
| claimableUGLDContracts_ | address[] | Contracts that support claim of ugold | 
| rights_ | address |  | 
| uds_ | address |  | 
| ugold_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function initialize(

        address[] memory claimableEthContracts_,

        address[] memory claimableUDSContracts_,

        address[] memory claimableUGLDContracts_,

        address rights_,

        address uds_,

        address ugold_

    ) public initializer {

        __GuardExtensionUpgradeable_init(rights_);

        uint256 index = 0;

        for (; index < claimableEthContracts_.length; ) {

            claimableContracts[address(0x0)].push(

                IClaimableFunds(claimableEthContracts_[index])

            );

            unchecked {

                index++;

            }

        }

        index = 0;

        for (; index < claimableUDSContracts_.length; ) {

            claimableContracts[uds_].push(

                IClaimableFunds(claimableUDSContracts_[index])

            );

            unchecked {

                index++;

            }

        }

        index = 0;

        for (; index < claimableUGLDContracts_.length; ) {

            claimableContracts[ugold_].push(

                IClaimableFunds(claimableUGLDContracts_[index])

            );

            unchecked {

                index++;

            }

        }

        _uds = IERC20(uds_);

        _ugold = IERC20(ugold_);

    }
```
</details>

### 

```solidity
function () external payable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
receive() external payable {}
```
</details>

### setclaimableEthContracts

Set addresses that support claim eth interface

```solidity
function setclaimableEthContracts(IClaimableFunds[] contracts_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contracts_ | IClaimableFunds[] | New addresses | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setclaimableEthContracts(IClaimableFunds[] calldata contracts_)

        external

        haveRights

    {

        claimableContracts[address(0x0)] = contracts_;

    }
```
</details>

### setclaimableUDSContracts

Set addresses that support claim ERC20 interface

```solidity
function setclaimableUDSContracts(IClaimableFunds[] contracts_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contracts_ | IClaimableFunds[] | New addresses | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setclaimableUDSContracts(IClaimableFunds[] calldata contracts_)

        external

        haveRights

    {

        claimableContracts[address(_uds)] = contracts_;

    }
```
</details>

### setclaimableUGLDContracts

Set addresses that support claim ERC20 interface

```solidity
function setclaimableUGLDContracts(IClaimableFunds[] contracts_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| contracts_ | IClaimableFunds[] | New addresses | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setclaimableUGLDContracts(IClaimableFunds[] calldata contracts_)

        external

        haveRights

    {

        claimableContracts[address(_ugold)] = contracts_;

    }
```
</details>

### setUgold

Set the mystery box contract address

```solidity
function setUgold(IERC20 newValue_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newValue_ | IERC20 | address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setUgold(IERC20 newValue_) external haveRights {

        _ugold = newValue_;

    }
```
</details>

### setUds

Set the mystery box contract address

```solidity
function setUds(IERC20 newValue_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newValue_ | IERC20 | New address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setUds(IERC20 newValue_) external haveRights {

        _uds = newValue_;

    }
```
</details>

### setHotWallet

Set hot wallet address

```solidity
function setHotWallet(address payable newValue_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newValue_ | address payable | New address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setHotWallet(address payable newValue_) external haveRights {

        require(hotWallet != newValue_, SAME_VALUE);

        hotWallet = newValue_;

    }
```
</details>

### setColdWallet

Set cold wallet address

```solidity
function setColdWallet(address payable newValue_) external nonpayable haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| newValue_ | address payable | New address | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setColdWallet(address payable newValue_) external haveRights {

        require(coldWallet != newValue_, SAME_VALUE);

        coldWallet = newValue_;

    }
```
</details>

### setMinMax

Change minimum and maximum values for specific token to be stored on hot wallet to cover tx fees

```solidity
function setMinMax(address asset_, uint256 min_, uint256 max_) external nonpayable haveRights onlySupportedAsset 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset_ | address | Address of token contrac, if addres is zero -> eth | 
| min_ | uint256 | Min critical value of the asset that should be stored on the hot wallet | 
| max_ | uint256 | Amoun of assets have to be sotored on hot wallet | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function setMinMax(

        address asset_,

        uint256 min_,

        uint256 max_

    ) external haveRights onlySupportedAsset(asset_) {

        Limits storage limit = _limits[asset_];

        limit.min = min_;

        limit.max = max_;

    }
```
</details>

### getMinMax

Get minimum and maximum values for specific token that will be stored on hot wallet to cover tx fees

```solidity
function getMinMax(address asset_) external view onlySupportedAsset 
returns(min uint256, max uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset_ | address | Address of token contrac, if addres is zero -> eth | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getMinMax(address asset_)

        external

        view

        onlySupportedAsset(asset_)

        returns (uint256 min, uint256 max)

    {

        Limits storage limit = _limits[asset_];

        min = limit.min;

        max = limit.max;

    }
```
</details>

### getAvailableBalance

Get the balance of the assetes available to claim

```solidity
function getAvailableBalance(address asset_) external view onlySupportedAsset 
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset_ | address | to get balance of eth, pass zero (0x0) address | 

**Returns**

The balance

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function getAvailableBalance(address asset_)

        external

        view

        onlySupportedAsset(asset_)

        returns (uint256)

    {

        uint256 balance = 0;

        IClaimableFunds[] memory contracts = claimableContracts[asset_];

        for (uint256 index = 0; index < contracts.length; ) {

            unchecked {

                balance += contracts[index].availableToClaim(

                    address(this),

                    asset_

                );

                index++;

            }

        }

        return balance;

    }
```
</details>

### withdraw

Claim and destribute funds between hot/cold wallets

```solidity
function withdraw() external nonpayable walletsDefined 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function withdraw() external walletsDefined {

        _claimTokens(address(0x0));

        _claimTokens(address(_ugold));

        _claimTokens(address(_uds));

        // ETH

        uint256 contractBalance = address(this).balance;

        uint256 hotWalletBalance = hotWallet.balance;

        uint256 max = _limits[address(0x0)].max;

        if (contractBalance > 0) {

            (

                uint256 toHotWallet,

                uint256 toColdWallet

            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);

            if (toHotWallet > 0) {

                hotWallet.sendValue(toHotWallet);

                emit TransferToHotWallet(address(0x0), toHotWallet);

            }

            if (toColdWallet > 0) {

                coldWallet.sendValue(toColdWallet);

                emit TransferToColdWallet(address(0x0), toColdWallet);

            }

        }

        // UGOLD

        contractBalance = _ugold.balanceOf(address(this));

        if (contractBalance > 0) {

            hotWalletBalance = _ugold.balanceOf(address(hotWallet));

            max = _limits[address(_ugold)].max;

            (

                uint256 toHotWallet,

                uint256 toColdWallet

            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);

            if (toHotWallet > 0) {

                _ugold.transfer(address(hotWallet), toHotWallet);

                emit TransferToHotWallet(address(_ugold), toHotWallet);

            }

            if (toColdWallet > 0) {

                _ugold.transfer(address(coldWallet), toColdWallet);

                emit TransferToColdWallet(address(_ugold), toColdWallet);

            }

        }

        // UDS

        contractBalance = _uds.balanceOf(address(this));

        if (contractBalance > 0) {

            hotWalletBalance = _uds.balanceOf(address(hotWallet));

            max = _limits[address(_uds)].max;

            (

                uint256 toHotWallet,

                uint256 toColdWallet

            ) = _calculateDistribution(contractBalance, hotWalletBalance, max);

            if (toHotWallet > 0) {

                _uds.transfer(address(hotWallet), toHotWallet);

                emit TransferToHotWallet(address(_uds), toHotWallet);

            }

            if (toColdWallet > 0) {

                _uds.transfer(address(coldWallet), toColdWallet);

                emit TransferToColdWallet(address(_uds), toColdWallet);

            }

        }

    }
```
</details>

### _calculateDistribution

Calculate funds вistribution

```solidity
function _calculateDistribution(uint256 currentContractBalance_, uint256 currentHotWalletBalance_, uint256 max_) private pure
returns(toHotWallet uint256, toColdWallet uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| currentContractBalance_ | uint256 |  | 
| currentHotWalletBalance_ | uint256 |  | 
| max_ | uint256 |  | 

**Returns**

toHotWallet - amont to send to hotWallet,

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
unction _calculateDistribution(

        uint256 currentContractBalance_,

        uint256 currentHotWalletBalance_,

        uint256 max_

    ) private pure returns (uint256 toHotWallet, uint256 toColdWallet) {

        if (

            currentHotWalletBalance_ < max_ &&

            currentHotWalletBalance_ + currentContractBalance_ > max_

        ) {

            toHotWallet = max_ - currentHotWalletBalance_;

            toColdWallet = currentContractBalance_ - toHotWallet;

        } else if (currentHotWalletBalance_ == max_) {

            toHotWallet = 0;

            toColdWallet = currentContractBalance_;

        } else {

            toHotWallet = currentContractBalance_;

            toColdWallet = 0;

        }

    }

```
</details>

### _claimTokens

Claim claim tokens to aggregation funds contract

```solidity
function _claimTokens(address asset_) private nonpayable
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
unction _claimTokens(address asset_) private {

        IClaimableFunds[] memory contracts = claimableContracts[asset_];

        for (uint256 index = 0; index < contracts.length; ) {

            uint256 amount = contracts[index].availableToClaim(

                address(this),

                asset_

            );

            if (amount > 0) {

                contracts[index].claimFunds(

                    asset_,

                    payable(address(this)),

                    amount

                );

            }

            unchecked {

                index++;

            }

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
