const chai = require("chai");
const { BN, ether } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;
const { toWei } = require('web3-utils');

const Benefits = artifacts.require('Benefits');

contract('Benefits', (accounts) => {
  const [admin, alice, bob] = accounts;

  before(async () => {
    this.privilegedFirstAddress = process.env.PRIVILEGED_FIRST_ADDRESS || admin;
  })

  it('Should find the benefit #1 for the privileged user with high payment', async () => {
    const instance = await Benefits.deployed();
    expect(await instance.denied(1)).to.be.true;
    const got = await instance.get(this.privilegedFirstAddress, 1, toWei('20', 'ether'));
    const red = await instance.read(this.privilegedFirstAddress, 0);
    expect(red.id).to.be.equal('1');
    expect(got[0]).to.be.equal(this.privilegedFirstAddress);
    expect(got[3].toString()).to.be.equal('1');
  });
  
  it('Should find the benefit #2 for the next user with high payment', async () => {
    const instance = await Benefits.deployed();
    expect(await instance.denied(1)).to.be.true;
    const got = await instance.get(bob, 1, ether('22'));
    expect(got[0]).to.be.equal('0x0000000000000000000000000000000000000000');
    expect(got[3].toString()).to.be.equal('2');
  });

  it('Should find the normal position for the next user with ordinary payment', async () => {
    const instance = await Benefits.deployed();
    const got = await instance.get(bob, 48, ether('0.08'));
    expect(got[0]).to.be.equal('0x0000000000000000000000000000000000000000');
    console.log('token', got[3].toString());
  });

  it('Should return beneficiary time bounds zero', async () => {
    const instance = await Benefits.deployed();
    const addresses = await instance.listReceivers();

    // +1 is first privileged address
    expect(addresses.length).to.be.equal(2);
  });
});