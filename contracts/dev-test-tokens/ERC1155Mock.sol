// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract ERC1155Mock is ERC1155Supply {

    constructor() ERC1155("") {
        for (uint256 i; i < 10; ++i) {
            mint(i, 100);
        }
    }
    
    function mint(uint256 id_, uint256 amount_) public payable {
        _mint(msg.sender, id_, amount_, "");
    }
}