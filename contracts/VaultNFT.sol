
// contracts/MyVaultNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VaultNFT is ERC721URIStorage {
        
    address admin;
    
    constructor() public ERC721("ghostDai Vault", "GDV") {
        admin = msg.sender;
    }
    
    function setAdmin(address _admin) public {
        require(admin==msg.sender);
        admin=_admin;
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        
    }
    
    function burn(uint256 tokenId) public {
        require(
            msg.sender == admin,
            "Token: account does not have burn role"
        );
        _burn(tokenId);
    }
    
    function mint(address to, uint256 tokenId) public {
        require(
            msg.sender == admin,
            "Token: account does not have minter role"
        );
        _mint(to, tokenId);
    }
}