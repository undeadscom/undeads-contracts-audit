// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: ilya@zionodes.com

pragma solidity 0.8.17;

interface IManagement {
    event AdminAdded(address indexed admin);
    event ManagerAdded(address indexed manager);
    event ManagerRemoved(address indexed manager);
    event AdminChangePending(address indexed proposer, address indexed admin);
    event AdminChanged(
        address indexed signer,
        address indexed oldAdmin,
        address indexed newAdmin
    );
    event ActionAdded(
        uint256 id,
        address indexed author,
        address indexed target,
        bytes4 signature
    );
    event ActionSigned(uint256 id, address indexed signer);
    event ActionExecuted(uint256 id, address indexed signer);
    event DurationChangeRequest(address indexed signer, uint256 duration);
    event DurationChanged(address indexed signer, uint256 duration);
    event TokenChangeRequest(address indexed signer, address token);
    event TokenChanged(address indexed signer, address token);
    event TargetChangeRequest(address indexed signer, address target);
    event TargetChanged(address indexed signer, address target);
    event PromillesSet(
        address indexed signer,
        address indexed investor,
        uint256 promilles
    );
    event PromillesChangeRequest(
        address indexed signer,
        address indexed investor,
        uint256 promilles
    );
    event Distributed(
        address indexed distributor,
        uint256 total,
        uint256 remains
    );
}
