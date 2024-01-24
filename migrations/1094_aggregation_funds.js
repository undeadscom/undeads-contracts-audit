// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const { ether } = require('@openzeppelin/test-helpers');
const Router = artifacts.require('Router'); 
const Rights = artifacts.require('Rights'); 
const AggregationFunds = artifacts.require('AggregationFunds'); 

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);

  //TODO: set right claimable eth contracts
  const claimableEthContracts = [
    await router.getAddress('MysteryBox'),
  ];

  //TODO: set right claimable tokens contracts
  const claimableUDSTokensContracts = [
    // await router.getAddress('MarketplaceTreasury'),
    // await router.getAddress('Maternity'),
  ];

  //TODO: set right claimable tokens contracts
  const claimableUGOLDTokensContracts = [];

  const udsAddress = await router.getAddress('UDSToken');
  const ugoldAddress = await router.getAddress('UGoldToken');
  const rightsAddress = await router.getAddress('Rights');
  const managementAddress = await router.getAddress('Management');

  const instance = await deployProxy(
    AggregationFunds,
    [
      claimableEthContracts,
      claimableUDSTokensContracts,
      claimableUGOLDTokensContracts,
      rightsAddress,
      udsAddress,
      ugoldAddress,
    ],
    { deployer },
  );

  await router.setAddress('AggregationFunds', instance.address);
  console.log(`AggregationFunds contract added to router with ${instance.address}`)

  const rights = await Rights.at(rightsAddress);
  await rights.addAdmin(instance.address, addresses[0]);
  console.log(`AggregationFunds contract added to router with ${instance.address}`)

  await rights.addAdmin(instance.address, managementAddress);
  console.log(`AggregationFunds has new admin ${managementAddress}`)
  
  const grantRights = [
    ...claimableEthContracts,
    ...claimableUDSTokensContracts,
    ...claimableUGOLDTokensContracts,
  ];
  for (let index = 0; index < grantRights.length; index++) {
    const contract = grantRights[index];
    await rights.addAdmin(contract, instance.address);
    console.log(`AggregationFunds has permission to call address ${contract}`);
  }

  await instance.setMinMax('0x0000000000000000000000000000000000000000', ether('0.5'), ether('0.7')); // ETH
  console.log(`AggregationFunds has new limits for eth`);

  await instance.setMinMax(udsAddress, ether('100'), ether('5000'));
  console.log(`AggregationFunds has new limits for uds`);

  await instance.setMinMax(ugoldAddress, ether('100'), ether('5000'));
  console.log(`AggregationFunds has new limits for ugold`);

  const coldWallet = process.env.COLD_WALLET_ADDRESS || addresses[0];
  const hotWallet = process.env.HOT_WALLET_ADDRESS || addresses[0];
  await instance.setColdWallet(coldWallet);
  console.log(`AggregationFunds has new cold wallet ${coldWallet}`);

  await instance.setHotWallet(hotWallet);
  console.log(`AggregationFunds has new how wallet ${hotWallet}`);

};
