// SPDX-License-Identifier: PROPRIERTARY

// Author: Bohdan Malkevych
// Email: bm@unicsoft.com

const Router = artifacts.require('Router'); 
const AggregationFunds = artifacts.require('AggregationFunds'); 

module.exports = async function(deployer, network) {
  let routerAddress = process.env.ROUTER;
  const router = await Router.at(routerAddress);

  const aggregationFundsAddress = await router.getAddress('AggregationFunds');
  const instance = await AggregationFunds.at(aggregationFundsAddress);
};
