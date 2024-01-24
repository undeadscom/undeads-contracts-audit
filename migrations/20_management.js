// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

const Router = artifacts.require('Router');
const Management = artifacts.require('Management');

//The address of the wallet receiving non-distributed tokens amount
const target = '0x5044c453B3bC59Db88A67CFa8A02f805D5f06CFa'; 

module.exports = async function(deployer, network) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);

  await deployer.deploy(Management, 86400, await router.getAddress('UDSToken'), target);
  const instance = await Management.deployed();
  await router.setAddress('Management', instance.address);
  console.log(`Management contract added to router with ${instance.address}`)

  const admins = network.includes("mainnet") ? [
      '0xe40ebFcFe21CddF9396692eD3410D6c8800aF558',
      '0xDcD71C0f2F661a41805Ad2A010caCe2AEF446900',
      '0x31759d44AB0ee6F64BD98B9B98b6519590189374'
    ] : [
      '0xFD30e6C8fD147F76bFE87958e6f60264f0392eb7',
      '0x81f8699668f0142ED557D53F56b701D21789c5Fc',
      '0x7F41B5e56FCB53abd7ce4E9962f11267Ac341f12'
    ];

  for (let index = 0; index < admins.length; index++) {
    const admin = admins[index];
    console.log(`Adding admin ${admin}`);
    await instance.addAdmin(admin);
  }
  await instance.seal();
};
