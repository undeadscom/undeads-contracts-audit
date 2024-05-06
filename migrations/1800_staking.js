// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

const Router = artifacts.require('Router');
const Staking = artifacts.require('Staking'); 
const Rights = artifacts.require('Rights');

module.exports = async function(deployer, network, addresses) {
  const router = await Router.at(process.env.ROUTER);
  const rights = await Rights.at(await router.getAddress("Rights"));
  const usdTokenAddress = await router.getAddress("UDSToken");
  const zombiesAddress = await router.getAddress("Zombies");
  const managementV2Address = await router.getAddress("ManagementV2");

  const instance = await deployer.deploy(
    Staking, 
    rights.address, 
    usdTokenAddress,
    zombiesAddress,
    30000,
    [ 1, 2, 3, 6, 12, 24 ],
    [ 100, 200, 300, 400, 500, 600 ],
    [ 115, 125, 150, 250, 500 ]
  );

  await router.setAddress('Staking', instance.address); 
  console.log(`Staking contract added to router with ${instance.address}`);

  await rights.addAdmin(instance.address, managementV2Address);  
  console.log(`Staking has new admin ${managementV2Address}`);
};
