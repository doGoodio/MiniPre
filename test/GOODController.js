// var events = require('./../app/javascripts/events');
// var util = require('./../app/javascripts/util');

var MiniMeTokenFactory = artifacts.require('MiniMeTokenFactory.sol');
var DoGood = artifacts.require('MainToken.sol');
var PreSale = artifacts.require('MockPreSale.sol');
var PlaceHolder = artifacts.require('PlaceHolder.sol');
var GOODController = artifacts.require('GOODController.sol');

const assert = require("chai").assert;
const BigNumber = web3.BigNumber;

//************************************************
// Tests
contract('GOODController', function (accounts) {

  const account1 = accounts[0];
  const account2 = accounts[1];
  const account3 = accounts[2];
  const walletAddress = accounts[3];

  var good;
  var presale;
  var placeholder;
  var goodcontroller;

  describe('blah', async () => {
    beforeEach(async () => {
      const presaleSupplyCap = 4750000;                              // TOKENS, major unit (like ether, not wei)
      const minimumInvestment = 22;                           // ether
      const startBlock = 10;
      const endBlock = 30;
      const pnts2GoodRate = 1000;

      // Deployment
      const presaleSupplyCapQuanta = new BigNumber(10**18) * new BigNumber(presaleSupplyCap);
      const weiMinimumInvestment   = new BigNumber(10**18) * new BigNumber(minimumInvestment);

      // await deployer.deploy(SafeMath);

      const mmtf = await MiniMeTokenFactory.new();

      good = await DoGood.new(mmtf.address);
      placeholder = await PlaceHolder.new(good.address);

      // await deployer.link(SafeMath, PreSale);
      presale = await PreSale.new(good.address, placeholder.address);

      await good.changeController(presale.address);
      await presale.initialize(walletAddress, presaleSupplyCapQuanta, weiMinimumInvestment, startBlock, endBlock); 

      await presale.setBlockNumber(45);
      await presale.finalize();

      // await deployer.link(SafeMath, GOODController);
      goodcontroller = await GOODController.new(good.address, pnts2GoodRate);
      await placeholder.changeAPTController(goodcontroller.address);
    });

    it('setExchangeRate', async () => {
      const expected = new BigNumber(17);
      await goodController.setExchangeRate(expected);
      const actual = await goodController.exchangeRate();
      assert.equal(actual.toNumber(), expected.toNumber());
    });

  });



});



