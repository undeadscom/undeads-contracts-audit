// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const Router = artifacts.require('Router');
const Benefits = artifacts.require('Benefits'); 
const Rights = artifacts.require("Rights");

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rights = await Rights.at(await router.getAddress("Rights"));
  
  const instance = await deployProxy(
    Benefits,
    [
      rights.address,
    ],
    { deployer },
  );
  await router.setAddress('Benefits', instance.address);
  console.log(`Benefits contract added to router with ${instance.address}`)

  await rights.addAdmin(instance.address, addresses[0]);  
};
