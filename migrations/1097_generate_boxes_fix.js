// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require('Router');

const MysteryBox = artifacts.require("MysteryBox");

/**
 * This address will store 4 boxes that must be saved until all levels 
 * in potions except last are not opened
 */
const ownerOf4Boxes = '0x32caD849F8577aaeE74e29c6b88A0cf99048E13c'

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const mysteryBox = await MysteryBox.at(await router.getAddress("MysteryBox"));
  const isRare = false;

  for (let index = 0; index < 4; index++) {
    console.log(`Creation mystery box ${index}`);
    await mysteryBox.create(ownerOf4Boxes, isRare);
    console.log(`Mystery box ${index} created`);
  }
};
