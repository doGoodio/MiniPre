import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PreSale.sol";

contract TestGOODController {
  function testInitialBalanceUsingDeployedContract() {

    PreSale presale = PreSale(DeployedAddresses.PreSale());
    MainToken good = MainToken(DeployedAddresses.MainToken());
    goodAddr = DeployedAddresses.MainToken();
    PlaceHolder placeholder = PlaceHolder(DeployedAddresses.PlaceHolder());

    Assert.equal(presale.tokensForSale(), 0, "Owner should have 0 MetaCoin initially");

    presale.finalize();
    placeholder.changeAPTController(goodcontroller);

    // Always deploy GOODController after presale and ICOs
    uint exchangeRate = 1000;
    uint pointsCount = 500;
    GOODController goodcontroller = GOODController(DeployedAddresses.GOODController(good, exchangeRate));
    Assert.equal(good.balanceOf(goodAddr), good.totalSupply / 5, "Good balance unexpected");
    

    // User test
specfy address here
    goodcontroller.exchangePointsForGood(20 Gwei);
    Assert.equal(good.balanceOf(person), exchangeRate * pointsCount, "Expected balance of 0");

    // Admin test
    goodcontroller.setExchangeRate(50);
    Assert.equal(goodcontroller.exchangeRate, 50, "Exchange rate not setting");
    goodcontroller.changeController(placeholder);
    goodcontroller.exchangePointsForGood(20 Gwei);
    Assert.equal(good.balanceOf(person), 0, "Expected balance of 0");
  }

}
