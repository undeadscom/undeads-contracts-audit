const chai = require("chai");
const { BN, expectRevert, time, ether } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;
const { parseEvents } = require('./events.js');
const { toWei } = require('web3-utils');

const MysteryBox = artifacts.require('MysteryBox');
const Potions = artifacts.require('Potions');

contract('MysteryBox', (accounts) => {
  const [admin, alice, bob, clara, denis, ella, fred, notPriority, hanna, ihor, janny, kasey, liam, priority, dodo, bill] = accounts;
  const commonPrice = ether('0.08');
  const discountPrice = ether('0.06');

  before(async () => {
    this.privilegedFirstAddress = process.env.PRIVILEGED_FIRST_ADDRESS || admin;
    this.idOfCommonToken = 15;
    this.idOfLegendaryToken = 1;
    this.nextPriceForLegendary = 20;
    this.instance = await MysteryBox.deployed();
  })   

  it('Should accept correct funds, create Mystery Box and decrease limits', async () => {

    const limits = await this.instance.getIssued(alice);
    const total = await this.instance.total();
    const created = await this.instance.send(commonPrice, { from: alice });

    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfCommonToken);
 
    const owner = await this.instance.ownerOf(id);
    expect(owner).to.be.equal(alice);

    const rarity = await this.instance.rarity(id);
    expect(rarity).to.be.false;

    const postLimits = await this.instance.getIssued(alice);
    expect(postLimits[0].sub(new BN(1))).to.be.bignumber.equal(limits[0]);
    expect(postLimits[1]).to.be.bignumber.equal(limits[1]);
    const tokenURI = await this.instance.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://QmVUH44vewH4iF93gSMez3qB4dUxc7DowXPztiG3uRXFWS/mystery/${id}/meta.json`);  
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should not be able to buy more than 10 MysteryBox per account', async () => {
    for (let i = 0; i < 10; ++i) {
      await this.instance.send(commonPrice, { from: bill });
      ++this.idOfCommonToken;
    }
    
    await expectRevert(
      this.instance.send(commonPrice, { from: bill }), 
      'MysteryBox: no more common tokens allowed for user');
  });

  it('Should revert incorrect funds', async () => {
    await expectRevert(this.instance.send(toWei('10', 'ether'), { from: hanna }), 'MysteryBox: incorrect price');
  });

  it('Should throw an error on non-existing token', async () => {
      const lastId = (await this.instance.total()).toNumber();
      await expectRevert(this.instance.rarity(lastId + 555), 'wrong id');
  });

  it('Should increase balance of contract', async () => {
    const balanceBefore = await web3.eth.getBalance(this.instance.address);
    const total = await this.instance.total();
    const created = await this.instance.send(commonPrice, { from: bob });
    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfCommonToken);
    const balanceAfter = await web3.eth.getBalance(this.instance.address);
    expect(balanceAfter).to.be.bignumber.greaterThan(balanceBefore);
    expect((new BN(balanceAfter)).sub(new BN(balanceBefore))).to.be.bignumber.equal(commonPrice);
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should open Mystery Box, and ensure same ID potion', async () => {
    const instancePotions = await Potions.deployed();

    const total = await this.instance.total();
    const created = await this.instance.send(commonPrice, { from: clara });
    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfCommonToken);

    const opened = await this.instance.open(id, { from: clara });
    await expectRevert(this.instance.ownerOf(id), 'ERC721: invalid token ID');

    const ownerOfPotion = await instancePotions.ownerOf(id);
    expect(ownerOfPotion).to.be.equal(clara);
    const potionLevel = await instancePotions.level(id);
    expect(potionLevel).to.be.bignumber.gte(new BN(1));
    expect(potionLevel).to.be.bignumber.lte(new BN(5));
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should accept correct funds and create Legendary Box and decrease limits (priority buyer)', async () => {
    this.nextPriceForLegendary += 2;

    const limits = await this.instance.getIssued(priority);
    const total = await this.instance.total();
    const created = await this.instance.send(ether('22'), { from: priority });

    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfLegendaryToken);
    const ownerOf = await this.instance.ownerOf(id);
    expect(ownerOf).to.be.equal(priority);

    const postLimits = await this.instance.getIssued(priority);
    expect(limits[0]).to.be.bignumber.equal(postLimits[0]);
    expect(postLimits[1].sub(new BN(1))).to.be.bignumber.equal(limits[1]);
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should accept correct funds and create Legendary Box and decrease limits (bob)', async () => {
    this.nextPriceForLegendary += 2;

    const limits = await this.instance.getIssued(bob);
    const total = await this.instance.total();
    const created = await this.instance.send(ether(this.nextPriceForLegendary.toString()), { from: bob });

    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfLegendaryToken);
    const ownerOf = await this.instance.ownerOf(id);
    expect(ownerOf).to.be.equal(bob);

    const postLimits = await this.instance.getIssued(bob);
    expect(limits[0]).to.be.bignumber.equal(postLimits[0]);
    expect(postLimits[1].sub(new BN(1))).to.be.bignumber.equal(limits[1]);
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should accept for first reserved token 20eth and issue ONLY for reserved account', async () => {
    await expectRevert(this.instance.send(ether('20'), { from: kasey }), 'MysteryBox: incorrect price');

    const limits = await this.instance.getIssued(this.privilegedFirstAddress);
    const total = await this.instance.total();
    const created = await this.instance.send(ether('20'), { from: this.privilegedFirstAddress });

    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(1);
    const ownerOf = await this.instance.ownerOf(id);
    expect(ownerOf).to.be.equal(this.privilegedFirstAddress);

    const postLimits = await this.instance.getIssued(this.privilegedFirstAddress);
    expect(limits[0]).to.be.bignumber.equal(postLimits[0]);
    expect(postLimits[1].sub(new BN(1))).to.be.bignumber.equal(limits[1]);
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should not be able to buy more than one LegendaryBox per account', async () => {
      await expectRevert(this.instance.send(ether('26'), { from: bob }), 'MysteryBox: no more rare tokens allowed for user');
  });

  it('Should throw an error, wrong person opening', async () => {
    const created = await this.instance.send(commonPrice, { from: denis });
    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfCommonToken);

    await expectRevert(this.instance.open(id, { from: bob }), 'wrong owner');
  });

  it('Should throw an error on getting level of burned token', async () => {
    const created = await this.instance.send(commonPrice, { from: ihor });
    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfCommonToken);
    await this.instance.open(id, { from: ihor });

    await expectRevert(this.instance.rarity(id), 'wrong id');
  });

  it('Should not allow buy with discount if not in the list', async () => {
    await expectRevert(this.instance.send(discountPrice, { from: notPriority }), 'MysteryBox: incorrect price');
  });

  it('Should open Legendary Box (increased price) and ensure Potion is level 5', async () => {
    this.nextPriceForLegendary += 2;
    const instancePotions = await Potions.deployed();
    const total = await this.instance.total();

    const created = await this.instance.send(ether(this.nextPriceForLegendary.toString()), { from: liam });
    const id = parseEvents(created).Created.id.toNumber();
    expect(id).to.be.equal(++this.idOfLegendaryToken);
    const opened = await this.instance.open(id, { from: liam });

    const potionId = parseEvents(opened).Opened.id.toNumber();

    const potionLevel = await instancePotions.level(potionId);
    expect(potionLevel).to.be.bignumber.equal(new BN(5));
    const postTotal = await this.instance.total();
    expect(postTotal.sub(total)).to.be.bignumber.equal('1');
  });

  it('Should NOT allow buy with discount if time is out even for priority user', async () => {
    const oneDay = 8640000;
    await time.increase(oneDay);
    await expectRevert(this.instance.send(discountPrice, { from: priority }), 'MysteryBox: incorrect price');
  });
});
