// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

contract ERC721UpgradeableMock is ERC721EnumerableUpgradeable {

    function initialize() initializer public {
        __ERC721_init("ERC721UpgradeableMock", "EU721");
        for (uint256 i; i < 100; ++i) {
            mint();
        }
    }
    
    function mint() public payable {
        uint supply = totalSupply();
        _safeMint(msg.sender, supply + 1);
    }
}