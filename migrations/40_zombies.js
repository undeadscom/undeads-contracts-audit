// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');
const Zombies = artifacts.require('Zombies');

module.exports = async function(deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const rights = await Rights.at(await router.getAddress("Rights"));

  const managementAddress = await router.getAddress('Management');
  const instance = await deployer.deploy(Zombies, rights.address, 6666);
  await router.setAddress('Zombies', instance.address);
  console.log(`Zombies contract added to router with ${instance.address}`)

  await rights.addAdmin(instance.address, addresses[0]); 

  // add rights to manage royalty fee
  await rights.addAdmin(instance.address, managementAddress);

  const transaction = await web3.eth.getTransaction(instance.transactionHash);
};
