// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

pragma solidity 0.8.17;

contract Voting {
    struct VoteData {
        mapping(address => bool) voters;
        uint256 minimal;
        uint256 voted;
        bytes32 value;
        bool closed;
    }

    mapping(bytes32 => VoteData) internal _votes;

    modifier notVoted(bytes32 code) {
        require(!hasVote(code, msg.sender), "Voting: duplicate");
        _;
    }

    function hasVote(bytes32 code, address account) public view returns (bool) {
        return _votes[code].voters[account];
    }

    function _closeVote(bytes32 code) internal {
        _votes[code].closed = true;
    }

    function _openVote(
        bytes32 code,
        uint256 minimal,
        bytes32 value
    ) internal {
        require(!isVoteExists(code), "Voting: already initialized");
        require(minimal > 0, "Voting: at least 1 vote needed");
        VoteData storage v = _votes[code];
        v.minimal = minimal;
        v.value = value;
        v.voted = 0;
    }

    function _vote(bytes32 code, bytes32 value) internal {
        _vote(code, msg.sender, value);
    }

    function _vote(
        bytes32 code,
        address voter,
        bytes32 value
    ) internal notVoted(code) {
        require(isVoteExists(code), "Voting: no voting");
        require(_votes[code].value == value, "Voting: wrong value");
        _votes[code].voted = _votes[code].voted + 1;
        _votes[code].voters[voter] = true;
    }

    function isVoteExists(bytes32 code) public view virtual returns (bool) {
        return !_votes[code].closed && _votes[code].minimal > 0;
    }

    function isVoteResolved(bytes32 code) public view virtual returns (bool) {
        return _votes[code].voted >= _votes[code].minimal;
    }
}
