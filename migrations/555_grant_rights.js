// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require("Router");
const Zombies = artifacts.require("Zombies");
const Potions = artifacts.require("Potions");
const Rights = artifacts.require("Rights");

module.exports = async function (deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rights = await Rights.at(await router.getAddress("Rights"));
  const potion = await Potions.at(await router.getAddress("Potions"));
  const zombies = await Zombies.at(await router.getAddress("Zombies"));

  await rights.addAdmin(potion.address, process.env.HOT_WALLET_ADDRESS || addresses[0]);
  console.log(`Potions has new admin ${process.env.HOT_WALLET_ADDRESS || addresses[0]}`)

  await rights.addAdmin(zombies.address, process.env.HOT_WALLET_ADDRESS || addresses[0]); 
  console.log(`Zombies has new admin ${process.env.HOT_WALLET_ADDRESS || addresses[0]}`)
};
