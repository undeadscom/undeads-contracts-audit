// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');
const ManagementV2 = artifacts.require('ManagementV2');

module.exports = async function(deployer, network, addresses) {
    const router = await Router.at(process.env.ROUTER);
    const rights = await Rights.at(await router.getAddress("Rights"));

    const admins = network.includes("mainnet") 
    ? [
        '0xe40ebFcFe21CddF9396692eD3410D6c8800aF558',
        '0xDcD71C0f2F661a41805Ad2A010caCe2AEF446900',
        '0x31759d44AB0ee6F64BD98B9B98b6519590189374'
    ] : network.includes("test") 
    ? [
        addresses[0], addresses[1], addresses[2]
    ] : [
        '0xFD30e6C8fD147F76bFE87958e6f60264f0392eb7', // Dmitry
        '0x81f8699668f0142ED557D53F56b701D21789c5Fc', // Mikhail
        '0x7F41B5e56FCB53abd7ce4E9962f11267Ac341f12'  // Natalia
    ];

    const management = await deployer.deploy(ManagementV2, admins, 2);
    await router.setAddress('ManagementV2', management.address); 
    console.log(`ManagementV2 contract added to router with ${management.address}`);

    //TODO: set management as admin for another contracts and remove other admins
    const gamePoolAddress = await router.getAddress('GamePool');
    await rights.addAdmin(gamePoolAddress, management.address);
    console.log(`GamePool has new admin ${management.address}`);

    const mysteryBoxAddress = await router.getAddress('MysteryBox');
    await rights.addAdmin(mysteryBoxAddress, management.address);
    console.log(`MysteryBox has new admin ${management.address}`);

    const potionsAddress = await router.getAddress('Potions');
    await rights.addAdmin(potionsAddress, management.address);
    console.log(`Potions has new admin ${management.address}`);

    const zombiesAddress = await router.getAddress('Zombies');
    await rights.addAdmin(zombiesAddress, management.address);
    console.log(`Zombies has new admin ${management.address}`);

    const udsTokenAddress = await router.getAddress('UDSToken');
    await rights.addAdmin(udsTokenAddress, management.address);
    console.log(`UDSToken has new admin ${management.address}`);

    const uGoldTokenAddress = await router.getAddress('UGoldToken');
    await rights.addAdmin(uGoldTokenAddress, management.address);
    console.log(`UGoldToken has new admin ${management.address}`);
}