# Aigang Crowdsale Contract Audit

## Summary

[Aigang](https://aigang.network/) intends to run a crowdsale commencing in Nov 2017.

Bok Consulting Pty Ltd was commissioned to perform an audit on the Aigang's crowdsale and token Ethereum smart contract.

This audit has been conducted on Aigang's source code in commits
[8200037](https://github.com/AigangNetwork/aigang-crowdsale-contracts/commit/8200037ab9d51b70723a97449363aa8269adf9ff).

No potential vulnerabilities have been identified in the crowdsale and token contract.

There are some minor improvements as listed in the [Recommendations](#recommendations) section, but these are not important to implement.

<br />

### Mainnet Addresses

`TBA`

<br />

### Crowdsale Contract

Ethers contributed by participants to the crowdsale contract will result in AIX tokens being allocated to the participant's 
account in the token contract. The contributed ethers are immediately transferred to the crowdsale multisig wallet, reducing the 
risk of the loss of ethers in this bespoke smart contract.

<br />

### Token Contract

The *AIX* contract is built on the *MiniMeToken* token contract.

There are some changes in the recently finalised [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
that the *MiniMeToken* contract has not been updated for:

* `transfer(...)` and `transferFrom(...)` will return false instead of throwing an error
* `approve(...)` requires non-0 allowances to be set to 0 before being set to a different non-0 allowance

The *MiniMeToken* token contract stores snapshots of an account's token balance and the `totalSupply()` in history. One side effect of
this snapshot feature is that regular transfer operations consume a little more gas in transaction fees when compared to non-*MiniMeToken*
token contracts.

Additionally, this token contract implements the `approveAndCall(address _spender, uint256 _amount, bytes _extraData)` function.

<br />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

The following two recommendations are optional changes to the crowdsale and token contract:

* **LOW IMPORTANCE** The modifiers `Contribution.initialized()` and `Contribution.contributionOpen()` use the `assert(...)` keyword rather than the
  `require(...)` keyword. Using the `require(...)` keyword instead of `assert(...)` will result in lower gas cost for participants when there is 
  an error (e.g. sending ETH outside contribution period)

* **LOW IMPORTANCE** `MiniMeToken.approve(...)` has a check requiring non-zero approval limits to be set to 0 before being set to a different
  non-zero value. The recently finalised [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve)
  suggest that the contract should not enforce this requirement

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is that
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Aigang's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* This crowdsale contract has a low risk of having the ETH hacked or stolen, as any contributions by participants are immediately transferred
  to the crowdsale wallet.

<br />

<hr />

## Testing

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy APT token contract
* [x] Mint APT tokens
* [x] Deploy AIX token contract
* [x] Deploy Contribution contract
* [x] Set Contribution contract to be AIX controller
* [x] Deploy CommunityTokenHolder, DevTokensHolder, RemainderTokenHolder and Exchanger contracts
* [x] Initialise Contribution contract
* [x] Exchange Presale APT for AIX
* [x] Whitelist accounts for Contribution contract
* [x] Send contributions for whitelisted addresses and non-whitelisted address (expecting failure)
* [x] Finalise crowdsale and enable transfers
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` some tokens
* [x] Collect tokens from CommunityTokenHolder and DevTokensHolder (with modified withdrawal schedule)

<br />

<hr />

## Code Review

* [x] [code-review/SafeMath.md](code-review/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review/ERC20.md](code-review/ERC20.md)
  * [x] contract ERC20
* [x] [code-review/AIX.md](code-review/AIX.md)
  * [x] contract AIX is MiniMeToken
* [x] [code-review/CommunityTokenHolder.md](code-review/CommunityTokenHolder.md)
  * [x] contract CommunityTokenHolder is Controlled
* [x] [code-review/DevTokensHolder.md](code-review/DevTokensHolder.md)
  * [x] contract DevTokensHolder is Controlled
* [x] [code-review/RemainderTokenHolder.md](code-review/RemainderTokenHolder.md)
  * [x] contract RemainderTokenHolder is Controlled
* [x] [code-review/Exchanger.md](code-review/Exchanger.md)
  * [x] contract Exchanger is Controlled
* [x] [code-review/Contribution.md](code-review/Contribution.md)
  * [x] contract Contribution is Controlled, TokenController
* [x] [code-review/MiniMeToken.md](code-review/MiniMeToken.md)
  * [x] contract TokenController
  * [x] contract Controlled
  * [x] contract ApproveAndCallFallBack 
  * [x] contract MiniMeToken is Controlled
  * [x] contract MiniMeTokenFactory

<br />

### Presale Contracts

The Presale contracts were audited in [Aigang Presale audit](https://github.com/bokkypoobah/AigangPresaleContractAudit/tree/master/audit).

Following are the main components of the Presale contracts:

* [../contracts/APT.sol](../contracts/APT.sol) is exactly the same as in the Presale version and has been deployed to
  [0x23ae3c5b39b12f0693e05435eeaa1e51d8c61530](https://etherscan.io/address/0x23ae3c5b39b12f0693e05435eeaa1e51d8c61530#code).
* [../contracts/PlaceHolder.sol](../contracts/PlaceHolder.sol) is slightly different to the Presale version. The differences are insignificant:

  ```diff
  $ diff PlaceHolder.sol ../../AigangPresaleContractAudit/contracts/PlaceHolder.sol 
  3d2
  < import './ERC20.sol';
  ```

* [../contracts/PreSale.sol](../contracts/PreSale.sol) is exactly the same as in the Presale version. The Presale version has been deployed to
  [0x2d68a9a9dd9fcffb070ea1d8218c67863bfc55ff](https://etherscan.io/address/0x2d68a9a9dd9fcffb070ea1d8218c67863bfc55ff#code).

<br />

### Not Reviewed

* [../contracts/MultiSigWallet.sol](../contracts/MultiSigWallet.sol)
  The ConsenSys/Gnosis multisig wallet is the same as used in the [Aigang Presale](https://github.com/bokkypoobah/AigangPresaleContractAudit/blob/master/contracts/MultiSigWallet.sol).

  The only difference is in the Solidity version number:

  ```diff
  $ diff MultiSigWallet.sol ../../AigangPresaleContractAudit/contracts/MultiSigWallet.sol 
  1c1
  < pragma solidity 0.4.15;
  ---
  > pragma solidity 0.4.11;
  ```

* [../contracts/Migrations.sol](../contracts/Migrations.sol)

  This is a part of the Truffles testing framework

<br />

### Differences In MiniMeToken.sol Between The Aigang Presale And Crowdsale Contracts

There are some small changes to the MiniMeToken contract between the Presale and Crowdsale versions. These changes seem to have been made to
account for the upgrade in the compiler version.

```diff
$ diff -w ../../AigangPresaleContractAudit/contracts/MiniMeToken.sol MiniMeToken.sol 
1,3c1
< pragma solidity ^0.4.11;
< 
< import "./ERC20.sol";
---
> pragma solidity ^0.4.15;
59c57
<     modifier onlyController { if (msg.sender != controller) throw; _; }
---
>     modifier onlyController { require(msg.sender == controller); _; }
173c171
<         if (!transfersEnabled) throw;
---
>         require(transfersEnabled);
191c189
<             if (!transfersEnabled) throw;
---
>             require(transfersEnabled);
213c211
<            if (parentSnapShotBlock >= block.number) throw;
---
>            require(parentSnapShotBlock < block.number);
216c214
<            if ((_to == 0) || (_to == address(this))) throw;
---
>            require((_to != 0) && (_to != address(this)));
227,228c225
<                if (!TokenController(controller).onTransfer(_from, _to, _amount))
<                throw;
---
>                require(TokenController(controller).onTransfer(_from, _to, _amount));
238c235
<            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
---
>            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
260c257
<         if (!transfersEnabled) throw;
---
>         require(transfersEnabled);
266c263
<         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
---
>         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
270,271c267
<             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
<                 throw;
---
>             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
298c294
<         if (!approve(_spender, _amount)) throw;
---
>         require(approve(_spender, _amount));
420,421c416,419
<         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
<         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
---
>         uint curTotalSupply = totalSupply();
>         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
>         uint previousBalanceTo = balanceOf(_owner);
>         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
423,424d420
<         var previousBalanceTo = balanceOf(_owner);
<         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
437,438c433,436
<         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
<         if (curTotalSupply < _amount) throw;
---
>         uint curTotalSupply = totalSupply();
>         require(curTotalSupply >= _amount);
>         uint previousBalanceFrom = balanceOf(_owner);
>         require(previousBalanceFrom >= _amount);
440,441d437
<         var previousBalanceFrom = balanceOf(_owner);
<         if (previousBalanceFrom < _amount) throw;
497c493
<                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
---
>                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
501c497
<                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
---
>                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
527,532c523,524
<         if (isContract(controller)) {
<             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
<                 throw;
<         } else {
<             throw;
<         }
---
>         require(isContract(controller));
>         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
543c535
<     function claimTokens(address _token) public onlyController {
---
>     function claimTokens(address _token) onlyController {
549,550c541,542
<       ERC20 token = ERC20(_token);
<       uint256 balance = token.balanceOf(this);
---
>         MiniMeToken token = MiniMeToken(_token);
>         uint balance = token.balanceOf(this);
558c550
<     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
---
>     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
```

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Aigang - Nov 12 2017. The MIT Licence.