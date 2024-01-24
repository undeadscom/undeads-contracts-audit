// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "../../lib/Structures.sol";

interface IBreed {
    event DeviationUpdated(uint256 downPromille, uint256 upPromille);
    event SignatureCanceled(address indexed signer, bytes signature);
    event LimitUpdated(uint16 limitPromille);
    event FeesUpdated(address indexed asset, uint256 serviceFee, uint256 growPrice);
    event FeeAddressUpdated(address indexed feeAddress);
    event ServerAddressUpdated(address indexed serverAddress);
    event GrowPeriodUpdated(uint256 interval);
    event Grow(uint256 indexed kidId, address indexed user, uint256 amount, uint256 adultTime);
    event Adult(uint256 indexed kidId, address indexed user, uint256 amount);
    event BreedingCompleted(
        uint256 indexed kidId,
        uint256 indexed breedingId,
        uint256 indexed sessionId,
        uint256 motherId,
        uint256 fatherId,
        uint256 breedingFee,
        uint256 serviceFee
    );

    /**
    @notice Set the fee receiving address
    @param feeAddress_ Fee receiving address
    */
    function setFeeAddress(address feeAddress_) external;

    /**
    @notice Set the breeding and growing fees
    @param serviceFee_ Service fee value
    @param growPrice_ Growing up price per day
    @param asset_ ERC20 contract address
    */
    function setFees(uint256 serviceFee_, uint256 growPrice_, address asset_) external;

    /**
    @notice Set the growing up period in seconds
    @param growPeriod_ Growing up period value
    */
    function setGrowPeriod(uint256 growPeriod_) external;

    /**
    @notice Set the maximum allowed limit of the actor property in ppm
    @param limitPromille_ Limit value in ppm
    */
    function setPropertyLimit(uint16 limitPromille_) external;

    /**
    @notice Set the maximum deviation of the actor property in ppm
    @param deviationDownPromille_ The deviation to down of the actor property, in ppm
    @param deviationUpPromille_ The deviation to up of the actor property in ppm
    */
    function setDeviation(
        uint16 deviationDownPromille_,
        uint16 deviationUpPromille_
    ) external;

    /**
    @notice Get the fee address
    @return The current service fee address
    */
    function getFeeAddress() external view returns(address);

    /**
    @notice Get the breeding ERC20 asset address
    @return The current breeding asset address
    */
    function getAsset() external view returns(address);

    /**
    @notice Get the service fee value
    @return The current service fee value
    */
    function getServiceFee() external view returns(uint256);

    /**
    @notice Get the growing up period in seconds
    @return The current growing up period value
    */
    function getGrowPeriod() external view returns(uint256);

    /**
    @notice Get the current limit of the actor properties
    @return The current limit value
    */
    function getPropertyLimit() external view returns (uint16);

    /**
    @notice Get the current maximal deviation of the actor property, in promille
    @return The current deviation up and down values
    */
    function getDeviation() external view returns (uint16, uint16);

    /**
    @notice Get the current zombie kid id
    @return The current zombie kid id
    */
    function getCounter() external view returns (uint256);

    /**
    @notice Cancel signature. 
    @param hash_ The packed data keccak256 hash
    @param signature_ The data signature
    */
    function cancelSignature(bytes32 hash_, bytes calldata signature_) external;

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
    ) external returns(uint256);

    /**
    @notice Breed a new actor with administrator signed params without service fee. 
    @param params_ The breeding params
    @param serviceFee_ The service fee value
    @param adminSignature_ The admin params signature
    @return The id of breeded actor
    */
    function breed(
        Structures.BreedingParams calldata params_,
        uint256 serviceFee_,
        bytes calldata adminSignature_
    ) external returns (uint256);

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
    ) external;

    /**
    @notice Grow the non-adult zombie. Takes the provided amount of tokens from 
            the caller account, but not more than needed
    @param id_ Zombie token id
    @param amount_ Amount of tokens transferred
    */
    function growUp(uint256 id_, uint256 amount_) external;

    /**
    @notice Calculates the number of days for which the child will grow up for a given amount
    @param amount_ Amount of tokens
    @return Number of days
    */
    function calcGrowDays(uint256 amount_) external view returns(uint256);

    /**
    @notice Calculates the amount required to grow up for a given number of days
    @param growDays_ Number of days
    @return Amount of tokens
    */
    function calcGrowPrice(uint256 growDays_) external view returns(uint256);
}
