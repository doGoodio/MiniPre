pragma solidity ^0.4.11;

import "./SafeMath.sol";
import "./ERC20.sol";
import "./MiniMeToken.sol";
import "./usingOraclize.sol";

contract GOODController is Controlled, TokenController, usingOraclize {
  using SafeMath for uint256;

  MiniMeToken good;
  bool once_finalTokenAllocation;           // Need this for final token allocation. Want to run only once
  uint public exchangeRate;                 // good = points * exchangeRate
  mapping (address => bool) userSyncState;  // Use this var to sync server and BC

  event ExchangedPointsForGood(address indexed user, uint indexed points, bool indexed userSyncState);

  function GOODController (address _good, uint _exchangeRate) {
    good = MiniMeToken(_good);
    exchangeRate = _exchangeRate;
  }

  function () { require(false); }

  // ======
  // ADMIN:
  // ======

  function finalTokenAllocation() onlyController {
    require(once_finalTokenAllocation == false);
    once_finalTokenAllocation = true;
    require(good.generateTokens(address(good), good.totalSupply() / 5));
  }

  /// @notice The owner of this contract can change the controller of the APT token
  ///  Please, be sure that the owner is a trusted agent or 0x0 address.
  /// @param _newController The address of the new controller
  function changeController(address _newController) onlyController {
    good.changeController(_newController);
    selfdestruct(controller); // Check security of this
  }

  function setExchangeRate (uint _exchangeRate) onlyController {
    exchangeRate = _exchangeRate;
  }

  // =====
  // USER:
  // =====

  // Should send $0.01 in eth and enought to cover __callback
  function exchangePointsForGood(uint gasPrice) payable {
    string memory url = strConcat('json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT', addr2Str(msg.sender), ').oracle.points');

    oraclize_setCustomGasPrice(gasPrice);
    oraclize_query("URL", url);
  }

  // =======
  // ORACLE:
  // =======

  // result : bool-address-pointsBalalance
  //          1-0xabcde5b340c80b5f1c0545c04c987b87310296ae-0x68898
  function __callback(bytes32 myid, string result) {
    bytes memory servData = bytes(result);
    address servSide_userAddr;
    bool servSide_userSyncState;
    uint servSide_userPoints;
    uint userGood;

    // Parse server code
    servSide_userSyncState = (servData[0] == '0') ? false : true;
    servSide_userAddr = address(fromHexString(result, 4, 40));
    servSide_userPoints = fromHexString(result, 47, servData.length - 47);
    userGood = servSide_userPoints.mul(exchangeRate);

    // Error check
    require(msg.sender == oraclize_cbAddress());                  // Oracle only
    require(servData.length > 46 && servData.length < 58);        // Error check server msg
    require(servSide_userPoints <= 10000000);                     // Error check points amount
    require(userSyncState[msg.sender] == servSide_userSyncState); // Are server/contract in sync?

    // State changes and events
    require(good.generateTokens(msg.sender, userGood));                
    require(good.destroyTokens(address(good), userGood));
    userSyncState[msg.sender] = !userSyncState[msg.sender];
    ExchangedPointsForGood(msg.sender, userGood, userSyncState[msg.sender]);
  }

  // =====
  // MISC:
  // =====

  // TokenController methods
  function proxyPayment(address) payable returns(bool) {
    require(false);
  }

  function onTransfer(address _from, address _to, uint _amount) returns(bool) {
    return true;
  }
  
  function onApprove(address _owner, address _spender, uint _amount) returns(bool) {
    return true;
  }


  function fromHexString(string s, uint start, uint len) constant returns (uint) {
    bytes memory bs = bytes(s);
    uint a;
    uint i;
    
    for (i = 0; i < len; i ++) {
      a = a + uint(uint8(bs[start + len - i])) * 2 ** i;
    }
    return a;
  }
 
  function addr2Str(address x) constant returns (string) {
    bytes memory s = new bytes(40);
    uint i;
    
    for (i = 0; i < 20; i++) {
      byte b  = byte(uint8(uint(x) / (2 ** (8 * (19 - i)))));
      byte hi = byte(uint8(b) / 16);
      byte lo = byte(uint8(b) - 16 * uint8(hi));
      s[2 * i]     = hi < 10 ? byte(uint8(hi) + 0x30) : byte(uint8(hi) + 0x57);
      s[2 * i + 1] = lo < 10 ? byte(uint8(lo) + 0x30) : byte(uint8(lo) + 0x57);
    }
    return string(s);
  }
}
