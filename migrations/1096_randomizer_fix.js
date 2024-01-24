// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');
const Router = artifacts.require('Router');

const LehmerRandomizer = artifacts.require("LehmerRandomizer");

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const maybeRandomizerAddress = await router.getAddress("Randomizer");
  
  if (maybeRandomizerAddress) {
    console.log('Upgrading proxy for Randomizer...')
    console.log('OLD Contract address', maybeRandomizerAddress);
    await upgradeProxy(maybeRandomizerAddress, LehmerRandomizer, [], { deployer });
  } else {
    console.log('Contract is not deployed so skipping upgrading...')
  }
  
};
