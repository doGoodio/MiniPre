var MiniMeTokenFactory = artifacts.require("MiniMeTokenFactory");
var MainToken = artifacts.require("MainToken");
var PlaceHolder = artifacts.require("PlaceHolder");
var SafeMath = artifacts.require("SafeMath");
var PreSale = artifacts.require("PreSale");

// function latestBlockNumber () { return web3.eth.getBlock('latest').number; }

const BigNumber = web3.BigNumber;

const duration = {
  seconds: function(val) { return val },
  minutes: function(val) { return val * this.seconds(60) },
  hours:   function(val) { return val * this.minutes(60) },
  days:    function(val) { return val * this.hours(24) },
  weeks:   function(val) { return val * this.days(7) },
  years:   function(val) { return val * this.days(365) }
};

module.exports = function (deployer, chain, accounts) {
  return deployer.deploy(SafeMath).then(async () => {

    // Parameters
    const timeFromStart = duration.minutes(10);                // seconds
    const presaleDuration = duration.minutes(40);              // seconds
    const walletAddress = '0x7a4baa345548aa30f11ffa61d2a7a685ea4537a9';
    const presaleSupplyCap = 0.5;                              // token major unit (like ether)
    const minimumInvestment = 0.2;                             // ether
    const ethereumBlockDuration = 14;                          // seconds
    const latestBlock = 4960783;                               // latest block number on respective network

    // Deployment
    const startBlock = latestBlock + Math.floor(timeFromStart / ethereumBlockDuration);
    const endBlock = startBlock + Math.floor(presaleDuration / ethereumBlockDuration);
    const presaleSupplyCapQuanta = new BigNumber(10**18)       // token quantum unit (like wei)
          * new BigNumber(presaleSupplyCap);
    const weiMinimumInvestment = new BigNumber(10**18)         // wei
          * new BigNumber(minimumInvestment);
    console.log('Start block- ' + startBlock);
    console.log('End block- '   + endBlock);

    await deployer.deploy(MiniMeTokenFactory);
    await deployer.deploy(MainToken, MiniMeTokenFactory.address);
    await deployer.deploy(PlaceHolder, MainToken.address);
    deployer.link(SafeMath, PreSale);
    await deployer.deploy(PreSale, MainToken.address, PlaceHolder.address);

    const mt = await MainToken.deployed();
    const ps = await PreSale.deployed();

    await mt.changeController(PreSale.address)
    await ps.initialize(
      walletAddress,
      presaleSupplyCapQuanta,
      weiMinimumInvestment,
      startBlock,
      endBlock
    ); 
  })
};


