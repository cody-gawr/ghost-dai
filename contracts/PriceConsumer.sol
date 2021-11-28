// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PriceConsumer is Ownable {
    mapping(address => address) public tokenPriceFeedMapping;

    function setPriceFeedContract(address _token, address _priceFeed)
        public
        onlyOwner
    {
        tokenPriceFeedMapping[_token] = _priceFeed;
    }

    /// @notice Get the ratio of _token0 to _token1
    /// @param _token0 The address of _token0
    /// @param _token1 The address of _token1
    /// @param _decimals The decimals of a result
    /// @return The ration of a price of _token0 to a price of _token1 in USD
    function getRatio(address _token0, address _token1, uint8 _decimals)
        public
        view
        returns (int256)
    {
        require(_decimals > uint8(0) && _decimals <= uint8(18), "Invalid _decimals");
        address priceFeedAddress0 = tokenPriceFeedMapping[_token0];
        address priceFeedAddress1 = tokenPriceFeedMapping[_token1];
        int256 decimals = int256(10 ** uint256(_decimals));

        uint8 decimals0 = AggregatorV3Interface(priceFeedAddress0).decimals();
        uint8 decimals1 = AggregatorV3Interface(priceFeedAddress1).decimals();
        (, int256 price0, , , ) = AggregatorV3Interface(priceFeedAddress0).latestRoundData();
        (, int256 price1, , , ) = AggregatorV3Interface(priceFeedAddress1).latestRoundData();
        price0 = scalePrice(price0, decimals0, _decimals);
        price1 = scalePrice(price1, decimals1, _decimals);

        return price0 * decimals / price1;
    }

    function scalePrice(int256 _price, uint8 _priceDecimals, uint8 _decimals)
        internal
        pure
        returns (int256)
    {
        if (_priceDecimals < _decimals) {
            return _price * int256(10 ** uint256(_decimals - _priceDecimals));
        } else if (_priceDecimals > _decimals) {
            return _price / int256(10 ** uint256(_priceDecimals - _decimals));
        }
        return _price;
    }
}