// SPDX-License-Identifier: PROPRIERTARY

// Author: Ilya A. Shlyakhovoy
// Email: is@unicsoft.com
const Router = artifacts.require('Router');

module.exports = async function(deployer) {
    await deployer.deploy(Router);
    const instance = await Router.deployed();
    process.env.ROUTER = instance.address;
};
