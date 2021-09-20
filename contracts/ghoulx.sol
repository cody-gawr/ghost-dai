pragma solidity 0.5.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor () ERC20("GhoulX", "GhoulX") public {
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }
}