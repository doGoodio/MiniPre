# CommunityTokenHolder

Source file [../../contracts/CommunityTokenHolder.sol](../../contracts/CommunityTokenHolder.sol).

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
contract CommunityTokenHolder is Controlled {
  // BK Ok
  using SafeMath for uint256;

  // BK Ok
  uint256 public collectedTokens;
  // BK Ok
  Contribution public contribution;
  // BK Ok
  ERC20 public aix;

  // BK Ok - Constructor
  function CommunityTokenHolder(address _controller, address _contribution, address _aix) {
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
    uint256 balance = aix.balanceOf(address(this));
    // BK Ok
    uint256 total = collectedTokens.add(balance);
    // This wallet will get a 29% of the total tokens.
    // since scaling 10 of 29 to a percentage looks horrible (34,482758620689655),
    // I'll use a fraction.
    // BK Ok
    uint256 canExtract = total.mul(extractableFraction()).div(29);

    // BK Ok
    canExtract = canExtract.sub(collectedTokens);

    // BK Ok
    if (canExtract > balance) {
      // BK Ok
      canExtract = balance;
    }

    // BK Ok
    collectedTokens = collectedTokens.add(canExtract);
    // BK Ok
    require(aix.transfer(controller, canExtract));

    // BK Ok - Log event
    TokensWithdrawn(controller, canExtract);
  }

  // BK Ok - Constant function
  function extractableFraction() constant returns (uint256) {
    // BK Ok
    uint256 finalizedTime = contribution.finalizedTime();
    // BK Ok
    require(finalizedTime > 0);

    // BK Ok
    uint256 timePassed = getTime().sub(finalizedTime);

    // BK Ok
    if (timePassed > months(12)) {
      // after a year the full 29% of the total Supply can be collected
      // BK Ok
      return 29;
    // BK Ok
    } else {
      // before a year only a 10% of the total Supply can be collected
      return 10;
    }
  }

  // BK NOTE - Could be marked constant
  // BK Ok
  function months(uint256 m) internal returns (uint256) {
    // BK Ok
    return m.mul(30 days);
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
    // BK Ok - Claim ETH
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

  // BK Ok - Events
  event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
  event TokensWithdrawn(address indexed _holder, uint256 _amount);
}

```
