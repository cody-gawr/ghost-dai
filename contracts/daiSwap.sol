
// contracts/daiSwap.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract daiSwap is ReentrancyGuard {
    using SafeMath for uint256;

    address public admin;

    ERC20 dai;
    ERC20 ghostdai;

    uint256 public daiRate;
    uint256 public ghostdaiRate;
    
    constructor(address _dai, address _ghostdai) public {
        admin = msg.sender;
        dai = ERC20(_dai);
        ghostdai = ERC20(_ghostdai);
        ghostdaiRate = 98;
        daiRate = 102;
    }

    function setDAIRatePerGhostdai(uint256 _rate) public {
        require(admin==msg.sender, "ser pls no hack");
        daiRate = _rate;
    }

    function setGhostdaiRatePerDAI(uint256 _rate) public {
        require(admin==msg.sender, "ser pls no hack");
        ghostdaiRate = _rate;
    }
    
    function setAdmin(address _admin) public {
        require(admin==msg.sender, "ser pls no hack");
        admin=_admin;
    }

    function transferToken(address token, uint256 amountToken) public {
        require(admin==msg.sender, "ser pls no hack");
        ERC20(token).transfer(admin, amountToken);
    }

    // this returns the reserves in the contract

    function getReserves() public view returns(uint256, uint256) {
        return ( ghostdai.balanceOf(address(this)), dai.balanceOf(address(this)) );
    }
    
    // the user must approve the balance so the contract can take it out of the user's account
    // else this will fail.

    function swapFrom(uint256 amount) public nonReentrant {
        require(amount!=0, "swapFrom: invalid amount");
        require(ghostdai.balanceOf(address(this))!=0, "swapFrom: Not enough ghostDai in reserves");

        // for every 1.02 dai we get 1.00 ghostdai
            // 1020000 we get 1000000000000000000

        uint256 amountToSend = amount.mul(daiRate).div(100);

        require(ghostdai.balanceOf(address(this)) >= amountToSend, "swapFrom: Not enough ghostDai in reserves");

        // Transfer DAI to contract
        dai.transferFrom(msg.sender, address(this), amount);
        // Transfer ghostDai to sender
        ghostdai.transfer(msg.sender, amountToSend);
    }

    function swapTo(uint256 amount) public nonReentrant {
        require(amount!=0, "swapTo: invalid amount");
        require(dai.balanceOf(address(this))!=0, "swapTo: Not enough DAI in reserves");
        // for every 1.00 ghostdai we get 0.98 dai
            // 1000000000000000000 we get 980000 (bc decimals)
        uint256 amountToSend = amount.mul(ghostdaiRate).div(100);

        require(dai.balanceOf(address(this)) >= amountToSend, "swapTo: Not enough ghostDai in reserves");

        // Tranfer tokens from sender to this contract
        ghostdai .transferFrom(msg.sender, address(this), amount);
        // Transfer amount minus fees to sender
        dai.transfer(msg.sender, amountToSend);
    }
}