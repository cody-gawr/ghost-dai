
// contracts/liquidator.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./Stablecoin.sol";

contract liquidator is ReentrancyGuard {
    using SafeMath for uint256;

    address public admin;

    ERC20 ghostdai;

    Stablecoin vaultContract;

    uint256 public debtRatio;
    uint256 public gainRatio;

    uint256 private _minimumCollateralPercentage;

    mapping(address => uint256) public ethDebt;

    constructor(address _vaultContract, address _ghostdai) {
        admin = msg.sender;

        vaultContract = Stablecoin(_vaultContract);
        ghostdai = ERC20(_ghostdai);

        debtRatio = 2;
        gainRatio = 11;// /10 so 1.1

        _minimumCollateralPercentage = 150;
    }
    
    function setAdmin(address _admin) public {
        require(admin==msg.sender, "ser pls no hack");
        admin=_admin;
    }

    function setGainRatio(uint256 _gainRatio) public {
        require(admin==msg.sender, "ser pls no hack");
        gainRatio=_gainRatio;
    }

    function setDebtRatio(uint256 _debtRatio) public {
        require(admin==msg.sender, "ser pls no hack");
        debtRatio=_debtRatio;
    }

    function calculateCollateralProperties(uint256 collateral, uint256 debt) private view returns (uint256, uint256) {
        assert(vaultContract.getEthPriceSource() != 0);
        assert(vaultContract.getTokenPriceSource() != 0);

        uint256 collateralValue = collateral.mul(vaultContract.getEthPriceSource() );

        assert(collateralValue >= collateral);

        uint256 debtValue = debt.mul(vaultContract.getTokenPriceSource());

        assert(debtValue >= debt);

        uint256 collateralValueTimes100 = collateralValue.mul(100);

        assert(collateralValueTimes100 > collateralValue);

        return (collateralValueTimes100, debtValue);
    }

    function isValidCollateral(uint256 collateral, uint256 debt) private view returns (bool) {
        (uint256 collateralValueTimes100, uint256 debtValue) = calculateCollateralProperties(collateral, debt);

        uint256 collateralPercentage = collateralValueTimes100.div(debtValue);

        return collateralPercentage >= _minimumCollateralPercentage;
    }

    function getPaid() public nonReentrant {
        require(ethDebt[msg.sender]!=0, "Don't have anything for you.");
        uint256 amount = ethDebt[msg.sender];
        ethDebt[msg.sender]=0;
        payable(msg.sender).transfer(amount);
    }

    function checkLiquidation (uint256 _vaultId) public view {
        // address ogOwner = vaultContract.vaultOwner(_vaultId);

        (uint256 collateralValueTimes100, uint256 debtValue) = calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );

        uint256 collateralPercentage = collateralValueTimes100.div(debtValue);

        require(collateralPercentage < _minimumCollateralPercentage, "Vault is not below minimum collateral percentage");
    }

    function checkCost (uint256 _vaultId) public view returns(uint256){
        // address ogOwner = vaultContract.vaultOwner(_vaultId);

        (, uint256 debtValue) = calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );

        // uint256 collateralPercentage = collateralValueTimes100.div(debtValue);

        debtValue = debtValue.div(100000000);

        return debtValue.div(debtRatio);
    }


    function checkExtract (uint256 _vaultId) public view returns(uint256){
        address ogOwner = vaultContract.vaultOwner(_vaultId);

        (uint256 collateralValueTimes100, uint256 debtValue) = calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );

        uint256 collateralPercentage = collateralValueTimes100.div(debtValue);

        uint256 halfDebt = debtValue.div(debtRatio);

        uint256 ethExtract = halfDebt.mul(11).div(10).div(vaultContract.getEthPriceSource());

        return ethExtract;
    }

    function checkValid( uint256 _vaultId ) public view returns(bool, uint256, uint256, uint256) {

        (uint256 collateralValueTimes100, uint256 ogDebtValue) = calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );

        uint256 collateralPercentage = collateralValueTimes100.div(ogDebtValue);

        uint256 halfDebt = ogDebtValue.div(debtRatio);

        uint256 ethExtract = halfDebt.mul(11).div(10).div(vaultContract.getEthPriceSource());

        uint256 newCollateral = vaultContract.vaultCollateral(_vaultId).sub(ethExtract);

        halfDebt = halfDebt.div(100000000);

        return (isValidCollateral(newCollateral, halfDebt), newCollateral, halfDebt, ethExtract);
    }

    function checkCollat(uint256 _vaultId) public view returns(uint256, uint256) {
        return calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );
    }

    function checkGhostdaiBalance(address _address) public view returns (uint256){
        return vaultContract.balanceOf(_address);
    }

    function liquidateVault(uint256 _vaultId) public nonReentrant {

        uint256 ogBalance = vaultContract.balanceOf(address(this));

        vaultContract.transfer(admin, ogBalance);

        address ogOwner = vaultContract.vaultOwner(_vaultId);

        (uint256 collateralValueTimes100, uint256 ogDebtValue) = calculateCollateralProperties(vaultContract.vaultCollateral(_vaultId), vaultContract.vaultDebt(_vaultId) );

        uint256 collateralPercentage = collateralValueTimes100.div(ogDebtValue);

        uint256 ethExtract = checkExtract ( _vaultId);

        require(collateralPercentage < _minimumCollateralPercentage, "Vault is not below minimum collateral percentage");

        uint256 halfDebt = checkCost(_vaultId);


        vaultContract.transferFrom(msg.sender, address(this), halfDebt);
        vaultContract.buyRiskyVault(_vaultId);

        uint256 newBalance = vaultContract.balanceOf(address(this));

        vaultContract.payBackToken(_vaultId, newBalance);

        vaultContract.withdrawCollateral(_vaultId, ethExtract );

        vaultContract.transferVault(_vaultId, ogOwner);

        ethDebt[msg.sender] = ethDebt[msg.sender].add(ethExtract);
    }
}
