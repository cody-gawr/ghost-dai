// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IVaultMetaProvider {
    function getTokenURI(address vault_address, uint256 tokenId) external view returns (string memory);
    function getBaseURI() external view returns (string memory);
}