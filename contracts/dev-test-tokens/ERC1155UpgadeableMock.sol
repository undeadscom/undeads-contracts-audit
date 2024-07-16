// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";

contract ERC1155UpgadeableMock is ERC1155SupplyUpgradeable {

    function initialize() initializer public {
        __ERC1155Supply_init();
        for (uint256 i; i < 10; ++i) {
            mint(i, 100);
        }
    }
    
    function mint(uint256 id_, uint256 amount_) public payable {
        _mint(msg.sender, id_, amount_, "");
    }
}