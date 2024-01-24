// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "solidity-big-number/project/contracts/NaturalNum.sol";
import "./interfaces/IRandomizer.sol";

contract LehmerRandomizer is IRandomizer, OwnableUpgradeable {
    mapping(address => uint256) private _seeds;
    mapping(address => uint256) private _last;
    uint256[] private A;
    uint256[] private B;
    uint256[] private C;
    uint256[] private D;

    function initialize() public initializer {
        __Ownable_init();

        A = NaturalNum.encode(279470273);
        B = NaturalNum.encode(4294967295);
        C = NaturalNum.encode(5);
        D = NaturalNum.encode(4);
    }

    function _seed() internal {
        uint256 index = uint256(uint160(msg.sender));
        _seeds[msg.sender] = (index << 1) | 1;
    }

    function _randomize() internal returns (uint256) {
        if (_seeds[msg.sender] == 0) {
            _seed();
        }
        uint256[] memory product = NaturalNum.mul(
            NaturalNum.encode(_seeds[msg.sender]),
            A
        );
        product = NaturalNum.add(
            NaturalNum.and(product, B),
            NaturalNum.mul(C, NaturalNum.shr(product, 32))
        );
        product = NaturalNum.add(D, product);
        _seeds[msg.sender] =
            NaturalNum.decode(product) +
            5 *
            NaturalNum.decode(NaturalNum.shr(product, 32)) -
            4;
        return _seeds[msg.sender];
    }

    function randomize() external override returns (uint256) {
        _last[msg.sender] = _randomize();
        return _last[msg.sender];
    }

    function randomize(uint256 limit) external override returns (uint256) {
        _last[msg.sender] = _randomize() % limit;
        return _last[msg.sender];
    }

    /**
     * @dev Returns the weightened distributed value.
     *
     * [IMPORTANT]
     * ====
     * The weights are need to be sorted in descending order.
     * target should be less or equal of summ of all weights
     * This function uses Hopscotch Selection method (https://blog.bruce-hill.com/a-faster-weighted-random-choice).
     * The runtime is O(1)
     * ====
     */
    function _weightedDistribution(uint256 target, uint256[] memory weights)
        private
        pure
        returns (uint256)
    {
        uint256 index = 0;
        while (index < weights.length && weights[index] <= target) {
            target -= weights[index];
            index++;
        }
        return index;
    }

    /**
     * @dev Returns Random number
     *
     * [IMPORTANT]
     * ====
     * First parameter removed and unused as Potions during creation pass wrong total number
     * ====
     */
    function distributeRandom(uint256, uint256[] memory weights)
        external
        override
        returns (uint256)
    {
        uint256 total = 0;
        for (uint256 i = 0; i < weights.length; i++) {
            total += weights[i];
        }
        require(total > 0, "LehmerRandomizer: zero total");
        uint256 randomValue =  _weightedDistribution(
            _randomize() % total,
            weights
        );
        _last[msg.sender] = randomValue;

        // fix for last item in each level
        // there is another scenario when Potions uses distributeRandom 
        // and pass weights.length == 2, so we should not apply fix for this scenario
        if (weights.length == 5) {
            if (weights[randomValue] > 1) return randomValue;

            if (randomValue > 0) {
                for (uint256 i = randomValue - 1; i >= 0; i--) {
                    if (weights[i] > 1) {
                        return i;
                    }
                }
            }
            for (uint256 i = randomValue + 1; i < weights.length; i++) {
                if (weights[i] > 1) {
                    return i;
                }
            }
        }
        
        return randomValue;
    }

    function last() external view override returns (uint256) {
        return _last[msg.sender];
    }
}
