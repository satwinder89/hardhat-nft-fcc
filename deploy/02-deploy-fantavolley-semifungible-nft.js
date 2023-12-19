const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  
  log("----------------------------------------------------");

  arguments = ["FantavolleySFT", "FVN", "https://playerimages.fra1.digitaloceanspaces.com/2023/gold/json/"]
  const fantavolleySFT = await deploy("fantavolleySFT", {
    from: deployer,
    args: arguments,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    log("Verifying...");
    await verify(fantavolleySFT.address, 'contracts/fantavolleySFT.sol:fantavolleySFT', arguments);
  }

  // let accounts = await ethers.getSigners();
  // let deployedContract = await ethers.getContract("semiFungibileNFT");
  // console.log('accounts:', accounts.map(account => account.address));
  // console.log('contract:', deployedContract.address);

  // // Mint multiple semi-fungible tokens
  // for(let i = 1; i < 171; i++) {
  //   const txResponse = await deployedContract.mintSemiFungible("0xCb109E5Cea5b14Ee18A226B4c0Cfa34cD7887D79", 10);
  //   await txResponse.wait(1);
  //   console.log("Mint iteration: ", i);
  // }
};

module.exports.tags = ["all", "semifungiblenft", "main", "second"];
