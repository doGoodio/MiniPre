* Parameters
  ** contracts/MainToken.sol
    *** Token Name
    *** Token Symbol
  ** migrations/2_deploy_contracts.js
  ** contracts/PreSale.sol
    *** uint256 constant public exchangeRate = 1; // ETH-APT exchange rate
    *** uint256 constant public investor_bonus = 25;
  ** contracts/GoodToken.sol
    *** require(orc_userPointsAmnt <= 10000000);
    *** finalTokenAllocation -generation of tokens (good, team, etc)
* Final checks
  ** Upload code on ethscan
  ** read thru bokky's notes https://github.com/bokkypoobah/AigangPresaleContractAudit/tree/master/audit
* Todo
  ** Allocate good tokens before points exchange
* Notes
  ** User names can be matched to blockhain addresses by querying server and matching the two by points count
* Testing
  ** Must test oraclize on public blockchain to access website
```shell
$ ganache-cli -i 42 -a 10 -m "undo motor ensure settle magic manual enable wealth bottom uphold mosquito genuine"
```