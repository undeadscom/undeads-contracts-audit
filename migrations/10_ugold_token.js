// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const { ether } = require('@openzeppelin/test-helpers');
const Router = artifacts.require('Router');
const UGoldToken = artifacts.require('UGoldToken');
const Rights = artifacts.require('Rights'); 

module.exports = async function(deployer, network,  addresses) { 
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rights = await Rights.at(await router.getAddress("Rights")); 
  const instance = await deployer.deploy(UGoldToken, ether('10000000000000000000000'), rights.address);

  await router.setAddress('UGoldToken', instance.address);
  await rights.addAdmin(instance.address, addresses[0]);  

  const transaction = await web3.eth.getTransaction(instance.transactionHash);
};
