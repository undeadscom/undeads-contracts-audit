# MarketplaceTreasury.sol

View Source: [\contracts\marketplace\MarketplaceTreasury.sol](..\contracts\marketplace\MarketplaceTreasury.sol)

**↗ Extends: [IMarketplaceTreasury](IMarketplaceTreasury.md), [ReentrancyGuard](ReentrancyGuard.md), [GuardExtension](GuardExtension.md)**

**MarketplaceTreasury**

## Structs
### PaymentAsset

```js
struct PaymentAsset {
 uint256 price,
 address paymentAsset
}
```

## Contract Members
**Constants & Variables**

```js
mapping(address => mapping(address => uint256)) private _balances;
mapping(address => bool) private _approvedPayments;

```

## Modifiers

- [onlyAllowedPayment](#onlyallowedpayment)

### onlyAllowedPayment

```js
modifier onlyAllowedPayment(address paymentAsset_) internal
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| paymentAsset_ | address |  | 

## Functions

- [constructor(address rights_)](#)
- [addFunds(address paymentAsset_, address beneficiar_, uint256 amount_)](#addfunds)
- [approvePayment(address paymantAddress_, bool enabled_)](#approvepayment)
- [availableToClaim(address owner_, address asset_)](#availabletoclaim)
- [claimFunds(address asset_, address payable target_, uint256 amount_)](#claimfunds)
- [isPaymentAssetApproved(address paymentAsset_)](#ispaymentassetapproved)

### 

Constructor

```solidity
function (address rights_) public nonpayable GuardExtension 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| rights_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
constructor(address rights_) GuardExtension(rights_) {}
```
</details>

### addFunds

```solidity
function addFunds(address paymentAsset_, address beneficiar_, uint256 amount_) external nonpayable haveRights onlyAllowedPayment 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| paymentAsset_ | address |  | 
| beneficiar_ | address |  | 
| amount_ | uint256 |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function addFunds(

        address paymentAsset_,

        address beneficiar_,

        uint256 amount_

    ) external haveRights onlyAllowedPayment(paymentAsset_) {

        _balances[beneficiar_][paymentAsset_] += amount_;

    }
```
</details>

### approvePayment

```solidity
function approvePayment(address paymantAddress_, bool enabled_) external nonpayable nonReentrant haveRights 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| paymantAddress_ | address |  | 
| enabled_ | bool |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function approvePayment(

        address paymantAddress_,

        bool enabled_

    ) external nonReentrant haveRights {

        require(

            paymantAddress_ == address(0x0) ||

                IERC20(paymantAddress_).totalSupply() > 0,

            "Not valid paymentMethod"

        );

        _approvedPayments[paymantAddress_] = enabled_;

    }
```
</details>

### availableToClaim

Returns the amount of funds available to claim

```solidity
function availableToClaim(address owner_, address asset_) external view
returns(uint256)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| owner_ | address |  | 
| asset_ | address | Asset to check balance, 0x0 - is native coin (eth) | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function availableToClaim(

        address owner_,

        address asset_

    ) external view returns (uint256) {

        return _balances[owner_][asset_];

    }
```
</details>

### claimFunds

Claim funds

```solidity
function claimFunds(address asset_, address payable target_, uint256 amount_) external nonpayable nonReentrant 
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| asset_ | address | Asset to withdraw, 0x0 - is native coin (eth) | 
| target_ | address payable | The target for the withdrawal | 
| amount_ | uint256 | Amount of tokens to withdraw | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function claimFunds(

        address asset_,

        address payable target_,

        uint256 amount_

    ) external nonReentrant {

        uint256 balance = _balances[msg.sender][asset_];

        require(balance > 0, "Zero balance");

        require(balance >= amount_, "Not enought balance");

        _balances[msg.sender][asset_] = _balances[msg.sender][asset_] - amount_;

        if (asset_ == address(0x0)) {

            (bool success, ) = payable(target_).call{value: amount_}("");

            require(success, "Transfer failed");

        } else {

            bool success = IERC20(asset_).transfer(msg.sender, amount_);

            require(success, "Transfer failed");

        }

    }
```
</details>

### isPaymentAssetApproved

```solidity
function isPaymentAssetApproved(address paymentAsset_) external view
returns(bool)
```

**Arguments**

| Name        | Type           | Description  |
| ------------- |------------- | -----|
| paymentAsset_ | address |  | 

<details>
	<summary><strong>Source Code</strong></summary>

```javascript
function isPaymentAssetApproved(

        address paymentAsset_

    ) external view returns (bool) {

        return _approvedPayments[paymentAsset_];

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
