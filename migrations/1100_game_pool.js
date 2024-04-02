// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com
const { ether } = require('@openzeppelin/test-helpers');
const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const Router = artifacts.require('Router');
const GamePool = artifacts.require('GamePool'); 
const Rights = artifacts.require('Rights');
const UDSToken = artifacts.require('UDSToken');

module.exports = async function(deployer, network, addresses) {
  const router = await Router.at(process.env.ROUTER);
  const rights = await Rights.at(await router.getAddress("Rights"));
  const udsToken = await UDSToken.at(await router.getAddress("UDSToken")); 
  const usdtTokenAddress = ['development', 'test', 'devnet'].includes(network)
    ? await router.getAddress("USDTMock")
    : '0xdAC17F958D2ee523a2206206994597C13D831ec7'; // Ethereum USDT

  const instance = await deployProxy(
    GamePool, 
    [ 
      rights.address, 
      process.env.HOT_WALLET_ADDRESS,
      [ udsToken.address, usdtTokenAddress ], 
      [ ether('10000'), ether('1000') ]
    ], 
    { deployer }
  );

  await router.setAddress('GamePool', instance.address); 
  console.log(`GamePool contract added to router with ${instance.address}`);

  if (['development', 'test', 'devnet'].includes(network)) {
    await udsToken.transferTo(instance.address, ether('5000000'));
    console.log(`Transfered 5kk UDS to GamePool`);  

    await rights.addAdmin(instance.address, addresses[0]);  
    console.log(`GamePool has new admin ${addresses[0]}`);
  }
};
