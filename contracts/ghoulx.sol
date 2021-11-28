pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor () ERC20("GhoulX", "GhoulX") {
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }
}