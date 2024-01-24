// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require("Router");
const MysteryBox = artifacts.require("MysteryBox");


module.exports = async function (deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const mysteryBox = await MysteryBox.at(await router.getAddress("MysteryBox"));
  await mysteryBox.setCommonLimit(10);
};
