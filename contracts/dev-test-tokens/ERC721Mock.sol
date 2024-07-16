// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ERC721Mock is ERC721Enumerable {

    constructor() ERC721("ERC721Mock", "E721") {
        for (uint256 i; i < 100; ++i) {
            mint();
        }
    }
    
    function mint() public payable {
        uint supply = totalSupply();
        _safeMint(msg.sender, supply + 1);
    }
}