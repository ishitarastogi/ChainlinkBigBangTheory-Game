const fs = require('fs')
require("@nomiclabs/hardhat-web3");

task("create-metadata", "Create metadata for all created characters")
    .addParam("contract", "The address of the contract that you want to call")
    .setAction(async taskArgs => {

    const contractAddr = taskArgs.contract

    //Get signer information
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]

const metadataTemple = {
    "name": "sheldon",
    "description": "",
    "image": "",
    "attributes": [
        {
            "trait_type": "emphatic",
            "value": 0
        },
        {
            "trait_type": "toleration",
            "value": 0
        },
        {
            "trait_type": "Nerdy",
            "value": 0
        },
        {
            "trait_type": "SocialSkills",
            "value": 0
        },
        {
            "trait_type": "Extrovert",
            "value": 0
        },
        {
            "trait_type": "organized",
            "value": 0
        }
    ]
}
    const bigBangTheory = await ethers.getContractAt('BigBangTheory', contractAddr)
    length = await bigBangTheory.getNumberOfCharacters()
    index = 0
    while (index < length) {
        console.log('Let\'s get the overview of your character ' + index + ' of ' + length)
        let characterMetadata = metadataTemple
        let characterOverview = await bigBangTheory.characters(index)
        index++
        characterMetadata['name'] = characterOverview['name']
        if (fs.existsSync('metadata/' + characterMetadata['name'].toLowerCase().replace(/\s/g, '-') + '.json')) {
            console.log('test')
            continue
        }
        console.log(characterMetadata['name'])
        characterMetadata['attributes'][0]['value'] = characterOverview['emphatic'].toNumber()
        characterMetadata['attributes'][1]['value'] = characterOverview['toleration'].toNumber()
        characterMetadata['attributes'][2]['value'] = characterOverview['Nerdy'].toNumber()
        characterMetadata['attributes'][3]['value'] = characterOverview['SocialSkills'].toNumber()
        characterMetadata['attributes'][4]['value'] = characterOverview['Extrovert'].toNumber()
        characterMetadata['attributes'][5]['value'] = characterOverview['organized'].toNumber()

        filename = 'metadata/' + characterMetadata['name'].toLowerCase().replace(/\s/g, '-')
        let data = JSON.stringify(characterMetadata)
        fs.writeFileSync(filename + '.mjs', data)
        console.log("Run the following to set the URIs for your NFTs:")
        console.log("npx hardhat set-uri --contract " + contractAddr + " --tokenid InsertIdHere" + " --uri insertURIHere" + " --network " + network.name)
    }
})


module.exports = {}
