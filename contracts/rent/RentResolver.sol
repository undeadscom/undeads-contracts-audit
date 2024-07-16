// SPDX-License-Identifier: PROPRIERTARY
// For development, we used some code from open source with an MIT license
// https://github.com/re-nft/legacy-contracts

pragma solidity =0.8.17;

import "./interfaces/IRentResolver.sol";
import "../utils/GuardExtension.sol";

contract RentResolver is IRentResolver, GuardExtension {
    mapping(uint8 => address) private addresses;

    constructor(
        address rights_,
        uint8[] memory pts_,
        address[] memory addresses_
    ) GuardExtension(rights_) {
        require(pts_.length == addresses_.length, "ReNFT::invalid input");
        for (uint i; i < pts_.length; ++i) {
            addresses[pts_[i]] = addresses_[i];
        }
     }

    function getPaymentToken(uint8 pt_) external view override returns (address) {
        return addresses[pt_];
    }

    function setPaymentToken(uint8 pt_, address v_) external override haveRights {
        require(pt_ != 0, "ReNFT::cant set sentinel");
        require(addresses[pt_] == address(0), "ReNFT::cannot reset the address");
        addresses[pt_] = v_;
    }
}
