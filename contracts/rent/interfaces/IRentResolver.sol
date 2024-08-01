// SPDX-License-Identifier: PROPRIERTARY

pragma solidity =0.8.17;

interface IRentResolver {
    event PaymentTokenAdded(uint8 pt, address tokenAddress);
    
    function getPaymentToken(uint8 pt_) external view returns (address);

    function setPaymentToken(uint8 pt_, address v_) external;
}
