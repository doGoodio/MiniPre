pragma solidity ^0.4.15;

import '../../contracts/PreSale.sol';

contract MockPreSale is PreSale {
  uint256 public blockNumber;

  function MockPreSale(address _apt, address _place_holder)
    PreSale(_apt, _place_holder) {
    blockNumber = 0;
  }

  function getBlockNumber() internal constant returns (uint256) {
    return blockNumber;
  }

  function setBlockNumber(uint256 _blockNumber) public {
    blockNumber = _blockNumber;
  }
}

