pragma solidity ^0.4.15;

import '../../contracts/usingOraclize.sol';

// OraclizeAddrResolverI OAR
// OraclizeI oraclize

contract MockOraclizeI is OraclizeI {
  uint gasPrice = 20000000000;

  function MockOraclize (address cbAddr) {
    cbAddress = cbAddr;
  }

  function setCustomGasPrice(uint _gasPrice) {
    gasPrice = _gasPrice;
    return;
  }

  function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id) {
    bytes3 x;
    return x;
  }

  function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id)
  {bytes32 x; return x;}
  function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id)
  {bytes32 x; return x;}
  function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id)
  {bytes32 x; return x;}
  function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id)
  {bytes32 x; return x;}
  function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id)
  {bytes32 x; return x;}
  function getPrice(string _datasource) returns (uint _dsprice)
  {return 0;}
  function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice)
  {return 0;}
  function useCoupon(string _coupon)
  {return;}
  function setProofType(byte _proofType)
  {return;}
  function setConfig(bytes32 _config)
  {return;}
  function randomDS_getSessionPubKeyHash() returns(bytes32)
  {bytes32 x; return x;}
}
