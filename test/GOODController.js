// var events = require('./../app/javascripts/events');
// var util = require('./../app/javascripts/util');

var MiniMeTokenFactory = artifacts.require('MiniMeTokenFactory.sol');
var DoGood = artifacts.require('MainToken.sol');
var PreSale = artifacts.require('MockPreSale.sol');
var PlaceHolder = artifacts.require('PlaceHolder.sol');
var GOODController = artifacts.require('MockGOODController.sol');
var OraclizeI = artifacts.require('MockOraclizeI.sol');
var OraclizeAddrResolverI = artifacts.require('MockOraclizeAddrResolverI.sol');

var chai = require('chai')
const assert = require("chai").use(require("chai-as-promised")).assert;
const BigNumber = web3.BigNumber;

//************************************************
// Tests
contract('GOODController', function (accounts) {

  const account1 = accounts[0];
  const account2 = accounts[1];
  const account3 = accounts[2];
  const walletAddress = accounts[3];
  const oracleCBAddress = accounts[4];

  var good;
  var presale;
  var placeholder;
  var goodcontroller;
  var oraclizeI;
  var oar;

  describe('test 1', async () => {
    beforeEach(async () => {
      // OraclizeAddrResolverI - OAR
      // OraclizeI             - oraclize
      const presaleSupplyCap = new BigNumber(4750000);                              // TOKENS, major unit (like ether, not wei)
      const minimumInvestment = new BigNumber(22);                           // ether
      const startBlock = new BigNumber(10);
      const endBlock = new BigNumber(30);
      const pnts2GoodRate = new BigNumber(1000);

      const presaleSupplyCapQuanta = new BigNumber(10**18) * new BigNumber(presaleSupplyCap);
      const weiMinimumInvestment   = new BigNumber(10**18) * new BigNumber(minimumInvestment);

      const mmtf  = await MiniMeTokenFactory.new();
      good        = await DoGood.new(mmtf.address, {from: account1});
      placeholder = await PlaceHolder.new(good.address, {from: account1});
      presale     = await PreSale.new(good.address, placeholder.address, {from: account1}); 
      goodcontroller = await GOODController.new(good.address, pnts2GoodRate, {from: account1});
      
      // Test code only
      oraclizeI   = await OraclizeI.new(oracleCBAddress, {from: account1});
      oar         = await OraclizeAddrResolverI.new();
      await oar.setAddress(oraclizeI.address);
      await goodcontroller.setOAR(oar.address, {from: account1}); 
      // --------------

      await good.changeController(presale.address, {from: account1});

      await presale.setBlockNumber(5);
      await presale.initialize(walletAddress, presaleSupplyCapQuanta, weiMinimumInvestment, startBlock, endBlock, {from: account1}); 

      await presale.setBlockNumber(45);
      await presale.finalize({from: account1});

      await placeholder.changeAPTController(goodcontroller.address, {from: account1});
      await goodcontroller.finalTokenAllocation({from: account1});
    });

    it('fails on fallback', async () => {
      await assert.throws(() => 
                          web3.eth.sendTransaction({from:account1, to:goodcontroller.address, value: new BigNumber(100)})
                         );  
    });

    it('does final token allocation only once', async () => {
      // 2nd time
      assert.isRejected(goodcontroller.finalTokenAllocation({from: account1}));
    });

    it('changes token controller and self destructs', async () => {
      goodcontroller.changeController(placeholder.address);
      // contract self desturcts
      var expected = 0x0;
      var actual   = await goodcontroller.controller();
      assert.equal(expected, actual);     

      // New token controller is placeholder
      var expected = placeholder.address;
      var actual = await good.controller();
      assert.equal(expected, actual);     
    });

    it('sets the exchange rate', async () => {
      var actual = await goodcontroller.exchangeRate();
      assert.equal(actual.toNumber(), (new BigNumber(1000)).toNumber());

      var expected = new BigNumber(17);
      await goodcontroller.setExchangeRate(expected);
      var actual = await goodcontroller.exchangeRate();

      assert.equal(actual.toNumber(), expected.toNumber());
    });

    it('exchanges points for good', async () => {
      const amnt = new BigNumber(1 * 10 ** 18);
      const oracleGasPrice = new BigNumber(20 * 10 ** 9);

      await goodcontroller.exchangePointsForGood(oracleGasPrice, {from: account2, value: amnt});
      
      // Test converted to good
      await goodcontroller.__callback(0, '0-' + account2 + '-0x64', {from: oracleCBAddress});
//      var actual = await good.balanceOf(account2);
//      assert.equal(actual.toNumber(), (new BigNumber(100)).toNumber());

/*
      // Test that it blocks
      await goodcontroller.__callback(0, '0-' + account2 + '-0x64', {from: oracleCBAddress});
      var actual = await good.balanceOf(account2);
      assert.equal(actual.toNumber(), (new BigNumber(100)).toNumber());

      // Test it goes through
      await goodcontroller.__callback(0, '1-' + account2 + '-0x64', {from: oracleCBAddress});
      var actual = await good.balanceOf(account2);
      assert.equal(actual.toNumber(), (new BigNumber(200)).toNumber());

      // Test it blocks
      await goodcontroller.__callback(0, '1-' + account2 + '-0x64', {from: oracleCBAddress});
      var actual = await good.balanceOf(account2);
      assert.equal(actual.toNumber(), (new BigNumber(200)).toNumber());
*/
    });
/*
    it('parses data correctly?', async () => {
      //assert.equal(0,3);
      //function fromHexString(string s, uint start, uint len) constant returns (uint) {
      //function addr2Str(address x) constant returns (string) {

    });
    */
  });
});
