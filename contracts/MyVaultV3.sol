// contracts/MyVaultNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./interfaces/IVaultMetaProvider.sol";
import "./interfaces/IVaultMetaRegistry.sol";


contract VaultNFTv3 is ERC721URIStorage {

    address public _meta;
    string public base;

    constructor(string memory name, string memory symbol, address meta, string memory baseURI) ERC721(name, symbol)
    {
        _meta = meta;
        base=baseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId));

        IVaultMetaRegistry registry = IVaultMetaRegistry(_meta);
        IVaultMetaProvider provider = IVaultMetaProvider(registry.getMetaProvider(address(this)));

        return bytes(base).length > 0 ? string(abi.encodePacked(base, provider.getTokenURI(address(this), tokenId))) : "";
    }
}