// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com  
const Router = artifacts.require('Router');
const BatchBalance = artifacts.require('BatchBalance');

module.exports = async function(deployer, network, addresses) {
  const router = await Router.at(process.env.ROUTER);
  const instance = await deployer.deploy(BatchBalance);
  await router.setAddress('BatchBalance', instance.address);
};
