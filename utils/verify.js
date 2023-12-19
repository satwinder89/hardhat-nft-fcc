const { run } = require("hardhat");

async function verify(contractAddress, contract, args) {
  console.log("Verifing contract...");
  console.log("args: " + args);
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
      contract: contract
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already verified!");
    } else {
      console.log(e);
    }
  }
}

module.exports = {verify}