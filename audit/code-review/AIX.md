# AIX

Source file [../../contracts/AIX.sol](../../contracts/AIX.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;


// BK Ok
import "./MiniMeToken.sol";


/**
 * @title Aigang Token
 *
 * @dev Simple ERC20 Token, with sale logic
 * @dev IMPORTANT NOTE: do not use or deploy this contract as-is. It needs some changes to be
 * production ready.
 */
contract AIX is MiniMeToken {
  /**
    * @dev Constructor
  */
  // BK Ok - Constructor
  function AIX(address _tokenFactory)
    MiniMeToken(
      _tokenFactory,
      0x0,                      // no parent token
      0,                        // no snapshot block number from parent
      "Aigang",                 // Token name
      18,                       // Decimals
      "AIX",                    // Symbol
      true                      // Enable transfers
    ) {}

    // BK Ok - Reject ETH
    function() payable {
      // BK Ok
      require(false);
    }
}

```
