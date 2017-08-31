const Contribution = artifacts.require("./Contribution.sol");
const MockContribution = artifacts.require("./MockContribution.sol");
const Aix = artifacts.require("./AIX.sol");
const MiniMeTokenFactory = artifacts.require("MiniMeTokenFactory");
const assert = require("chai").assert;

function getTime() {
  return Math.floor(Date.now() / 1000);
}

contract("Contribution", ([owner]) => {
  it("#constructor accepts MiniMe instance", async function() {
    const contribution = await Contribution.new(
      "0x0000000000000000000000000000000000000123"
    );
    const miniMe = await contribution.aix();
    assert.equal(
      miniMe,
      "0x0000000000000000000000000000000000000123",
      "== token address"
    );
  });
  describe("#initialize", async function() {
    let aix;
    let contribution;

    beforeEach(async function() {
      const tokenFactory = await MiniMeTokenFactory.new();
      aix = await Aix.new(tokenFactory.address);
      contribution = await MockContribution.new(aix.address);
      await aix.changeController(contribution.address);
    });

    it("happy path", async function() {
      const preSaletokenAddress = "0x123";
      const exchanger = "0x321";
      const multiSig = owner;
      const totalCap = 1000 * 10 ** 18; //1000 eth
      const minimum = 10 ** 18; // 1 eth
      const currentTime = getTime();
      await contribution.setBlockTimestamp(currentTime);
      await contribution.setBlockNumber(100);
      await contribution.initialize(
        aix.address,
        exchanger,
        multiSig,
        totalCap,
        minimum,
        currentTime + 1,
        currentTime + 10
      );
      //public values
      const contributionWallet = await contribution.contributionWallet();
      const totalSupplyCap = await contribution.totalSupplyCap();
      const totalSold = await contribution.totalSold();
      const minimum_investment = await contribution.minimum_investment();
      const startTime = await contribution.startTime();
      const endTime = await contribution.endTime();
      const initializedTime = await contribution.initializedTime();
      const finalizedTime = await contribution.finalizedTime();
      const initializedBlock = await contribution.initializedBlock();
      const finalizedBlock = await contribution.finalizedBlock();
      const paused = await contribution.paused();
      const transferable = await contribution.transferable();
      assert.equal(contributionWallet, multiSig);
      assert.equal(totalSupplyCap.toNumber(), totalCap);
      assert.equal(totalSold.toNumber(), 0);
      assert.equal(minimum_investment.toNumber(), minimum + 1);
      assert.equal(startTime.toNumber(), currentTime + 1);
      assert.equal(endTime.toNumber(), currentTime + 10);
      assert.equal(initializedTime.toNumber(), currentTime);
      assert.equal(finalizedTime.toNumber(), 0);
      assert.equal(initializedBlock.toNumber(), 100);
      assert.equal(finalizedBlock.toNumber(), 0);
      assert.equal(transferable, false);
      assert.equal(paused, false);
    });

    it("White and blacklisting investors", async function() {
      let investor = '0x0000000000000000000000000000000000000123';
      assert.isFalse(await contribution.canPurchase(investor));
      assert.equal(await contribution.numWhitelistedInvestors(), 0);

      await contribution.whitelist(investor);
      assert.isTrue(await contribution.canPurchase(investor));
      assert.equal(await contribution.numWhitelistedInvestors(), 1);

      await contribution.blacklist(investor);
      assert.isFalse(await contribution.canPurchase(investor));
      assert.equal(await contribution.numWhitelistedInvestors(), 0);
    });
  });
});
