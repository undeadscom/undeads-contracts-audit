// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/GuardExtension.sol";
import "../persons/interfaces/IActors.sol";
import "./interfaces/IStaking.sol";

contract Staking is IStaking, GuardExtension {
    using EnumerableSet for EnumerableSet.UintSet;
    using SafeERC20 for IERC20;

    mapping(address => EnumerableSet.UintSet) _stakesByAddress;
    mapping(uint128 => Stake) _stakes;

    uint256 private _maxAPR; // two decimals 100% == 10000
    uint128[6] private _intervalsMonth;
    uint128[6] private _intervalCoefficient;
    uint128[5] private _boosterCoefficient;
    uint128 private _counter;

    // Decimal places are not taken
    // Total supply 250,000,000 UDS
    uint128 private _totalShares;
    uint128 private totalStakes;

    IERC20 private _udsToken;
    IActors private _zombies;

    string private constant ZERO_AMOUNT = "Staking: Required amount > 0";
    string private constant NOT_ZOMBIE_OWNER = "Staking: Zombie owner required";
    string private constant NOT_EXISTS = "Staking: Staking not exists";
    string private constant NOT_OVER = "Staking Staking is not over";
    string private constant ALREADY_REWARDED = "Staking: Already rewarded";
    string private constant INVALID_ZOMBIE_LEVEL =
        "Staking: Zombie level is invalid";
    string private constant INVALID_INTERVAL =
        "Staking: Staking interval is invalid";
    string private constant INVALID_STAKING_ID =
        "Staking: Staking id is invalid";

    constructor(
        address rights_,
        address udsToken_,
        address zombies_,
        uint16 maxAPR_,
        uint128[6] memory intervalsMonth_,
        uint128[6] memory intervalCoefficients_,
        uint128[5] memory boosterCoefficients_
    ) GuardExtension(rights_) {
        _udsToken = IERC20(udsToken_);
        _zombies = IActors(zombies_);
        _setCoefficients(intervalCoefficients_, boosterCoefficients_);
        _setMaxApr(maxAPR_);
        _intervalsMonth = intervalsMonth_;
        _totalShares = 1; // set minimal shares to avoid devide by zero
    }

    /**
     * @dev Sets coefficients for staking time and the presence of zombie.
     *      The coefficient requires 2 decimal places (1.0 == 100)
     * @param intervalCoefficients_ Coefficients for staking time correspond to _intervalsMonth.
     * @param boosterCoefficients_ Coefficients for owning zombies correspond to the level of zombies.
     */
    function setCoefficients(
        uint128[6] memory intervalCoefficients_,
        uint128[5] memory boosterCoefficients_
    ) external haveRights {
        _setCoefficients(intervalCoefficients_, boosterCoefficients_);
    }

    /**
     * @dev Sets the upper limit of APR.
     * @param maxAPR_ Maximum APR percentage to two decimal places (100% == 10000).
     */
    function setMaxApr(uint32 maxAPR_) external haveRights {
        _setMaxApr(maxAPR_);
    }

    /**
     * @dev Stake user tokens for a specified period of time.
     * @param stakeAmount_ Number of tokens for staking. Specified without decimal places.
     * @param interval_ Time interval index 0-5 (see getMonthIntervals()).
     */
    function stake(uint64 stakeAmount_, uint8 interval_) public {
        _stake(stakeAmount_, interval_, 100, 0);
    }

    /**
     * @dev Stake user tokens for a specified period of time with discount for zombiew owners.
     * @param stakeAmount_ Number of tokens for staking. Specified without decimal places.
     * @param interval_ Time interval index 0-5 (see getMonthIntervals()).
     * @param zombieId_ Zombie ID.
     */
    function stakeByZombieOwner(
        uint64 stakeAmount_,
        uint8 interval_,
        uint256 zombieId_
    ) public {
        require(msg.sender == _zombies.ownerOf(zombieId_), NOT_ZOMBIE_OWNER);
        uint16 rank = _zombies.getRank(zombieId_);
        _stake(stakeAmount_, interval_, _getBoostByRank(rank), zombieId_);
    }

    /**
     * @dev Returns staked tokens along with the reward.
     * @param stakeId_ Staking ID.
     */
    function claim(uint128 stakeId_) public {
        require(
            _stakesByAddress[msg.sender].contains(stakeId_),
            INVALID_STAKING_ID
        );
        Stake memory currentStake = _stakes[stakeId_];
        require(currentStake.lockedUntil < block.timestamp, NOT_OVER);

        uint256 unwrappedStakeAmount = uint256(currentStake.amount) * 1e18;
        uint256 totalAmount = _calcReward(
            currentStake.amount,
            currentStake.shares,
            currentStake.interval
        ) + unwrappedStakeAmount;

        _totalShares -= currentStake.shares;
        totalStakes -= currentStake.amount;
        _stakesByAddress[msg.sender].remove(stakeId_);
        delete _stakes[stakeId_];

        _udsToken.safeTransfer(msg.sender, totalAmount);
        emit StakeClaimed(msg.sender, stakeId_, totalAmount);
    }

    /**
     * @dev Returns staking by ID.
     * @param stakeId_ Staking ID.
     */
    function getStake(uint128 stakeId_) public view returns (Stake memory) {
        return _stakes[stakeId_];
    }

    /**
     * @dev Returns all staking IDs by stake holder address.
     * @param stakeholder_ Address of stake holder.
     */
    function getStakesOf(
        address stakeholder_
    ) public view returns (uint256[] memory) {
        return _stakesByAddress[stakeholder_].values();
    }

    /**
     * @dev Returns shares for the staking by ID.
     * @param stakeId_ Staking ID.
     */
    function sharesOf(uint128 stakeId_) public view returns (uint128) {
        return _stakes[stakeId_].shares;
    }

    /**
     * @dev Returns the reward size for the specified staking ID under current conditions.
     * @param stakeId_ Staking ID.
     */
    function rewardOf(uint128 stakeId_) public view returns (uint256) {
        Stake memory currentStake = _stakes[stakeId_];
        require(currentStake.lockedUntil < block.timestamp, ALREADY_REWARDED);
        require(currentStake.amount > 0, NOT_EXISTS);
        return
            _calcReward(
                currentStake.amount,
                currentStake.shares,
                currentStake.interval                
            );
    }

    /**
     * @dev Calculates the reward based on the staking amount and interval.
     * @param stakeAmount_ Number of tokens for staking. Specified without decimal places.
     * @param interval_ Time interval index 0-5 (see getMonthIntervals()).
     */
    function estimateReward(
        uint64 stakeAmount_,
        uint8 interval_
    ) public view returns (uint256) {
        require(stakeAmount_ > 0, ZERO_AMOUNT);
        require(interval_ < 6, INVALID_INTERVAL);
        uint128 shares = _intervalCoefficient[interval_] * stakeAmount_ * 100;
        return _calcReward(stakeAmount_, shares, interval_);
    }

    /**
     * @dev Calculates the reward based on the staking amount, interval and zombie level.
     * @param stakeAmount_ Number of tokens for staking. Specified without decimal places.
     * @param interval_ Time interval index 0-5 (see getMonthIntervals()).
     * @param zombieLevel_ Zombie level.
     */
    function estimateRewardForZombieOwner(
        uint64 stakeAmount_,
        uint8 interval_,
        uint8 zombieLevel_
    ) public view returns (uint256) {
        require(stakeAmount_ > 0, ZERO_AMOUNT);
        require(interval_ < 6, INVALID_INTERVAL);
        require(zombieLevel_ < 5, INVALID_ZOMBIE_LEVEL);
        uint128 shares = _boosterCoefficient[zombieLevel_] *
            _intervalCoefficient[interval_] *
            stakeAmount_;
        return _calcReward(stakeAmount_, shares, interval_);
    }

    /**
     * @dev Returns total staked amount.
     */
    function getTotalStakes() public view returns (uint256) {
        return uint256(totalStakes) * 1e18;
    }

    /**
     * @dev Returns total staked shares.
     */
    function getTotalShares() public view returns (uint256) {
        return _totalShares;
    }

    /**
     * @dev Returns current reward pool for stake holder.
     */
    function getCurrentRewardsPool() public view returns (uint256) {
        return
            _udsToken.balanceOf(address(this)) - (uint256(totalStakes) * 1e18);
    }

    /**
     * @dev Returns an array of staking intervals specified in months (1 month == 30 days).
     */
    function getMonthIntervals() public view returns (uint128[6] memory) {
        return _intervalsMonth;
    }

    /**
     * @dev Returns boost coefficients for staking time in accordance with the interval.
     */
    function getIntervalCoefficients() public view returns (uint128[6] memory) {
        return _intervalCoefficient;
    }

    /**
     * @dev Returns boost coefficients for zombie ownership in accordance with the zombie level.
     */
    function getBoostCoefficients() public view returns (uint128[5] memory) {
        return _boosterCoefficient;
    }

    /**
     * @dev Returns APR limit for rewards.
     */
    function getMaxApr() public view returns (uint256) {
        return _maxAPR;
    }

    function _getBoostByRank(
        uint16 zombieRank_
    ) private view returns (uint128) {
        if (zombieRank_ < 1150) {
            return _boosterCoefficient[0];
        } else if (zombieRank_ < 1270) {
            return _boosterCoefficient[1];
        } else if (zombieRank_ < 1390) {
            return _boosterCoefficient[2];
        } else if (zombieRank_ < 1490) {
            return _boosterCoefficient[3];
        } else {
            return _boosterCoefficient[4];
        }
    }

    function _stake(
        uint64 stakeAmount_,
        uint8 interval_,
        uint128 boostCoefficient_,
        uint256 zombieId_
    ) private {
        require(stakeAmount_ > 0, ZERO_AMOUNT);
        require(interval_ < 6, INVALID_INTERVAL);
        uint128 shares = boostCoefficient_ *
            _intervalCoefficient[interval_] *
            stakeAmount_;
        ++_counter;
        uint128 stakeId = _counter;
        _stakesByAddress[msg.sender].add(stakeId);
        _stakes[stakeId] = Stake({
            amount: stakeAmount_,
            shares: shares,
            lockedUntil: uint40(
                block.timestamp + (_intervalsMonth[interval_] * 30 * 1 days)
            ),
            interval: interval_
        });

        totalStakes += stakeAmount_;
        _totalShares += shares;

        uint256 unwrappedAmount = uint256(stakeAmount_) * 1e18;
        _udsToken.safeTransferFrom(msg.sender, address(this), unwrappedAmount);

        emit StakeAdded(msg.sender, stakeId, zombieId_, boostCoefficient_);
    }

    function _setMaxApr(uint32 maxAPR_) private {
        _maxAPR = maxAPR_;
        emit MaxAprUpdated(maxAPR_);
    }

    function _setCoefficients(
        uint128[6] memory intervalCoefficients_,
        uint128[5] memory boosterCoefficients_
    ) private {
        _intervalCoefficient = intervalCoefficients_;
        _boosterCoefficient = boosterCoefficients_;
        emit CoefficientsUpdated(intervalCoefficients_, boosterCoefficients_);
    }

    function _calcReward(
        uint128 stakeAmount_,
        uint128 shares_,
        uint8 interval_        
    ) private view returns (uint256) {
        uint256 rewardPool = _udsToken.balanceOf(address(this)) -
            (uint256(totalStakes) * 1e18);
        uint256 rewards = rewardPool * shares_ / _totalShares;
        uint256 maxRewards = (_maxAPR * stakeAmount_ * 1e18 * _intervalsMonth[interval_]) /
            120000;

        return rewards < maxRewards ? rewards : maxRewards;
    }
}
