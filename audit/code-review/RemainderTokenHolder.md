# RemainderTokenHolder

Source file [../../contracts/RemainderTokenHolder.sol](../../contracts/RemainderTokenHolder.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 3 Ok
import "./Contribution.sol";
import "./SafeMath.sol";
import "./ERC20.sol";

// BK Ok
contract RemainderTokenHolder is Controlled {
  // BK Ok
  using SafeMath for uint256;

  // BK Ok
  Contribution public contribution;
  // BK Ok
  ERC20 public aix;

  // BK Ok - Constructor
  function RemainderTokenHolder(address _controller, address _contribution, address _aix) {
    // BK Ok
    controller = _controller;
    // BK Ok
    contribution = Contribution(_contribution);
    // BK Ok
    aix = ERC20(_aix);
  }

  /// @notice The Dev (Owner) will call this method to extract the tokens
  // BK Ok - Only controller can execute
  function collectTokens() public onlyController {
    // BK Ok
    uint256 finalizedTime = contribution.finalizedTime();
    // BK Ok
    require(finalizedTime > 0 && getTime() > finalizedTime.add(1 years));

    // BK Ok
    uint256 balance = aix.balanceOf(address(this));
    // BK Ok
    require(aix.transfer(controller, balance));
    // BK Ok - Log event
    TokensWithdrawn(controller, balance);
  }

  // BK NOTE - Could be marked constant
  // BK Ok
  function getTime() internal returns (uint256) {
    // BK Ok
    return now;
  }

  //////////
  // Safety Methods
  //////////

  /// @notice This method can be used by the controller to extract mistakenly
  ///  sent tokens to this contract.
  /// @param _token The address of the token contract that you want to recover
  ///  set to 0 in case you want to extract ether.
  // BK Ok - Only controller can execute
  function claimTokens(address _token) public onlyController {
    // BK Ok
    require(_token != address(aix));
    // BK Ok - Claiming ETH
    if (_token == 0x0) {
      // BK Ok
      controller.transfer(this.balance);
      // BK Ok
      return;
    }

    // BK Ok
    ERC20 token = ERC20(_token);
    // BK Ok
    uint256 balance = token.balanceOf(this);
    // BK Ok
    token.transfer(controller, balance);
    // BK Ok - Log event
    ClaimedTokens(_token, controller, balance);
  }

  // BK Next 2 Ok - Events
  event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
  event TokensWithdrawn(address indexed _holder, uint256 _amount);
}

```
