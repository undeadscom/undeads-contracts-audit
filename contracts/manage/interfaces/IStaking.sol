// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

pragma solidity 0.8.17;

interface IStaking {
    event StakeAdded(address indexed staker, uint128 indexed stakeId, uint256 zombieId, uint128 boostCoefficient);
    event StakeClaimed(address indexed staker, uint128 indexed stakeId, uint256 totalAmount);
    event CoefficientsUpdated(uint128[6] intervalCoefficients, uint128[5] boosterCoefficients);
    event MaxAprUpdated(uint32 maxAPR_);

    struct Stake {
        uint64 amount;
        uint128 shares;
        uint40 lockedUntil;
        uint8 interval;
    }
}