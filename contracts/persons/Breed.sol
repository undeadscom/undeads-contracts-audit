// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "../utils/Guard.sol";
import "./interfaces/IBreed.sol";
import "./interfaces/IActors.sol";
import "../utils/interfaces/IRandaoRandomizer.sol";
import "../upgradeable/utils/GuardExtensionUpgradeable.sol";

/**
@title Breed
@notice The contract is used for the breeding of the zombies
*/
contract Breed is IBreed, GuardExtensionUpgradeable {
    using BitMaps for BitMaps.BitMap;

    IActors private _zombie;
    IRandaoRandomizer private _random;
    IERC20 private _asset;
    address private _feeAddress;
    uint16 private _deviationDownPromille;
    uint16 private _deviationUpPromille;
    uint16 private _propertyLimit;
    uint256 private _serviceFee;
    uint256 private _growPeriod;
    uint256 private _growPrice; // price per day
    uint256 private _counter;

    BitMaps.BitMap private _completedBreedings;
    BitMaps.BitMap private _completedSessions;
    mapping(bytes32 => bool) private _canceledSignatures;

    uint16 private constant MINIMAL_PROPERTY_VALUE = 800;
    string private constant TOO_YOUNG = "Breeding: too young";
    string private constant INVALID_SIGNATURE = "Breeding: Invalid signature";
    string private constant DEAL_EXPIRED = "Breeding: Deal expired";
    string private constant WRONG_OWNER = "Breeding: Wrong owner of the zombie";
    string private constant BREEDING_ALREADY_COMPLETED = "Breeding: Breeding already completed";
    string private constant SESSION_ALREADY_COMPLETED = "Breeding: Breeding session already completed";
    string private constant ONLY_IMMACULATE = "Breeding: Only immaculate can breed";
    string private constant SIGNATURE_CANCELED = "Breeding: Partner signature canceled";
    string private constant INVALID_ASSET = "Breeding: Asset is invalid";
    string private constant INVALID_MOTHER_GENDER = "Breeding: Mother must be a female";
    string private constant INVALID_FATHER_GENDER = "Breeding: Father must be a male";
    string private constant ALREADY_ADULT = "Breeding: already adult";
    string private constant NOT_ENOUGH = "Breeding: Not enough tokens to pay";
    string private constant NOT_ENOUGH_ALLOWED = "Breeding: Not enough tokens allowed to pay";
    string private constant LEAST_ONE_DAY = "Breeding: Not enough to pay even one day";
    
    modifier validParams(Structures.BreedingParams calldata params_) {
        _validateParams(params_);
        _;
    }

    /**
    @notice constructor
    @param rights_, The address of the rights
    @param zombies_ The address of the zombies
    @param random_ The address of the random
    @param deviationDownPromille_ The deviation to down of the actor property, in promille
    @param deviationUpPromille_ The deviation to up of the actor property, in promille
    */
    function initialize(
        address rights_,
        address zombies_,
        address random_,
        address asset_,
        address feeAddress_,
        uint16 deviationDownPromille_,
        uint16 deviationUpPromille_,
        uint16 propertyLimit_,
        uint256 serviceFee_,
        uint256 growPeriod_,
        uint256 growPrice_,
        uint256 startFrom_
    ) public initializer {
        __GuardExtensionUpgradeable_init(rights_);

        _zombie = IActors(zombies_);
        _random = IRandaoRandomizer(random_);
        _asset = IERC20(asset_);
        _feeAddress = feeAddress_;
        _deviationDownPromille = deviationDownPromille_;
        _deviationUpPromille = deviationUpPromille_;
        _propertyLimit = propertyLimit_;
        _serviceFee = serviceFee_;
        _growPeriod = growPeriod_;
        _growPrice = growPrice_;
        _counter = startFrom_;

        emit DeviationUpdated(deviationDownPromille_, deviationUpPromille_);
        emit LimitUpdated(propertyLimit_);
        emit FeeAddressUpdated(feeAddress_);
        emit FeesUpdated(asset_, serviceFee_, growPrice_);
    }

    /**
    @notice Set the fee receiving address
    @param feeAddress_ Fee receiving address
    */
    function setFeeAddress(address feeAddress_) external override haveRights {
        _feeAddress = feeAddress_;
        emit FeeAddressUpdated(feeAddress_);
    }

    /**
    @notice Set the breeding and growing fees
    @param serviceFee_ Service fee value
    @param growPrice_ Growing up price per day
    @param asset_ ERC20 contract address
    */
    function setFees(
        uint256 serviceFee_,
        uint256 growPrice_,
        address asset_
    ) external override haveRights {
        _serviceFee = serviceFee_;
        _growPrice = growPrice_;
        _asset = IERC20(asset_);
        emit FeesUpdated(asset_, serviceFee_, growPrice_);
    }

    /**
    @notice Set the growing up period in seconds
    @param growPeriod_ Growing up period value
    */
    function setGrowPeriod(uint256 growPeriod_) external override haveRights {
        _growPeriod = growPeriod_;
        emit GrowPeriodUpdated(growPeriod_);
    }

    /**
    @notice Set the maximum allowed limit of the actor property in ppm
    @param limitPromille_ Limit value in ppm
    */
    function setPropertyLimit(uint16 limitPromille_) external override haveRights {
        _propertyLimit = limitPromille_;
        emit LimitUpdated(limitPromille_);
    }

    /**
    @notice Set the maximum deviation of the actor property in ppm
    @param deviationDownPromille_ The deviation to down of the actor property, in ppm
    @param deviationUpPromille_ The deviation to up of the actor property in ppm
    */
    function setDeviation(
        uint16 deviationDownPromille_,
        uint16 deviationUpPromille_
    ) external override haveRights {
        _deviationDownPromille = deviationDownPromille_;
        _deviationUpPromille = deviationUpPromille_;
        emit DeviationUpdated(deviationDownPromille_, deviationUpPromille_);
    }

    /**
    @notice Get the fee address
    @return The current service fee address
    */
    function getFeeAddress() external view override returns(address) {
        return _feeAddress;
    }

    /**
    @notice Get the breeding ERC20 asset address
    @return The current breeding asset address
    */
    function getAsset() external view override returns(address) {
        return address(_asset);
    }

    /**
    @notice Get the service fee value
    @return The current service fee value
    */
    function getServiceFee() external view override returns(uint256) {
        return _serviceFee;
    }

    /**
    @notice Get the growing up period in seconds
    @return The current growing up period value
    */
    function getGrowPeriod() external view override returns(uint256) {
        return _growPeriod;
    }

    /**
    @notice Get the current limit of the actor properties
    @return The current limit value
    */
    function getPropertyLimit() external view override returns (uint16) {
        return _propertyLimit;
    }

    /**
    @notice Get the current maximal deviation of the actor property, in promille
    @return The current deviation up and down values
    */
    function getDeviation() external view override returns (uint16, uint16) {
        return (_deviationDownPromille, _deviationUpPromille);
    }

    /**
    @notice Get the current zombie kid id
    @return The current zombie kid id
    */
    function getCounter() external view override returns (uint256) {
        return _counter;
    }

    /**
    @notice Cancel signature. 
    @param hash_ The packed data keccak256 hash
    @param signature_ The data signature
    */
    function cancelSignature(bytes32 hash_, bytes calldata signature_) external {        
        // administrator can cancel any signatures
        if (!_rights().haveRights(address(this), msg.sender)) {
            require(_recoverAddress(hash_, signature_) == msg.sender, INVALID_SIGNATURE);
        }
        
        _canceledSignatures[keccak256(signature_)] = true;
        emit SignatureCanceled(msg.sender, signature_);
    }

    /**
    @notice Breed a new actor from the father and mother. 
    @param params_ The breeding params
    @param partnerSignature_ The partner params signature. 
           Not required if sender is mother and father.
    @return The id of breeded actor
    */
    function breed(        
        Structures.BreedingParams calldata params_,
        bytes calldata partnerSignature_
    ) external override validParams(params_) returns(uint256) {        
        address motherAccount = _zombie.ownerOf(params_.motherId);
        address fatherAccount = _zombie.ownerOf(params_.fatherId);

        if (motherAccount != fatherAccount) {
            address signer = _recoverAddress(keccak256(abi.encode(params_)), partnerSignature_);
            if (motherAccount == msg.sender) {
                require(signer == fatherAccount, INVALID_SIGNATURE);
            } else if (fatherAccount == msg.sender) {
                require(signer == motherAccount, INVALID_SIGNATURE);
            } else {
                revert(WRONG_OWNER);
            }
        } else {
            require(motherAccount == msg.sender, WRONG_OWNER);
        }

        return _breed(params_, _serviceFee, motherAccount, fatherAccount);
    }

    /**
    @notice Breed a new actor with administrator signed params. 
            The admin sets the service fee. 
    @param params_ The breeding params
    @param serviceFee_ The service fee value
    @param adminSignature_ The admin params signature
    @return The id of breeded actor
    */
    function breed(
        Structures.BreedingParams calldata params_,
        uint256 serviceFee_,
        bytes calldata adminSignature_
    ) external override validParams(params_) returns (uint256) {
        // administrator can allow any breedings
        address signer = _recoverAddress(keccak256(abi.encode(params_, serviceFee_)), adminSignature_);
        require(_rights().haveRights(address(this), signer), INVALID_SIGNATURE);

        IActors zombie = _zombie;
        address motherAccount = zombie.ownerOf(params_.motherId);
        address fatherAccount = zombie.ownerOf(params_.fatherId);
        return _breed(params_, serviceFee_, motherAccount, fatherAccount);
    }

    function _breed(
        Structures.BreedingParams calldata params_,
        uint256 serviceFee_,
        address motherAccount_,
        address fatherAccount_
    ) internal returns(uint256 kidId) {
        _completedBreedings.set(params_.breedingId);
        _completedSessions.set(params_.sessionId);
        IActors zombie = _zombie;
        IERC20 asset = _asset;
        zombie.breedChild(params_.motherId);

        uint16[10] memory props = _calcProps(
            zombie.getProps(params_.motherId), 
            zombie.getProps(params_.fatherId)
        );

        address kidOwner;
        address breedingFeeOwner;
        if (params_.isKidForMother) {
            kidOwner = motherAccount_;
            breedingFeeOwner = fatherAccount_;
        } else {
            kidOwner = fatherAccount_;
            breedingFeeOwner = motherAccount_;
        }

        uint256 breedingFee =  motherAccount_ != fatherAccount_
            ? params_.breedingFee
            : 0;

        if (breedingFee > 0) {
            asset.transferFrom(kidOwner, breedingFeeOwner, breedingFee);
        }

        if (serviceFee_ > 0) {
            asset.transferFrom(kidOwner, _feeAddress, serviceFee_);
        }

        ++_counter;
        kidId = zombie.mint(_counter, kidOwner, props, true, true, block.timestamp + _growPeriod, 0, false);
        
        emit BreedingCompleted(
            kidId, 
            params_.breedingId, 
            params_.sessionId,
            params_.motherId, 
            params_.fatherId, 
            breedingFee, 
            serviceFee_
        );
    }

    /**
    @notice Grow the non-adult zombie with administrtor signature.
            Takes the provided amount of tokens from the caller account.
    @param id_ Zombie token id
    @param amount_ Amount of tokens transferred
    @param days_ Number of days to reduce adult time
    @param nonce_ Random non-repeating number
    */
    function growUp(
        uint256 id_,
        uint256 amount_,
        uint256 days_,
        uint256 nonce_,
        bytes calldata adminSignature_
    ) external {
        IActors zombie = _zombie;
        IERC20 asset = _asset;
        require(!zombie.isAdult(id_), ALREADY_ADULT);

        // administrator can allow growing up any zombie 
        address signer = _recoverAddress(keccak256(abi.encode(id_, days_, nonce_)), adminSignature_);
        require(_rights().haveRights(address(this), signer), INVALID_SIGNATURE);
        _canceledSignatures[keccak256(adminSignature_)] = true;

        if (amount_ > 0) {
            require(asset.balanceOf(msg.sender) >= amount_, NOT_ENOUGH);
            require(asset.allowance(msg.sender, address(this)) >= amount_, NOT_ENOUGH_ALLOWED);
            asset.transferFrom(msg.sender, _feeAddress, amount_); 
        }

        uint256 adultTime = zombie.getAdultTime(id_);
        uint256 growInterval = adultTime - block.timestamp;

        if (growInterval <= days_ * 1 days) {
            zombie.setAdultTime(id_, block.timestamp);
            emit Adult(id_, msg.sender, amount_);
        } else {
            uint256 newAdultTime = adultTime - days_ * 1 days;
            zombie.setAdultTime(id_, newAdultTime);
            emit Grow(id_, msg.sender, amount_, newAdultTime);
        }
    }

    /**
    @notice Grow the non-adult zombie. Takes the provided amount of tokens from 
            the caller account, but not more than needed
    @param id_ Zombie token id
    @param amount_ Amount of tokens transferred
    */
    function growUp(uint256 id_, uint256 amount_) external { 
        IActors zombie = _zombie;
        IERC20 asset = _asset;
        require(!zombie.isAdult(id_), ALREADY_ADULT);
        require(amount_ >= _growPrice, LEAST_ONE_DAY);

        uint256 adultTime = zombie.getAdultTime(id_);
        uint256 growInterval = adultTime - block.timestamp;

        // Always round up
        uint256 daysToAdult = growInterval / 1 days + 1;
        uint256 paidDays = calcGrowDays(amount_);

        if (paidDays >= daysToAdult) {
            uint256 price = calcGrowPrice(daysToAdult);
            require(asset.balanceOf(msg.sender) >= price, NOT_ENOUGH);
            require(asset.allowance(msg.sender, address(this)) >= price, NOT_ENOUGH_ALLOWED);
            asset.transferFrom(msg.sender, _feeAddress, price);
            zombie.setAdultTime(id_, block.timestamp);
            emit Adult(id_, msg.sender, price);
        } else {
            uint256 price = calcGrowPrice(paidDays);
            uint256 newAdultTime = adultTime - paidDays * 1 days;
            require(asset.balanceOf(msg.sender) >= price, NOT_ENOUGH);
            require(asset.allowance(msg.sender, address(this)) >= price, NOT_ENOUGH_ALLOWED);
            asset.transferFrom(msg.sender, _feeAddress, price); 
            zombie.setAdultTime(id_, newAdultTime);
            emit Grow(id_, msg.sender, price, newAdultTime);
        }        
    }

    /**
    @notice Calculates the number of days for which the child will grow up for a given amount
    @param amount_ Amount of tokens
    @return Number of days
    */
    function calcGrowDays(uint256 amount_) public view override returns(uint256) {
        return amount_ / _growPrice; 
    }

    /**
    @notice Calculates the amount required to grow up for a given number of days
    @param growDays_ Number of days
    @return Amount of tokens
    */
    function calcGrowPrice(uint256 growDays_) public view override returns(uint256) {
        return growDays_ * _growPrice; 
    }

    function _validateParams(        
        Structures.BreedingParams calldata params_
    ) internal view {
        IActors zombie = _zombie;
        require(block.timestamp <= params_.deadline, DEAL_EXPIRED);
        require(zombie.isAdult(params_.motherId) && zombie.isAdult(params_.fatherId), TOO_YOUNG);
        require(zombie.getImmaculate(params_.motherId), ONLY_IMMACULATE);
        require(zombie.getImmaculate(params_.fatherId), ONLY_IMMACULATE);
        require(!_completedBreedings.get(params_.breedingId), BREEDING_ALREADY_COMPLETED);
        require(!_completedSessions.get(params_.sessionId), SESSION_ALREADY_COMPLETED);
        require(zombie.getSex(params_.fatherId), INVALID_FATHER_GENDER);
        require(!zombie.getSex(params_.motherId), INVALID_MOTHER_GENDER);
        require(params_.asset == address(_asset), INVALID_ASSET);
    }

    function _recoverAddress(
        bytes32 hash_, 
        bytes calldata signature_
    ) internal view returns(address) {
        require(!_canceledSignatures[keccak256(signature_)], SIGNATURE_CANCELED);
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash_);
        return ECDSA.recover(ethSignedMessageHash, signature_);
    }

    function _calcProps(
        uint16[10] memory motherProps,
        uint16[10] memory fatherProps
    ) internal returns (uint16[10] memory props) {
        uint256 randomValue = _random.randomize();
        for (uint8 i; i < 10;) {            
            uint256 middle = (uint256(fatherProps[i]) + motherProps[i]) / 2;
            uint256 minimal = middle - (middle * _deviationDownPromille / 1000);
            uint256 maximal = middle + (middle * _deviationUpPromille / 1000);
            uint256 range = maximal - minimal;
            uint256 deviationRandom = randomValue % 10 ** (6 + i) / 10 ** i;
            uint256 value = deviationRandom % range + minimal;

            if (value >= type(uint16).max) {
                props[i] = type(uint16).max;
            } else if (value <= MINIMAL_PROPERTY_VALUE) {
                props[i] = MINIMAL_PROPERTY_VALUE;
            } else {
                props[i] = uint16(value);
            }

            unchecked { ++i; }
        }
    }
}
