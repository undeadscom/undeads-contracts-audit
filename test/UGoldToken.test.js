const chai = require("chai");
const { BN, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;

const UGoldToken = artifacts.require('UGoldToken');
const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');

contract('UGoldToken', (accounts) => {
  const [admin, alice, bob, clara, denis, ella, ...restAccounts] = accounts;

  before(async () => {
    this.router = await Router.deployed();
    this.instanceUGoldToken = await UGoldToken.deployed();
  });

  it('Should decrease totalSupply after burn', async () => {
    await this.instanceUGoldToken.transferTo(admin, 1000000);
    const totalSupply = await this.instanceUGoldToken.totalSupply();
    
    // action
    await this.instanceUGoldToken.burn(100);

    const totalSupplyAfter = await this.instanceUGoldToken.totalSupply();
    expect(totalSupplyAfter).to.be.bignumber.equal(totalSupply.sub(new BN('100')));
    
  });

  it('Should increase totalSupply after min', async () => {
    await this.instanceUGoldToken.transferTo(admin, 1000000);
    const totalSupply = await this.instanceUGoldToken.totalSupply();
    const balanceOfDenis = await this.instanceUGoldToken.balanceOf(denis);
    expect(balanceOfDenis).to.be.bignumber.equal('0');

    // action
    await this.instanceUGoldToken.mint(denis, 100);

    const totalSupplyAfter = await this.instanceUGoldToken.totalSupply();
    const balanceOfDenisAfter = await this.instanceUGoldToken.balanceOf(denis);
    expect(totalSupplyAfter).to.be.bignumber.equal(totalSupply.add(new BN('100')));
    expect(balanceOfDenisAfter).to.be.bignumber.equal('100');
  });

  it('Should throw error if no permission to mint', async () => {
    const rights = await Rights.new();
    const router = await Router.new();
    await router.setAddress('Rights', rights.address);
    const tokenWithoutPermissions = await UGoldToken.new('100000000', rights.address);

    // action
    await expectRevert(
      tokenWithoutPermissions.mint(denis, 100, { from: ella }),
      'Guard: No rights'
    );
  });
});
