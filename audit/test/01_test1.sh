#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

CONTRACTSDIR=`grep ^CONTRACTSDIR= settings.txt | sed "s/^.*=//"`

AIXSOL=`grep ^AIXSOL= settings.txt | sed "s/^.*=//"`
AIXJS=`grep ^AIXJS= settings.txt | sed "s/^.*=//"`

APTSOL=`grep ^APTSOL= settings.txt | sed "s/^.*=//"`
APTJS=`grep ^APTJS= settings.txt | sed "s/^.*=//"`

CONTRIBUTIONSOL=`grep ^CONTRIBUTIONSOL= settings.txt | sed "s/^.*=//"`
CONTRIBUTIONJS=`grep ^CONTRIBUTIONJS= settings.txt | sed "s/^.*=//"`

EXCHANGERSOL=`grep ^EXCHANGERSOL= settings.txt | sed "s/^.*=//"`
EXCHANGERJS=`grep ^EXCHANGERJS= settings.txt | sed "s/^.*=//"`

CTHSOL=`grep ^CTHSOL= settings.txt | sed "s/^.*=//"`
CTHJS=`grep ^CTHJS= settings.txt | sed "s/^.*=//"`

DTHSOL=`grep ^DTHSOL= settings.txt | sed "s/^.*=//"`
DTHJS=`grep ^DTHJS= settings.txt | sed "s/^.*=//"`

RTHSOL=`grep ^RTHSOL= settings.txt | sed "s/^.*=//"`
RTHJS=`grep ^RTHJS= settings.txt | sed "s/^.*=//"`

ERC20SOL=`grep ^ERC20SOL= settings.txt | sed "s/^.*=//"`
ERC20JS=`grep ^ERC20JS= settings.txt | sed "s/^.*=//"`

MINIMETOKENSOL=`grep ^MINIMETOKENSOL= settings.txt | sed "s/^.*=//"`
MINIMETOKENJS=`grep ^MINIMETOKENJS= settings.txt | sed "s/^.*=//"`

PLACEHOLDERSOL=`grep ^PLACEHOLDERSOL= settings.txt | sed "s/^.*=//"`
PLACEHOLDERJS=`grep ^PLACEHOLDERJS= settings.txt | sed "s/^.*=//"`

PRESALESOL=`grep ^PRESALESOL= settings.txt | sed "s/^.*=//"`
PRESALEJS=`grep ^PRESALEJS= settings.txt | sed "s/^.*=//"`

SAFEMATHSOL=`grep ^SAFEMATHSOL= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

# Setting time to be a block representing one day
BLOCKSINDAY=1

if [ "$MODE" == "dev" ]; then
  # Start time now
  STARTTIME=`echo "$CURRENTTIME" | bc`
else
  # Start time 1m 10s in the future
  STARTTIME=`echo "$CURRENTTIME+60*3+15" | bc`
fi
STARTTIME_S=`date -r $STARTTIME -u`
ENDTIME=`echo "$CURRENTTIME+60*4+15" | bc`
ENDTIME_S=`date -r $ENDTIME -u`

printf "MODE                 = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT      = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD             = '$PASSWORD'\n" | tee -a $TEST1OUTPUT

printf "CONTRACTSDIR         = '$CONTRACTSDIR'\n" | tee -a $TEST1OUTPUT

printf "AIXSOL               = '$AIXSOL'\n" | tee -a $TEST1OUTPUT
printf "AIXJS                = '$AIXJS'\n" | tee -a $TEST1OUTPUT

printf "APTSOL               = '$APTSOL'\n" | tee -a $TEST1OUTPUT
printf "APTJS                = '$APTJS'\n" | tee -a $TEST1OUTPUT

printf "CONTRIBUTIONSOL      = '$CONTRIBUTIONSOL'\n" | tee -a $TEST1OUTPUT
printf "CONTRIBUTIONJS       = '$CONTRIBUTIONJS'\n" | tee -a $TEST1OUTPUT

printf "EXCHANGERSOL         = '$EXCHANGERSOL'\n" | tee -a $TEST1OUTPUT
printf "EXCHANGERJS          = '$EXCHANGERJS'\n" | tee -a $TEST1OUTPUT

printf "CTHSOL               = '$CTHSOL'\n" | tee -a $TEST1OUTPUT
printf "CTHJS                = '$CTHJS'\n" | tee -a $TEST1OUTPUT

printf "DTHSOL               = '$DTHSOL'\n" | tee -a $TEST1OUTPUT
printf "DTHJS                = '$DTHJS'\n" | tee -a $TEST1OUTPUT

printf "RTHSOL               = '$RTHSOL'\n" | tee -a $TEST1OUTPUT
printf "RTHJS                = '$RTHJS'\n" | tee -a $TEST1OUTPUT

printf "ERC20SOL             = '$ERC20SOL'\n" | tee -a $TEST1OUTPUT
printf "ERC20JS              = '$ERC20JS'\n" | tee -a $TEST1OUTPUT

printf "MINIMETOKENSOL       = '$MINIMETOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "MINIMETOKENJS        = '$MINIMETOKENJS'\n" | tee -a $TEST1OUTPUT

printf "PLACEHOLDERSOL       = '$PLACEHOLDERSOL'\n" | tee -a $TEST1OUTPUT
printf "PLACEHOLDERJS        = '$PLACEHOLDERJS'\n" | tee -a $TEST1OUTPUT

printf "PRESALESOL           = '$PRESALESOL'\n" | tee -a $TEST1OUTPUT
printf "PRESALEJS            = '$PRESALEJS'\n" | tee -a $TEST1OUTPUT

printf "SAFEMATHSOL          = '$SAFEMATHSOL'\n" | tee -a $TEST1OUTPUT

printf "DEPLOYMENTDATA       = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS            = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT          = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS         = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME          = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "STARTTIME            = '$STARTTIME' '$STARTTIME_S'\n" | tee -a $TEST1OUTPUT
printf "ENDTIME              = '$ENDTIME' '$ENDTIME_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $CONTRACTSDIR/$AIXSOL $AIXSOL`
`cp $CONTRACTSDIR/$APTSOL $APTSOL`
`cp $CONTRACTSDIR/$CONTRIBUTIONSOL $CONTRIBUTIONSOL`
`cp $CONTRACTSDIR/$EXCHANGERSOL $EXCHANGERSOL`
`cp $CONTRACTSDIR/$CTHSOL $CTHSOL`
`cp $CONTRACTSDIR/$DTHSOL $DTHSOL`
`cp $CONTRACTSDIR/$RTHSOL $RTHSOL`
`cp $CONTRACTSDIR/$ERC20SOL $ERC20SOL`
`cp $CONTRACTSDIR/$MINIMETOKENSOL $MINIMETOKENSOL`
`cp $CONTRACTSDIR/$PLACEHOLDERSOL $PLACEHOLDERSOL`
`cp $CONTRACTSDIR/$PRESALESOL $PRESALESOL`
`cp $CONTRACTSDIR/$SAFEMATHSOL $SAFEMATHSOL`

# --- Modify parameters ---
`perl -pi -e "s/timePassed \> months\(3\)/timePassed \> 0/" $DTHSOL`
#`perl -pi -e "s/deadline \=  1499436000;.*$/deadline = $ENDTIME; \/\/ $ENDTIME_S/" $FUNFAIRSALETEMPSOL`
#`perl -pi -e "s/\/\/\/ \@return total amount of tokens.*$/function overloadedTotalSupply() constant returns (uint256) \{ return totalSupply; \}/" $DAOCASINOICOTEMPSOL`
#`perl -pi -e "s/BLOCKS_IN_DAY \= 5256;*$/BLOCKS_IN_DAY \= $BLOCKSINDAY;/" $DAOCASINOICOTEMPSOL`

DIFFS1=`diff $CONTRACTSDIR/$DTHSOL $DTHSOL`
echo "--- Differences $CONTRACTSDIR/$DTHSOL $DTHSOL ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $CONTRACTSDIR/$ERC20SOL $ERC20TEMPSOL`
#echo "--- Differences $CONTRACTSDIR/$ERC20SOL $ERC20TEMPSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $CONTRACTSDIR/$MIGRATIONSSOL $MIGRATIONSTEMPSOL`
#echo "--- Differences $CONTRACTSDIR/$MIGRATIONSSOL $MIGRATIONSTEMPSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $CONTRACTSDIR/$MINIMETOKENSOL $MINIMETOKENTEMPSOL`
#echo "--- Differences $CONTRACTSDIR/$MINIMETOKENSOL $MINIMETOKENTEMPSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $CONTRACTSDIR/$PLACEHOLDERSOL $PLACEHOLDERTEMPSOL`
#echo "--- Differences $CONTRACTSDIR/$PLACEHOLDERSOL $PLACEHOLDERTEMPSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $CONTRACTSDIR/$PRESALESOL $PRESALETEMPSOL`
#echo "--- Differences $CONTRACTSDIR/$PRESALESOL $PRESALETEMPSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.4.16 --version | tee -a $TEST1OUTPUT

echo "var aixOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $AIXSOL`;" > $AIXJS

echo "var aptOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $APTSOL`;" > $APTJS

echo "var contribOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $CONTRIBUTIONSOL`;" > $CONTRIBUTIONJS

echo "var exchangerOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $EXCHANGERSOL`;" > $EXCHANGERJS

echo "var cthOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $CTHSOL`;" > $CTHJS

echo "var dthOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $DTHSOL`;" > $DTHJS

echo "var rthOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $RTHSOL`;" > $RTHJS

echo "var mmOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $MINIMETOKENSOL`;" > $MINIMETOKENJS

echo "var phOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $PLACEHOLDERSOL`;" > $PLACEHOLDERJS

echo "var psOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $PRESALESOL`;" > $PRESALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$AIXJS");
loadScript("$APTJS");
loadScript("$CONTRIBUTIONJS");
loadScript("$EXCHANGERJS");
loadScript("$CTHJS");
loadScript("$DTHJS");
loadScript("$RTHJS");
loadScript("$MINIMETOKENJS");
loadScript("$PLACEHOLDERJS");
loadScript("$PRESALEJS");
loadScript("functions.js");

var aixAbi = JSON.parse(aixOutput.contracts["$AIXSOL:AIX"].abi);
var aixBin = "0x" + aixOutput.contracts["$AIXSOL:AIX"].bin;

var aptAbi = JSON.parse(aptOutput.contracts["$APTSOL:APT"].abi);
var aptBin = "0x" + aptOutput.contracts["$APTSOL:APT"].bin;

var contribAbi = JSON.parse(contribOutput.contracts["$CONTRIBUTIONSOL:Contribution"].abi);
var contribBin = "0x" + contribOutput.contracts["$CONTRIBUTIONSOL:Contribution"].bin;

var exchangerAbi = JSON.parse(exchangerOutput.contracts["$EXCHANGERSOL:Exchanger"].abi);
var exchangerBin = "0x" + exchangerOutput.contracts["$EXCHANGERSOL:Exchanger"].bin;

var cthAbi = JSON.parse(cthOutput.contracts["$CTHSOL:CommunityTokenHolder"].abi);
var cthBin = "0x" + cthOutput.contracts["$CTHSOL:CommunityTokenHolder"].bin;

var dthAbi = JSON.parse(dthOutput.contracts["$DTHSOL:DevTokensHolder"].abi);
var dthBin = "0x" + dthOutput.contracts["$DTHSOL:DevTokensHolder"].bin;

var rthAbi = JSON.parse(rthOutput.contracts["$RTHSOL:RemainderTokenHolder"].abi);
var rthBin = "0x" + rthOutput.contracts["$RTHSOL:RemainderTokenHolder"].bin;

var mmtfAbi = JSON.parse(mmOutput.contracts["$MINIMETOKENSOL:MiniMeTokenFactory"].abi);
var mmtfBin = "0x" + mmOutput.contracts["$MINIMETOKENSOL:MiniMeTokenFactory"].bin;

var phAbi = JSON.parse(phOutput.contracts["$PLACEHOLDERSOL:PlaceHolder"].abi);
var phBin = "0x" + phOutput.contracts["$PLACEHOLDERSOL:PlaceHolder"].bin;

var psAbi = JSON.parse(psOutput.contracts["$PRESALESOL:PreSale"].abi);
var psBin = "0x" + psOutput.contracts["$PRESALESOL:PreSale"].bin;

// console.log("DATA: aixAbi=" + JSON.stringify(aixAbi));
// console.log("DATA: aptAbi=" + JSON.stringify(aptAbi));
// console.log("DATA: contribAbi=" + JSON.stringify(contribAbi));
// console.log("DATA: exchangerAbi=" + JSON.stringify(exchangerAbi));
// console.log("DATA: cthAbi=" + JSON.stringify(cthAbi));
// console.log("DATA: dthAbi=" + JSON.stringify(dthAbi));
// console.log("DATA: rthAbi=" + JSON.stringify(rthAbi));
// console.log("DATA: mmtfAbi=" + JSON.stringify(mmtfAbi));
// console.log("DATA: phAbi=" + JSON.stringify(phAbi));
// console.log("DATA: psAbi=" + JSON.stringify(psAbi));
// console.log("DATA: psBin=" + psBin);


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");

// -----------------------------------------------------------------------------
var mmtfMessage = "Deploy MiniMeTokenFactory";
// -----------------------------------------------------------------------------
console.log("RESULT: " + mmtfMessage);
var mmtfContract = web3.eth.contract(mmtfAbi);
var mmtfTx = null;
var mmtfAddress = null;
var mmtf = mmtfContract.new({from: contractOwnerAccount, data: mmtfBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        mmtfTx = contract.transactionHash;
      } else {
        mmtfAddress = contract.address;
        addAccount(mmtfAddress, "MiniMeTokenFactory");
        printTxData("mmtfAddress=" + mmtfAddress, mmtfTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mmtfTx, mmtfMessage);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aptMessage = "Deploy APT";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aptMessage);
var aptContract = web3.eth.contract(aptAbi);
var aptTx = null;
var aptAddress = null;
var apt = aptContract.new(mmtfAddress, {from: contractOwnerAccount, data: aptBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        aptTx = contract.transactionHash;
      } else {
        aptAddress = contract.address;
        addAccount(aptAddress, "APT");
        addTokenContractAddressAndAbi(aptAddress, aptAbi);
        printTxData("aptAddress=" + aptAddress, aptTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(aptTx, aptMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aptMintMessage = "Mint APT Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aptMintMessage);
var aptMint_1Tx = apt.generateTokens(account3, "1000000000000000000000", {from: contractOwnerAccount, gas: 2000000});
var aptMint_2Tx = apt.generateTokens(account4, "2000000000000000000000", {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("aptMint_1Tx", aptMint_1Tx);
printTxData("aptMint_2Tx", aptMint_2Tx);
printBalances();
failIfTxStatusError(aptMint_1Tx, aptMintMessage + " - ac3 1,000 APT");
failIfTxStatusError(aptMint_2Tx, aptMintMessage + " - ac4 2,000 APT");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aixMessage = "Deploy AIX";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aixMessage);
var aixContract = web3.eth.contract(aixAbi);
var aixTx = null;
var aixAddress = null;
var aix = aixContract.new(mmtfAddress, {from: contractOwnerAccount, data: aixBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        aixTx = contract.transactionHash;
      } else {
        aixAddress = contract.address;
        addAccount(aixAddress, "AIX");
        addTokenContractAddressAndAbi(aixAddress, aixAbi);
        printTxData("aixAddress=" + aixAddress, aixTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(aixTx, aixMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribMessage = "Deploy Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + contribMessage);
var contribContract = web3.eth.contract(contribAbi);
var contribTx = null;
var contribAddress = null;
var contrib = contribContract.new(aixAddress, {from: contractOwnerAccount, data: contribBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        contribTx = contract.transactionHash;
      } else {
        contribAddress = contract.address;
        addAccount(contribAddress, "Contribution");
        addCrowdsaleContractAddressAndAbi(contribAddress, contribAbi);
        printTxData("contribAddress=" + contribAddress, contribTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribTx, contribMessage);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aixChangeControllerMessage = "AIX changeController(Contribution)";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aixChangeControllerMessage);
var aixChangeControllerTx = aix.changeController(contribAddress, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("aixChangeControllerTx", aixChangeControllerTx);
printBalances();
failIfTxStatusError(aixChangeControllerTx, aixChangeControllerMessage);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenHoldersMessage = "Deploy Token Holders & Exchanger";
var controller = contractOwnerAccount;
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployTokenHoldersMessage);
var cthContract = web3.eth.contract(cthAbi);
var cthTx = null;
var cthAddress = null;
var cth = cthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: cthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        cthTx = contract.transactionHash;
      } else {
        cthAddress = contract.address;
        addAccount(cthAddress, "CommunityTokenHolder");
        // addPlaceHolderContractAddressAndAbi(cthAddress, cthAbi);
        printTxData("cthAddress=" + cthAddress, cthTx);
      }
    }
  }
);
var dthContract = web3.eth.contract(dthAbi);
var dthTx = null;
var dthAddress = null;
var dth = dthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: dthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        dthTx = contract.transactionHash;
      } else {
        dthAddress = contract.address;
        addAccount(dthAddress, "DevTokensHolder");
        // addPlaceHolderContractAddressAndAbi(dthAddress, dthAbi);
        printTxData("dthAddress=" + dthAddress, dthTx);
      }
    }
  }
);
var rthContract = web3.eth.contract(rthAbi);
var rthTx = null;
var rthAddress = null;
var rth = rthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: rthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        rthTx = contract.transactionHash;
      } else {
        rthAddress = contract.address;
        addAccount(rthAddress, "RemainderTokenHolder");
        // addPlaceHolderContractAddressAndAbi(rthAddress, rthAbi);
        printTxData("rthAddress=" + rthAddress, rthTx);
      }
    }
  }
);
var exchangerContract = web3.eth.contract(exchangerAbi);
var exchangerTx = null;
var exchangerAddress = null;
var exchanger = exchangerContract.new(aptAddress, aixAddress, contribAddress, {from: contractOwnerAccount, data: exchangerBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        exchangerTx = contract.transactionHash;
      } else {
        exchangerAddress = contract.address;
        addAccount(exchangerAddress, "Exchanger");
        // addPlaceHolderContractAddressAndAbi(exchangerAddress, exchangerAbi);
        printTxData("exchangerAddress=" + exchangerAddress, exchangerTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(cthTx, deployTokenHoldersMessage + " - CommunityTokenHolder");
failIfTxStatusError(dthTx, deployTokenHoldersMessage + " - DevTokensHolder");
failIfTxStatusError(rthTx, deployTokenHoldersMessage + " - RemainderTokenHolder");
failIfTxStatusError(exchangerTx, deployTokenHoldersMessage + " - Exchanger");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var initialiseContributionMessage = "Initialise Contribution";
var collectorWeiCap = web3.toWei("1000", "ether");
var totalWeiCap = web3.toWei("10000", "ether");
var startTime = $STARTTIME;
var endTime = $ENDTIME;
// -----------------------------------------------------------------------------
console.log("RESULT: " + initialiseContributionMessage);
var initialiseContributionTx = contrib.initialize(aptAddress, exchangerAddress, multisig, rthAddress, dthAddress, cthAddress, collector, 
  collectorWeiCap, totalWeiCap, startTime, endTime, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("initialiseContributionTx", initialiseContributionTx);
printBalances();
failIfTxStatusError(initialiseContributionTx, initialiseContributionMessage + " - 3,000 APT = 3,000 ETH = 7,500,000 AIX");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("startTime", startTime, 0);


// -----------------------------------------------------------------------------
var exchangePresaleMessage = "Exchange Presale APT to AIX; Whitelist";
// -----------------------------------------------------------------------------
console.log("RESULT: " + exchangePresaleMessage);
var exchangePresale_1Tx = exchanger.collect({from: account3, gas: 2000000});
var exchangePresale_2Tx = exchanger.collect({from: account4, gas: 2000000});
var whitelist_1Tx = contrib.whitelist(account3, {from: contractOwnerAccount, gas: 2000000});
var whitelist_2Tx = contrib.whitelist(account4, {from: contractOwnerAccount, gas: 2000000});
var whitelist_3Tx = contrib.whitelist(account5, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("exchangePresale_1Tx", exchangePresale_1Tx);
printTxData("exchangePresale_2Tx", exchangePresale_2Tx);
printTxData("whitelist_1Tx", whitelist_1Tx);
printTxData("whitelist_2Tx", whitelist_2Tx);
printTxData("whitelist_3Tx", whitelist_3Tx);
printBalances();
failIfTxStatusError(exchangePresale_1Tx, exchangePresaleMessage + " - account3 1,000 APT -> 2,500,000 AIX");
failIfTxStatusError(exchangePresale_2Tx, exchangePresaleMessage + " - account4 2,000 APT -> 5,000,000 AIX");
failIfTxStatusError(whitelist_1Tx, exchangePresaleMessage + " - whitelist(account3)");
failIfTxStatusError(whitelist_2Tx, exchangePresaleMessage + " - whitelist(account4)");
failIfTxStatusError(whitelist_3Tx, exchangePresaleMessage + " - whitelist(account5)");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: contribAddress, gas: 400000, value: web3.toWei("1000", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: contribAddress, gas: 400000, value: web3.toWei("2000", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: contribAddress, gas: 400000, value: web3.toWei("3000", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: contribAddress, gas: 400000, value: web3.toWei("3000", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " ac3 1000 ETH -> 2,300,000 AIX");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " ac4 2000 ETH -> 4,600,000 AIX");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " ac5 3000 ETH -> 6,900,000 AIX");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " ac6 1000 ETH - Expecting Failure");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finaliseMessage = "Finalise Crowdsale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + finaliseMessage);
var finalise_1Tx = contrib.finalize({from: contractOwnerAccount, gas: 2000000});
var finalise_2Tx = contrib.allowTransfers(true, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("finalise_1Tx", finalise_1Tx);
printTxData("finalise_2Tx", finalise_2Tx);
printBalances();
failIfTxStatusError(finalise_1Tx, finaliseMessage + " - [removed Remainder 8,000,000;] Dev 11,490,196.078431372549019607; Community 16,660,784.313725490196078431");
failIfTxStatusError(finalise_2Tx, finaliseMessage + " - contrib.allowTransfers(true)");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var transfersMessage = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + transfersMessage);
var transfers1Tx = aix.transfer(account6, "1000000000000", {from: account3, gas: 100000});
var transfers2Tx = aix.approve(account7,  "30000000000000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var transfers3Tx = aix.transferFrom(account4, account8, "30000000000000000", {from: account7, gas: 200000});
while (txpool.status.pending > 0) {
}
printTxData("transfers1Tx", transfers1Tx);
printTxData("transfers2Tx", transfers2Tx);
printTxData("transfers3Tx", transfers3Tx);
printBalances();
failIfTxStatusError(transfers1Tx, transfersMessage + " - transfer 0.000001 tokens ac4 -> ac6. CHECK for movement");
failIfTxStatusError(transfers2Tx, transfersMessage + " - approve 0.03 tokens ac5 -> ac7");
failIfTxStatusError(transfers3Tx, transfersMessage + " - transferFrom 0.03 tokens ac5 -> ac7. CHECK for movement");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var collectTokensMessage = "Collect Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + collectTokensMessage);
var collectTokens1Tx = cth.collectTokens({from: contractOwnerAccount, gas: 1000000});
var collectTokens2Tx = dth.collectTokens({from: contractOwnerAccount, gas: 1000000});
while (txpool.status.pending > 0) {
}
printTxData("collectTokens1Tx", collectTokens1Tx);
printTxData("collectTokens2Tx", collectTokens2Tx);
printBalances();
failIfTxStatusError(collectTokens1Tx, collectTokensMessage + " - CommunityTokenHolder.collectTokens() = 12,111,764.705882352941176470 x 10/29 = 4,176,470.588235294117647");
failIfTxStatusError(collectTokens2Tx, collectTokensMessage + " - DevTokensHolder.collectTokens() = 8,352,941.176470588235294117 x .25 = 2,088,235.294117647058824");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
