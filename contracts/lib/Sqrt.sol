// SPDX-License-Identifier: PROPRIERTARY

// Author: Danylo Moshenskyi
// Email: dnm@unicsoft.com

pragma solidity 0.8.17;

library Sqrt {
    function floorSqrt(uint256 n) public pure returns (uint256) {
        unchecked {
            if (n > 0) {
                uint256 x = n / 2 + 1;
                uint256 y = (x + n / x) / 2;
                while (x > y) {
                    x = y;
                    y = (x + n / x) / 2;
                }
                return x;
            }
            return 0;
        }
    }

    function ceilSqrt(uint256 n) public pure returns (uint256) {
        unchecked {
            uint256 x = floorSqrt(n);
            return x ** 2 == n ? x : x + 1;
        }
    }
}
