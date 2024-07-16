// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

const Router = artifacts.require('Router');
const RentRegistry = artifacts.require('RentRegistry'); 
const RentResolver = artifacts.require('RentResolver'); 
const Rights = artifacts.require('Rights');

module.exports = async function(deployer, network, addresses) {
  const router = await Router.at(process.env.ROUTER);
  const managementV2Address = await router.getAddress("ManagementV2");
  const rights = await Rights.at(await router.getAddress("Rights"));
  const udsAddress = await router.getAddress("UDSToken");
  const usdtAddress = process.env.USDT;

  const resolver = await deployer.deploy(RentResolver, 
    rights.address, 
    [1, 2], 
    [udsAddress, usdtAddress]
  );
  await router.setAddress('RentResolver', resolver.address); 
  console.log(`RentResolver contract added to router with ${resolver.address}`);

  const registry = await deployer.deploy(
    RentRegistry, 
    resolver.address,
    process.env.COLD_WALLET_ADDRESS,
    rights.address,
    [udsAddress, usdtAddress], // rent fees
    [500, 700]
  );
  await router.setAddress('RentRegistry', registry.address); 
  console.log(`RentRegistry contract added to router with ${registry.address}`);

  await rights.addAdmin(resolver.address, managementV2Address);  
  console.log(`RentResolver has new admin ${managementV2Address}`);

  await rights.addAdmin(registry.address, managementV2Address);  
  console.log(`RentRegistry has new admin ${managementV2Address}`);

  if (['test'].includes(network)) {
    await rights.addAdmin(resolver.address, addresses[0]);  
    console.log(`RentResolver has new admin ${addresses[0]}`);

    await rights.addAdmin(registry.address, addresses[0]);  
    console.log(`RentRegistry has new admin ${addresses[0]}`);
  }
};
