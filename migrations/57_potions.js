// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');
const Potions = artifacts.require('Potions');
const Zombies = artifacts.require('Zombies');
const Randomizer = artifacts.require("LehmerRandomizer");

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rightsAddress = await router.getAddress('Rights');
  const rights = await Rights.at(rightsAddress);
  const managementAddress = await router.getAddress('Management');
  const zombie = await Zombies.at(await router.getAddress('Zombies'));
  const random = await Randomizer.at(await router.getAddress('Randomizer'));


  const instance = await deployer.deploy(
    Potions,
    'UndeadsPotions',
    'UNZP',
    rightsAddress,
    zombie.address,
    random.address,
    [1150, 1270, 1390, 1490, 1500], // top weights
    [3333, 2222, 1000, 100, 11], // amount by level
    [667, 444, 200, 20, 0], // woman amount by level
    5
  );

  await router.setAddress('Potions', instance.address);
  console.log(`Potions contract added to router with ${instance.address}`);

  await rights.addAdmin(await router.getAddress('Zombies'), instance.address);
  console.log(`Zombies has new admin ${instance.address}`);

  await rights.addAdmin(await router.getAddress('Randomizer'), instance.address);
  console.log(`Randomizer has new admin ${instance.address}`);

  // await rights.addAdmin(instance.address, await router.getAddress('MysteryBox'));
  // await rights.addAdmin(await router.getAddress('MysteryBox'), instance.address);
  await rights.addAdmin(await router.getAddress('Benefits'), instance.address);
  console.log(`Benefits has new admin ${instance.address}`);

  // add rights to manage royalty fee
  await rights.addAdmin(instance.address, managementAddress);
  console.log(`Potions has new admin ${managementAddress}`);

  await rights.addAdmin(instance.address, addresses[0]);
  console.log(`Potions has new admin ${addresses[0]}`);
};
