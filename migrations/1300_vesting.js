// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com
const { ether } = require('@openzeppelin/test-helpers');

const Router = artifacts.require('Router');
const Vesting = artifacts.require('Vesting');
const UDSToken = artifacts.require('UDSToken');
const Rights = artifacts.require('Rights');

module.exports = async function(deployer, network, addresses) {
  const router = await Router.at(process.env.ROUTER); 
  const managementV2Address = await router.getAddress("ManagementV2");
  const udsTokenAddress = await router.getAddress('UDSToken');
  const udsToken = await UDSToken.at(udsTokenAddress);
  const rights = await Rights.at(await router.getAddress('Rights'));

  await deployer.deploy(Vesting, rights.address, udsTokenAddress);
  const instance = await Vesting.deployed();

  if (['devnet', 'test'].includes(network)) {
    await udsToken.transferTo(instance.address, ether('1000'));
    console.log(`1000 UDS sent to Vesting contract`)
  }

  await rights.addAdmin(instance.address, managementV2Address);  
  console.log(`Vesting has new admin ${managementV2Address}`);

  await rights.addAdmin(instance.address, process.env.HOT_WALLET_ADDRESS);
  console.log(`Vesting has new admin ${process.env.HOT_WALLET_ADDRESS}`);
};
