// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

const { deployProxy, upgradeProxy } = require("@openzeppelin/truffle-upgrades");
const Router = artifacts.require("Router");
const Randomizer = artifacts.require("LehmerRandomizer");

module.exports = async function (deployer) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);

  if (Randomizer.isDeployed()) {
    await upgradeProxy(Randomizer, Randomizer, [], { deployer });
  } else {
    const instance = await deployProxy(Randomizer, [], { deployer });
    await router.setAddress("Randomizer", instance.address);
    console.log(`Randomizer contract added to router with ${instance.address}`)
  }
};
