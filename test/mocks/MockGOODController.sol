pragma solidity ^0.4.15;

import '../../contracts/GOODController.sol';

contract MockGOODController is GOODController {
  function MockGOODController(address _good, uint _exchangeRate)
    GOODController (_good, _exchangeRate) {
  }

  function setOAR(address oar) {
    OAR = OraclizeAddrResolverI(oar);
  }
}

