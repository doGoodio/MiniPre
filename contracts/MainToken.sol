pragma solidity ^0.4.15;


import "./MiniMeToken.sol";


/**
 * @title Aigang Token
 *
 * @dev Simple ERC20 Token, with sale logic
 * @dev IMPORTANT NOTE: do not use or deploy this contract as-is. It needs some changes to be
 * production ready.
 */
contract MainToken is MiniMeToken {
  /**
    * @dev Constructor
  */
  function MainToken(address _tokenFactory)
    MiniMeToken(
      _tokenFactory,
      0x0,                      // no parent token
      0,                        // no snapshot block number from parent
      "MainToken",                 // Token name
      18,                       // Decimals
      "MT",                    // Symbol
      true                      // Enable transfers
    ) {}

    function() payable {
      require(false);
    }
}
