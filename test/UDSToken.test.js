const chai = require("chai");
const { BN } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;

const UDSToken = artifacts.require('UDSToken');

contract('UDSToken', (accounts) => {
  const [admin, alice, bob, clara, denis, ella] = accounts;

  before(async () => {
    this.instanceUDSToken = await UDSToken.deployed();
  });

  it('Should decrease totalSupply after burn', async () => {
    await this.instanceUDSToken.transferTo(admin, 1000000);
    const totalSupply = await this.instanceUDSToken.totalSupply();

    // action
    await this.instanceUDSToken.burn(100);

    const totalSupplyAfter = await this.instanceUDSToken.totalSupply();
    expect(totalSupplyAfter).to.be.bignumber.equal(totalSupply.sub(new BN('100')));
  });
});
