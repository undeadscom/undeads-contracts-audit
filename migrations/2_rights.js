// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');

module.exports = async function(deployer, network, addresses) { 
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);

  await deployer.deploy(Rights);
  const instance = await Rights.deployed();
  await instance.addAdmin(addresses[0]);
  await router.setAddress('Rights', instance.address);
  console.log(`Rights contract added to router with ${instance.address}`)

  if (network != 'development') {
    process.env.ADMINS.split(',').map(async(s) => {
      console.log('add rights admin', s);
      await instance.addAdmin(s.trim())
    });
  }
};
