pragma solidity ^0.4.15;

import '../../contracts/usingOraclize.sol';

contract MockOraclizeAddrResolverI is OraclizeAddrResolverI {
  address addr;
  function getAddress() returns (address _addr) {
    return addr;
  }
  function setAddress(address _addr) {
    addr = _addr;
  }
}
