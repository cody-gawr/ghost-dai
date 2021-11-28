
// contracts/MyVaultNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract VaultNFTv2 is ERC721URIStorage {
            
    constructor(string memory name, string memory symbol) public ERC721(name, symbol) {}

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        revert("transfer: disabled");
    }
}