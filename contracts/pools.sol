pragma solidity ^0.8.0;



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquidityPool {
  using SafeMath for uint256;

  ERC20 public eth;
  ERC20 public dai;

  constructor(ERC20 _eth, ERC20 _dai) public {
    eth = _eth;
    dai = _dai;
  }

  function deposit(ERC20 token, uint256 amount) public {
    require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed.");
  }

  function withdraw(ERC20 token, uint256 amount) public {
    token.transfer(msg.sender, amount);
  }

  function getEthToDaiPrice() public view returns (uint256) {
    uint256 ethBalance = eth.balanceOf(address(this));
    uint256 daiBalance = dai.balanceOf(address(this));
    return daiBalance.mul(1 ether).div(ethBalance);
  }

  function exchange(ERC20 fromToken, uint256 fromAmount, ERC20 toToken) public {
    require(fromToken == eth || fromToken == dai, "Invalid fromToken.");
    require(toToken == eth || toToken == dai, "Invalid toToken.");

    uint256 fromTokenBalance = fromToken.balanceOf(address(this));
    uint256 toTokenBalance = toToken.balanceOf(address(this));
    require(fromTokenBalance >= fromAmount, "Insufficient balance.");

    uint256 exchangeRate = getEthToDaiPrice();
    uint256 toAmount;
    if (fromToken == eth) {
      toAmount = fromAmount.mul(exchangeRate).div(1 ether);
    } else {
      toAmount = fromAmount.mul(1 ether).div(exchangeRate);
    }

    fromToken.transferFrom(msg.sender, address(this), fromAmount);
    toToken.transfer(msg.sender, toAmount);
  }
}
