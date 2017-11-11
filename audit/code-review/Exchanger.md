# Exchanger

Source file [../../contracts/Exchanger.sol](../../contracts/Exchanger.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

/*
  Copyright 2017, Klaus Hott (BlockChainLabs.nz)
  Copyright 2017, Jordi Baylina (Giveth)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/// @title Exchanger Contract
/// @author Klaus Hott
/// @dev This contract will be used to distribute AIX between APT holders.
///  APT token is not transferable, and we just keep an accounting between all tokens
///  deposited and the tokens collected.

// BK Next 4 Ok
import "./SafeMath.sol";
import "./MiniMeToken.sol";
import "./ERC20.sol";
import "./Contribution.sol";

// BK Ok
contract Exchanger is Controlled {
  // BK Ok
  using SafeMath for uint256;

  // BK Ok
  mapping (address => uint256) public collected;
  // BK Ok
  uint256 public totalCollected;
  // BK Ok
  MiniMeToken public apt;
  // BK Ok
  MiniMeToken public aix;
  // BK Ok
  Contribution public contribution;

  // BK Ok - Constructor
  function Exchanger(address _apt, address _aix, address _contribution) {
    // BK Ok
    apt = MiniMeToken(_apt);
    // BK Ok
    aix = MiniMeToken(_aix);
    // BK Ok
    contribution = Contribution(_contribution);
  }

  // BK Ok - Can only send 0 value tx
  function () public {
    // BK Ok
    collect();
  }

  /// @notice This method should be called by the APT holders to collect their
  ///  corresponding AIXs
  // BK Ok
  function collect() public {
    // APT sholder could collect AIX right after contribution started
    // BK Ok
    assert(getBlockTimestamp() > contribution.startTime());

    // BK Ok
    uint256 pre_sale_fixed_at = contribution.initializedBlock();

    // Get current APT ballance at contributions initialization-
    // BK Ok
    uint256 balance = apt.balanceOfAt(msg.sender, pre_sale_fixed_at);

    // total of aix to be distributed.
    // BK Ok
    uint256 total = totalCollected.add(aix.balanceOf(address(this)));

    // First calculate how much correspond to him
    // BK Ok
    uint256 amount = total.mul(balance).div(apt.totalSupplyAt(pre_sale_fixed_at));

    // And then subtract the amount already collected
    // BK Ok
    amount = amount.sub(collected[msg.sender]);

    // Notify the user that there are no tokens to exchange
    // BK Ok
    require(amount > 0);

    // BK Ok
    totalCollected = totalCollected.add(amount);
    // BK Ok
    collected[msg.sender] = collected[msg.sender].add(amount);

    // BK Ok
    assert(aix.transfer(msg.sender, amount));

    // BK Ok - Log event
    TokensCollected(msg.sender, amount);
  }

  //////////
  // Testing specific methods
  //////////

  /// @notice This function is overridden by the test Mocks.
  // BK Ok
  function getBlockNumber() internal constant returns (uint256) {
    // BK Ok
    return block.number;
  }

  /// @notice This function is overridden by the test Mocks.
  // BK Ok
  function getBlockTimestamp() internal constant returns (uint256) {
    // BK Ok
    return block.timestamp;
  }

  //////////
  // Safety Method
  //////////

  /// @notice This method can be used by the controller to extract mistakenly
  ///  sent tokens to this contract.
  /// @param _token The address of the token contract that you want to recover
  ///  set to 0 in case you want to extract ether.
  // BK Ok - Only controller can execute
  function claimTokens(address _token) public onlyController {
    // BK Ok
    assert(_token != address(aix));
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

  // BK Next 2 Ok - Events
  event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
  event TokensCollected(address indexed _holder, uint256 _amount);
}

```
