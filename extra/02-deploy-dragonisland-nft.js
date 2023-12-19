const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
const { storeImages, storeTokenUriMetadata } = require("../utils/uploadToPinata")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (process.env.UPLOAD_TO_PINATA == "true") {
        tokenUris = await handleTokenUris()
    }

    log("----------------------------------------------------")
    arguments = [
        tokenUris,
    ]

    const randomIpfsNft = await deploy("DragonIslandProject", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(randomIpfsNft.address, arguments)
    }
}

async function handleTokenUris() {
    tokenUris = []
    const { responses: imageUploadResponses, files } = await storeImages(imagesLocation)
    for (imageUploadResponseIndex in imageUploadResponses) {
        let tokenUriMetadata = { ...metadataTemplate }
        tokenUriMetadata.name = files[imageUploadResponseIndex].replace(".png", "")
        tokenUriMetadata.description = `An adorable ${tokenUriMetadata.name} pup!`
        tokenUriMetadata.image = `ipfs://${imageUploadResponses[imageUploadResponseIndex].IpfsHash}`
        console.log(`Uploading ${tokenUriMetadata.name}...`)
        const metadataUploadResponse = await storeTokenUriMetadata(tokenUriMetadata)
        tokenUris.push(`ipfs://${metadataUploadResponse.IpfsHash}`)
    }
    console.log("Token URIs uploaded! They are:")
    console.log(tokenUris)
    return tokenUris
}

module.exports.tags = ["all", "basicnft", "main"]