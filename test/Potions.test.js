const chai = require("chai");
const { BN, expectRevert } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;
const { parseEvents } = require('./events.js');

const Potions = artifacts.require('Potions');
const Zombies = artifacts.require('Zombies');

contract('Potions', (accounts) => {
  const [admin, alice, bob, clara, denis] = accounts;
  const PLACEHOLDER_HASH = 'QmZ9bCTRBNwgyhuaX6P7Xfm8D1c7jcUMZ4TFUDggGBE6hb';

  it('Should create a potion by admin', async () => {
    const instance = await Potions.deployed();

    const id = 20;
    const created = await instance.createPotion(bob, 3, id, { from: admin });

    const lastId = parseEvents(created).Created.id.toNumber();
    expect(lastId).to.be.equal(id);
    const owner = await instance.ownerOf(id);
    expect(owner).to.be.equal(bob);
    const level = await instance.level(id);
    expect(level).to.be.bignumber.equal(new BN(3));
  });

  it('Should not create a potion of level 0', async () => {
    const instance = await Potions.deployed();

    const id = 30;
    await expectRevert(instance.createPotion(clara, 0, id, { from: admin }), 'no zero level');
  });

  it('Should not create a potion of level 6', async () => {
    const instance = await Potions.deployed();

    const id = 40;
    await expectRevert(instance.createPotion(denis, 6, id, { from: admin }), 'Index out of bounds');
  });

  it('Should not create a potion by users', async () => {
    const instance = await Potions.deployed();

    const id = 50;
    await expectRevert(instance.createPotion(clara, 2, id, { from: clara }), 'Guard: No rights');
  });

  it('Should not allow to call "from box" creation method by users and allow by admin', async () => {
    const instance = await Potions.deployed();

    const id = 60;
    await expectRevert(instance.create(bob, true, id, { from: denis }), 'Not a box');
    await instance.create(bob, true, id, { from: admin });
  });

  it('Should have at least one woman and one man', async () => {
    const instancePotion = await Potions.deployed();
    const instanceZombies = await Zombies.deployed();

    const id = 70;
    for (let i = 0; i < 20; i++) {
      await instancePotion.createPotion(bob, 1, id + i, { from: admin });
    }
    let menCount = 0;
    let womanCount = 0;

    for (let i = 0; i < 20; i++){
      await instancePotion.open(id + i, { from: bob });
    }

    const sexPromises = [];
    for (let i = 0; i < 10; i++) {
      sexPromises.push(instanceZombies.getSex(id + i));
    }
    const sexArr = await Promise.all(sexPromises);
    sexArr.map(sex => sex ? menCount++ : womanCount++);

    expect(menCount).to.be.above(0);
    expect(womanCount).to.be.above(0);
  });

  it('Should return potion level and throw an error on getting level of burned token', async () => {
    const instancePotion = await Potions.deployed();

    const idAdmin = 90;
    const idUser = 91;
    await instancePotion.createPotion(clara, 3, idAdmin, { from: admin });
    await instancePotion.create(denis, false, idUser);


    const level1Potion = (await instancePotion.level(idAdmin)).toNumber();
    const level2Potion = (await instancePotion.level(idUser)).toNumber();
    expect(level1Potion).to.be.greaterThanOrEqual(1);
    expect(level2Potion).to.be.greaterThanOrEqual(1);

    await instancePotion.open(idAdmin, { from: clara });
    await instancePotion.open(idUser, { from: denis });

    await expectRevert(instancePotion.level(idAdmin), 'wrong id');
    await expectRevert(instancePotion.level(idUser), 'wrong id');
  });

  it('Should distribute around expected random level of potions', async () => {
    // Percent in total distribution: 1lvl = 50%, 2 lvl = 33.3%, 3lvl = 15%, 4lvl = 1.5%
    const instance = await Potions.deployed();

    const id = 100;
    const total = 100;

    for (let i = 0; i < total; i++) {
      await instance.create(accounts[i % 10 + 1], false, id + i, { from: admin });
    }

    const levels = [];
    for (let i = 0; i < total; i++) {
      levels.push((await instance.level(id + i)).toNumber());
    }

    const levelRange = [0, 0, 0, 0];
    levels.map(level => levelRange[level - 1] = levelRange[level - 1] + 1);

    expect(levelRange[0]).to.be.greaterThan(total * 0.25);
    expect(levelRange[1]).to.be.greaterThan(total * 0.16);
    expect(levelRange[2]).to.be.greaterThan(total * 0.07);
    expect(levelRange[3]).to.be.greaterThanOrEqual(0);

    expect(levelRange[0]).to.be.lessThan(total * 0.75);
    expect(levelRange[1]).to.be.lessThan(total * 0.5);
    expect(levelRange[2]).to.be.lessThan(total * 0.22);
    expect(levelRange[3]).to.be.lessThan(total * 0.05);
  });

  it('Should have right placeholder for potion with specific level', async () => {
    for (let level = 1; level <= 5; level++) {
      const instancePotion = await Potions.deployed();
      const created = await instancePotion.createPotion(bob, level, 200+level);

      const id = parseEvents(created).Created.id.toNumber();
      const tokenURI = await instancePotion.tokenURI(id);
      expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/po/${level}/meta.json`); 
    }
  });

  it('Should have right token URI after it was set', async () => {
    const level = 1;
    const instancePotion = await Potions.deployed();
    const created = await instancePotion.createPotion(admin, level, 210);

    const id = parseEvents(created).Created.id.toNumber();
    const tokenURI = await instancePotion.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/po/${level}/meta.json`);

    await instancePotion.setMetadataHash(id, "some-hash");
    const tokenURIAfter = await instancePotion.tokenURI(id);
    expect(tokenURIAfter).to.be.equal(`ipfs://some-hash`);
  });

  it('Should not allow to use same token metadata hash twice', async () => {
    const level = 2;
    const instancePotion = await Potions.deployed();
    const created = await instancePotion.createPotion(admin, level, 211);

    const id = parseEvents(created).Created.id.toNumber();

    await expectRevert(
      instancePotion.setMetadataHash(id, "some-hash"),
      'Potion: meta already used',
    );
  });

  it('Should not allow to change token metadata twice', async () => {
    const level = 2;
    const instancePotion = await Potions.deployed();
    const created = await instancePotion.createPotion(admin, level, 212);

    const id = parseEvents(created).Created.id.toNumber();

    await instancePotion.setMetadataHash(id, "some-hash-2");
    await expectRevert(
      instancePotion.setMetadataHash(id, "some-hash-3"),
      'Potion: already set',
    );
  });

  it('Should throw an error, ID is claimed already', async () => {
    const instance = await Potions.deployed();

    const id = 220;
    await instance.create(bob, true, id, { from: admin });
    await expectRevert(instance.create(bob, true, id, { from: admin }), 'token already minted');
  });

});
