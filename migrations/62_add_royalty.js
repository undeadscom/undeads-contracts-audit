// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require("Router");
const MysteryBox = artifacts.require("MysteryBox");
const Zombies = artifacts.require("Zombies");
const Potions = artifacts.require("Potions");

module.exports = async function (deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const potion = await Potions.at(await router.getAddress("Potions"));
  const zombies = await Zombies.at(await router.getAddress("Zombies"));
  const mysteryBox = await MysteryBox.at(await router.getAddress("MysteryBox"));
  
  const collectionOwnerFeeNumerator = 200;
  const firstOwnerFeeNumerator = 500;

  await potion.setDefaultRoyalty(
    process.env.ROYALTY_RECEIVER_ADDRESS || addresses[0],
    collectionOwnerFeeNumerator,
    firstOwnerFeeNumerator
  );
  console.log(`Added royalty for potions`);

  await zombies.setDefaultRoyalty(
    process.env.ROYALTY_RECEIVER_ADDRESS || addresses[0],
    collectionOwnerFeeNumerator,
    firstOwnerFeeNumerator
  );
  console.log(`Added royalty for zombies`);

  await mysteryBox.setDefaultRoyalty(
    process.env.ROYALTY_RECEIVER_ADDRESS || addresses[0],
    collectionOwnerFeeNumerator,
    firstOwnerFeeNumerator
  );
  console.log(`Added royalty for mysteryBox`);

};
