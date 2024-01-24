// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const { ether } = require("@openzeppelin/test-helpers");
const Router = artifacts.require("Router");
const MysteryBox = artifacts.require("MysteryBox");
const Rights = artifacts.require("Rights");
const Benefits = artifacts.require("Benefits");
const Potions = artifacts.require("Potions");
const Management = artifacts.require("Management");

module.exports = async function (deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rights = await Rights.at(await router.getAddress("Rights"));
  const potion = await Potions.at(await router.getAddress("Potions"));
  const benefits = await Benefits.at(await router.getAddress("Benefits"));
  const management = await Management.at(await router.getAddress('Management'));
  const instance = await deployer.deploy(
    MysteryBox,
    "UndeadsMysteryBox",
    "UNMB",
    rights.address,
    potion.address,
    benefits.address,
    1,
    1,
    ether("0.08"),
    ether("22"), // starts form 22 as firs one is reserved, and that costs 20eth
    ether("2")
  );

  await router.setAddress("MysteryBox", instance.address);
  console.log(`MysteryBox contract added to router with ${instance.address}`)
  
  await potion.setMysteryBox(instance.address);
  console.log(`Potions got new mysteryBox address ${instance.address}`)

  await rights.addAdmin(instance.address, addresses[0]);
  console.log(`MysteryBox has new admin ${addresses[0]}`)

  await rights.addAdmin(potion.address, instance.address);
  console.log(`Potion has new admin ${instance.address}`)

  await rights.addAdmin(benefits.address, instance.address);
  console.log(`Benefits has new admin ${instance.address}`)

  // add rights to manage royalty fee
  await rights.addAdmin(instance.address, management.address);
  console.log(`MysteryBox has new admin ${management.address}`)

  const transaction = await web3.eth.getTransaction(instance.transactionHash);

  let address = process.env.FIFTY_BOXES_MINT_ADDRESS;

  if (network.includes("mainnet")) {
    for (let index = 0; index < 50; index++) {
      console.log(`Minting box ${index} for ${address}`);
      await instance.create(address, false);
    }
  }

};
