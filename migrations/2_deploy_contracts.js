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
    const timeFromStart = duration.hours(8);                // seconds
    const presaleDuration = duration.days(38);              // seconds
    const walletAddress = '0x820A5C614847Fb92e91f2E061a85A315d43dC18e';
    const presaleSupplyCap = 4750000;                              // TOKENS, major unit (like ether, not wei)
    const minimumInvestment = 22;                           // ether
    const ethereumBlockDuration = 14;                          // seconds
    const latestBlock = 1371981;                               // latest block number on respective network

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
    const mmtf = await MiniMeTokenFactory.deployed();
    
    await deployer.deploy(MainToken, mmtf.address);
    const mt = await MainToken.deployed();
   
    await deployer.deploy(PlaceHolder, mt.address);
    const ph = await PlaceHolder.deployed();
    
    await deployer.link(SafeMath, PreSale);
    
    await deployer.deploy(PreSale, mt.address, ph.address);
    const ps = await PreSale.deployed();

    await mt.changeController(ps.address)
    await ps.initialize(
      walletAddress,
      presaleSupplyCapQuanta,
      weiMinimumInvestment,
      startBlock,
      endBlock
    ); 
  })
};


