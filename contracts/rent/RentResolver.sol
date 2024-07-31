// SPDX-License-Identifier: PROPRIERTARY
// For development, we used some code from open source with an MIT license
// https://github.com/re-nft/legacy-contracts

pragma solidity =0.8.17;

import "./interfaces/IRentResolver.sol";
import "../utils/GuardExtension.sol";

error InvalidInput();
error PtAlreadySet();

contract RentResolver is IRentResolver, GuardExtension {
    mapping(uint8 => address) private _addresses;

    constructor(
        address rights_,
        uint8[] memory pts_,
        address[] memory addresses_
    ) GuardExtension(rights_) {
        if (pts_.length != addresses_.length) {
            revert InvalidInput();
        }
        for (uint i; i < pts_.length; ++i) {
            _addresses[pts_[i]] = addresses_[i];
        }
     }

    function getPaymentToken(uint8 pt_) external view override returns (address tokenAddress) {
        tokenAddress = _addresses[pt_];
    }

    function setPaymentToken(uint8 pt_, address v_) external override haveRights {
        if (pt_ == 0) {
            revert InvalidInput();
        }
        if (_addresses[pt_] != address(0)) {
            revert PtAlreadySet();
        }
        _addresses[pt_] = v_;
    }
}
