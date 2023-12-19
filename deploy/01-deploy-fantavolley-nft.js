const { network, ethers } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    // const { deploy, log } = deployments
    // const { deployer } = await getNamedAccounts()

    // log("----------------------------------------------------")
    // arguments = ["FantavolleyNFT", "FVN", "https://playerimages.fra1.digitaloceanspaces.com/2023/unique/json/"]
    // const basicNft = await deploy("fantavolleyNFT", {
    //     from: deployer,
    //     args: arguments,
    //     log: true,
    //     waitConfirmations: network.config.blockConfirmations || 1,
    // })

    // // Verify the deployment
    // if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    //     log("Verifying...")
    //     await verify(basicNft.address, 'contracts/fantavolleyNFT.sol:fantavolleyNFT', arguments)
    // }

    // let accounts = await ethers.getSigners()
    // let basicNft = await ethers.getContract("fantavolleyNFT")
    // console.log('accounts: ' + accounts)
    // console.log('contract: ' + basicNft)

    // // Mint multiple NFT
    // for(let i = 0; i < 5; i++){
    //     const txResponse = await basicNft.mint("0xCb109E5Cea5b14Ee18A226B4c0Cfa34cD7887D79", 170)
    //     await txResponse.wait(1)
    //     console.log("i: "+ i)
    // }
}

module.exports.tags = ["all", "basicnft", "main"]
