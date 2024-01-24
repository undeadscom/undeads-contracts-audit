// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com

const { ether, BN } = require("@openzeppelin/test-helpers");
const Router = artifacts.require("Router");
const Rights = artifacts.require("Rights");
const Benefits = artifacts.require("Benefits");
const privilegedUsersDev =  require("../scripts/privileged-users-dev.json");
const privilegedUsersProd = require("../scripts/privileged-users-prod.json")

module.exports = async function (deployer, network, addresses) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);
  const benefitsAddress = await router.getAddress("Benefits");
  if (benefitsAddress === '0x0000000000000000000000000000000000000000') return;
  const benefits = await Benefits.at(benefitsAddress);
  const rights = await Rights.at(await router.getAddress("Rights"));
  const privilegedFirstAddress = process.env.PRIVILEGED_FIRST_ADDRESS || addresses[0];
  if (!privilegedFirstAddress) {
    throw new Error('PRIVILEGED_FIRST_ADDRESS must be defined')
  } else {
    console.log(`PRIVILEGED_FIRST_ADDRESS is ${privilegedFirstAddress}`)
  }

  const vips = [];
  if (network == 'whimsy') {
    vips.concat(privilegedUsersDev);
  } else if (['development', 'test'].includes(network)) {
    vips.push(addresses[13]);
  } else if (network == "mainnet") {
    vips.concat(privilegedUsersProd);
  } else {
    throw new Error("Invalid network");
  }

  let from = 0;
  let until = 1677207600;
  await benefits.addBatch(
    vips,                   // targets_
    vips.map(() => ether('0.06')),    // prices_
    vips.map(() => 0),      // ids_
    vips.map(() => 3),      // amounts_
    vips.map(() => 0),      // levels_
    vips.map(() => from),   // froms_
    vips.map(() => until)   // untils_
  );
  console.log(`Privileged addresses added ${vips}`);

  const amountOfWhitelisted = 2105;
  await benefits.add(
    "0x0000000000000000000000000000000000000000", // targets_
    ether('0.06'),    // prices_
    0,      // ids_
    amountOfWhitelisted,   // amounts_
    0,      // levels_
    from,   // froms_
    until   // untils_
  );
  console.log(`Whitelisted addresses amount count ${amountOfWhitelisted}`);

  if (['whimsy', 'development', 'test'].includes(network)) {
    const oneDay = 864000;
    let until = Math.round(new Date().getTime() / 1000) + oneDay;
    await benefits.addBatch(
      vips,                   // targets_
      vips.map(() => ether('0.06')),    // prices_
      vips.map(() => 0),      // ids_
      vips.map(() => 1),      // amounts_
      vips.map(() => 0),      // levels_
      vips.map(() => 0),      // froms_
      vips.map(() => until)   // untils_
    );

    // add admin rights for Nazar
    await rights.addAdmin(benefits.address, '0x1d5F5137210DF212D237F23715393002F19bC4bE');
  }
  

  const startPrice = new BN('20');
  const stepPrice = new BN('2');

  const legendaryBenefits = [
    [privilegedFirstAddress],
    [ether(startPrice)],
    [1],
    [1],
    [1],
    [0],
    [0],
  ];

  for (let i = 1; i < 11; i++) {
    legendaryBenefits[0].push('0x0000000000000000000000000000000000000000'); // target_
    legendaryBenefits[1].push(ether((startPrice.add(stepPrice.mul(new BN(i)))).toString())); // price_
    legendaryBenefits[2].push(i+1); // id_
    legendaryBenefits[3].push(1); // amount_
    legendaryBenefits[4].push(1); // level_
    legendaryBenefits[5].push(0); // from_
    legendaryBenefits[6].push(0); // until_
  }
  await benefits.addBatch(...legendaryBenefits);
  console.log(`Legendary nfts reserved`);

};
