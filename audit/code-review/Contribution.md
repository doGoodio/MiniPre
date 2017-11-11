# Contribution

Source file [../../contracts/Contribution.sol](../../contracts/Contribution.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

/**
 * @title Aigang Contribution contract
 *
 *  By contributing ETH to this smart contract you agree to the following terms and conditions:
 *  https://github.com/AigangNetwork/aigang-crowdsale-contracts/Aigang-T&Cs(171020_clean).docx
 *
 */

// BK Next 3 Ok
import "./SafeMath.sol";
import "./ERC20.sol";
import "./MiniMeToken.sol";

// BK Ok
contract Contribution is Controlled, TokenController {
  // BK Ok
  using SafeMath for uint256;

  // BK Next 7 Ok
  MiniMeToken public aix;
  bool public transferable;
  address public contributionWallet;
  address public remainderHolder;
  address public devHolder;
  address public communityHolder;
  address public exchanger;

  // BK Next 3 Ok
  address public collector;
  uint256 public collectorWeiCap;
  uint256 public collectorWeiCollected;

  // BK Next 6 Ok
  uint256 public totalWeiCap;             // Total Wei to be collected
  uint256 public totalWeiCollected;       // How much Wei has been collected
  uint256 public weiPreCollected;
  uint256 public notCollectedAmountAfter24Hours;
  uint256 public twentyPercentWithBonus;
  uint256 public thirtyPercentWithBonus;

  // BK Ok
  uint256 public minimumPerTransaction = 0.01 ether;

  // BK Next 3 Ok
  uint256 public numWhitelistedInvestors;
  mapping (address => bool) public canPurchase;
  mapping (address => uint256) public individualWeiCollected;

  // BK Next 2 Ok
  uint256 public startTime;
  uint256 public endTime;

  // BK Next 2 Ok
  uint256 public initializedTime;
  uint256 public finalizedTime;

  // BK Next 2 Ok
  uint256 public initializedBlock;
  uint256 public finalizedBlock;

  // BK Ok
  bool public paused;

  // BK Ok
  modifier initialized() {
    // BK Ok
    assert(initializedBlock != 0);
    // BK Ok
    _;
  }

  // BK TODO
  modifier contributionOpen() {
    // collector can start depositing 2 days prior
    if (msg.sender == collector) {
      assert(getBlockTimestamp().add(2 days) >= startTime);
    } else {
      assert(getBlockTimestamp() >= startTime);
    }
    assert(getBlockTimestamp() <= endTime);
    assert(finalizedTime == 0);
    _;
  }

  // BK Ok
  modifier notPaused() {
    // BK Ok
    require(!paused);
    // BK Ok
    _;
  }

  // BK Ok - Constructor
  function Contribution(address _aix) {
    // BK Ok
    require(_aix != 0x0);
    // BK Ok
    aix = MiniMeToken(_aix);
  }

  // BK Ok - Only controller can execute
  function initialize(
      address _apt,
      address _exchanger,
      address _contributionWallet,
      address _remainderHolder,
      address _devHolder,
      address _communityHolder,
      address _collector,
      uint256 _collectorWeiCap,
      uint256 _totalWeiCap,
      uint256 _startTime,
      uint256 _endTime
  ) public onlyController {
    // Initialize only once
    // BK Next 5 Ok
    require(initializedBlock == 0);
    require(initializedTime == 0);
    assert(aix.totalSupply() == 0);
    assert(aix.controller() == address(this));
    assert(aix.decimals() == 18);  // Same amount of decimals as ETH

    // BK Next 2 Ok
    require(_contributionWallet != 0x0);
    contributionWallet = _contributionWallet;

    // BK Next 2 Ok
    require(_remainderHolder != 0x0);
    remainderHolder = _remainderHolder;

    // BK Next 2 Ok
    require(_devHolder != 0x0);
    devHolder = _devHolder;

    // BK Next 2 Ok
    require(_communityHolder != 0x0);
    communityHolder = _communityHolder;

    // BK Next 2 Ok
    require(_collector != 0x0);
    collector = _collector;

    // BK Next 3 Ok
    require(_collectorWeiCap > 0);
    require(_collectorWeiCap <= _totalWeiCap);
    collectorWeiCap = _collectorWeiCap;

    // BK Next 4 Ok
    assert(_startTime >= getBlockTimestamp());
    require(_startTime < _endTime);
    startTime = _startTime;
    endTime = _endTime;

    // BK Next 2 Ok
    require(_totalWeiCap > 0);
    totalWeiCap = _totalWeiCap;

    // BK Next 2 Ok
    initializedBlock = getBlockNumber();
    initializedTime = getBlockTimestamp();

    // BK Next 2 Ok
    require(_apt != 0x0);
    require(_exchanger != 0x0);

    // BK NOTE - 1 ETH presale contribution = 1 APT 
    // BK NOTE - See https://etherscan.io/tx/0xc227db7e64f65b2e3679e9b76e5934f0820ed6e8e5925b5ef2eff79cbcbec894
    // BK Ok
    weiPreCollected = MiniMeToken(_apt).totalSupplyAt(initializedBlock);

    // Exchangerate from apt to aix 2500 considering 25% bonus.
    // BK Next 2 Ok
    require(aix.generateTokens(_exchanger, weiPreCollected.mul(2500)));
    exchanger = _exchanger;

    // BK Ok - Log event
    Initialized(initializedBlock);
  }

  /// @notice interface for founders to blacklist investors
  /// @param _investors array of investors
  // BK Ok - Only controller can execute
  function blacklistAddresses(address[] _investors) public onlyController {
    // BK Ok
    for (uint256 i = 0; i < _investors.length; i++) {
      // BK Ok
      blacklist(_investors[i]);
    }
  }

  /// @notice interface for founders to whitelist investors
  /// @param _investors array of investors
  // BK Ok - Only controller can execute
  function whitelistAddresses(address[] _investors) public onlyController {
    // BK Ok
    for (uint256 i = 0; i < _investors.length; i++) {
      // BK Ok
      whitelist(_investors[i]);
    }
  }

  // BK Ok - Only controller can execute
  function whitelist(address investor) public onlyController {
    // BK Ok
    if (canPurchase[investor]) return;
    // BK Ok
    numWhitelistedInvestors++;
    // BK Ok
    canPurchase[investor] = true;
  }

  // BK Ok - Only controller can execute
  function blacklist(address investor) public onlyController {
    // BK Ok
    if (!canPurchase[investor]) return;
    // BK Ok
    numWhitelistedInvestors--;
    // BK Ok
    canPurchase[investor] = false;
  }

  // ETH-AIX exchange rate
  // BK TODO
  function exchangeRate() constant public initialized returns (uint256) {
    if (getBlockTimestamp() <= startTime + 1 hours) {
      // 15% Bonus
      return 2300;
    }

    if (getBlockTimestamp() <= startTime + 2 hours) {
      // 10% Bonus
      return 2200;
    }

    if (getBlockTimestamp() <= startTime + 1 days) {
      return 2000;
    }

    uint256 collectedAfter24Hours = notCollectedAmountAfter24Hours.sub(weiToCollect());

    if (collectedAfter24Hours <= twentyPercentWithBonus) {
      // 15% Bonus
      return 2300;
    }

    if (collectedAfter24Hours <= twentyPercentWithBonus + thirtyPercentWithBonus) {
      // 10% Bonus
      return 2200;
    }

    return 2000;
  }

  // BK TODO
  function tokensToGenerate(uint256 toFund) constant public returns (uint256) {
    // collector gets 15% bonus
    if (msg.sender == collector) {
      return toFund.mul(2300);
    }

    return toFund.mul(exchangeRate());
  }

  /// @notice If anybody sends Ether directly to this contract, consider he is
  /// getting AIXs.
  // BK Ok
  function () public payable notPaused {
    // BK Ok
    proxyPayment(msg.sender);
  }

  //////////
  // TokenController functions
  //////////

  /// @notice This method will generally be called by the AIX token contract to
  ///  acquire AIXs. Or directly from third parties that want to acquire AIXs in
  ///  behalf of a token holder.
  /// @param _th AIX holder where the AIXs will be minted.
  // BK Ok
  function proxyPayment(address _th) public payable notPaused initialized contributionOpen returns (bool) {
    // BK Ok
    require(_th != 0x0);
    // BK Ok
    doBuy(_th);
    // BK Ok
    return true;
  }

  // BK Ok
  function onTransfer(address _from, address, uint256) public returns (bool) {
    // BK Ok
    if (_from == exchanger) {
      // BK Ok
      return true;
    }
    // BK Ok
    return transferable;
  }

  // BK Ok
  function onApprove(address _from, address, uint256) public returns (bool) {
    // BK Ok
    if (_from == exchanger) {
      // BK Ok
      return true;
    }
    // BK Ok
    return transferable;
  }

  // BK Ok - Only controller can execute
  function allowTransfers(bool _transferable) onlyController {
    // BK Ok
    transferable = _transferable;
  }

  // BK TODO
  function doBuy(address _th) internal {
    // whitelisting only during the first day
    if (getBlockTimestamp() <= startTime + 1 days) {
      require(canPurchase[_th] || msg.sender == collector);
    } else if (notCollectedAmountAfter24Hours == 0) {
      notCollectedAmountAfter24Hours = weiToCollect();
      twentyPercentWithBonus = notCollectedAmountAfter24Hours.mul(20).div(100);
      thirtyPercentWithBonus = notCollectedAmountAfter24Hours.mul(30).div(100);
    }

    // BK Ok
    require(msg.value >= minimumPerTransaction);
    uint256 toFund = msg.value;
    uint256 toCollect = weiToCollectByInvestor(_th);

    if (toCollect > 0) {
      // Check total supply cap reached, sell the all remaining tokens
      if (toFund > toCollect) {
        toFund = toCollect;
      }
      uint256 tokensGenerated = tokensToGenerate(toFund);
      require(tokensGenerated > 0);
      require(aix.generateTokens(_th, tokensGenerated));

      contributionWallet.transfer(toFund);
      individualWeiCollected[_th] = individualWeiCollected[_th].add(toFund);
      totalWeiCollected = totalWeiCollected.add(toFund);
      NewSale(_th, toFund, tokensGenerated);
    } else {
      toFund = 0;
    }

    uint256 toReturn = msg.value.sub(toFund);
    if (toReturn > 0) {
      _th.transfer(toReturn);
    }
  }

  /// @notice This method will can be called by the controller before the contribution period
  ///  end or by anybody after the `endTime`. This method finalizes the contribution period
  ///  by creating the remaining tokens and transferring the controller to the configured
  ///  controller.
  // BK TODO
  function finalize() public initialized {
    require(finalizedBlock == 0);
    require(finalizedTime == 0);
    require(getBlockTimestamp() >= startTime);
    require(msg.sender == controller || getBlockTimestamp() > endTime || weiToCollect() == 0);

    // remainder will be minted and locked for 1 year.
    aix.generateTokens(remainderHolder, weiToCollect().mul(2000));
    // AIX generated so far is 51% of total
    uint256 tokenCap = aix.totalSupply().mul(100).div(51);
    // dev Wallet will have 20% of the total Tokens and will be able to retrieve quarterly.
    aix.generateTokens(devHolder, tokenCap.mul(20).div(100));
    // community Wallet will have access to 29% of the total Tokens.
    aix.generateTokens(communityHolder, tokenCap.mul(29).div(100));

    finalizedBlock = getBlockNumber();
    finalizedTime = getBlockTimestamp();

    Finalized(finalizedBlock);
  }

  //////////
  // Constant functions
  //////////

  /// @return Total eth that still available for collection in weis.
  // BK TODO
  function weiToCollect() public constant returns(uint256) {
    return totalWeiCap > totalWeiCollected ? totalWeiCap.sub(totalWeiCollected) : 0;
  }

  /// @return Total eth that still available for collection in weis.
  // BK TODO
  function weiToCollectByInvestor(address investor) public constant returns(uint256) {
    uint256 cap;
    uint256 collected;
    // adding 1 day as a placeholder for X hours.
    // This should change into a variable or coded into the contract.
    if (investor == collector) {
      cap = collectorWeiCap;
      collected = individualWeiCollected[investor];
    } else if (getBlockTimestamp() <= startTime + 1 days) {
      cap = totalWeiCap.div(numWhitelistedInvestors);
      collected = individualWeiCollected[investor];
    } else {
      cap = totalWeiCap;
      collected = totalWeiCollected;
    }
    return cap > collected ? cap.sub(collected) : 0;
  }

  //////////
  // Testing specific methods
  //////////

  /// @notice This function is overridden by the test Mocks.
  // BK Ok - Constant function
  function getBlockNumber() internal constant returns (uint256) {
    // BK Ok
    return block.number;
  }

  // BK Ok - Constant function
  function getBlockTimestamp() internal constant returns (uint256) {
    // BK Ok
    return block.timestamp;
  }

  //////////
  // Safety Methods
  //////////

  /// @notice This method can be used by the controller to extract mistakenly
  ///  sent tokens to this contract.
  /// @param _token The address of the token contract that you want to recover
  ///  set to 0 in case you want to extract ether.
  // BK Ok - Only controller can execute
  function claimTokens(address _token) public onlyController {
    // BK Ok
    if (aix.controller() == address(this)) {
      // BK Ok
      aix.claimTokens(_token);
    }

    // BK Ok - Claim ETH
    if (_token == 0x0) {
      // BK Ok
      controller.transfer(this.balance);
      // BK Ok
      return;
    }

    // BK Ok
    ERC20 token = ERC20(_token);
    // BK Ok
    uint256 balance = token.balanceOf(this);
    // BK Ok
    token.transfer(controller, balance);
    // BK Ok - Log event
    ClaimedTokens(_token, controller, balance);
  }

  /// @notice Pauses the contribution if there is any issue
  // BK Ok - Only controller can execute
  function pauseContribution(bool _paused) onlyController {
    // BK Ok
    paused = _paused;
  }

  // BK Next 4 Ok
  event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
  event NewSale(address indexed _th, uint256 _amount, uint256 _tokens);
  event Initialized(uint _now);
  event Finalized(uint _now);
}

```
