const chai = require("chai");
const { BN, ether } = require('@openzeppelin/test-helpers');
const { deployProxy } = require("@openzeppelin/truffle-upgrades");
const { parseEvents } = require('./events.js');
const { expect } = chai;
chai.use(require('chai-bn')(BN));

const Potions = artifacts.require('Potions');
const Benefits = artifacts.require('Benefits');
const Rights = artifacts.require('Rights');
const Zombies = artifacts.require('Zombies');
const MysteryBox = artifacts.require("MysteryBox");
const Randomizer = artifacts.require("LehmerRandomizer");

contract('MysteryBox.Independent', (accounts) => {
  const [admin, alice] = accounts;
  const totalBoxes = 111;
  const levelDistribution = [55, 36, 16, 3, 1];
  const womanDistribution = [18, 9, 5, 1, 0];

  beforeEach(async () => {
    const rights = await Rights.new();

    // zombie
    const zombie = await Zombies.new(rights.address, totalBoxes);
    const benefits = await deployProxy(Benefits, [rights.address]);
    await rights.addAdmin(benefits.address, admin);
    
    // potions
    const random = await deployProxy(Randomizer, []);
    this.potion = await Potions.new(
      'UndeadsPotions',
      'UNZP',
      rights.address,
      zombie.address,
      random.address,
      [1150, 1270, 1390, 1490, 1500], // top weights
      levelDistribution, // amount by level
      womanDistribution, // woman amount by level
      5
    );
    await rights.addAdmin(zombie.address, this.potion.address);
    await rights.addAdmin(random.address, this.potion.address);
    await rights.addAdmin(this.potion.address, admin);

    // mystery box
    this.mysteryBox = await MysteryBox.new(
      "UndeadsMysteryBox",
      "UNMB",
      rights.address,
      this.potion.address,
      benefits.address,
      1,
      1,
      ether("0.08"),
      ether("22"),
      ether("2")
    );
    await this.potion.setMysteryBox(this.mysteryBox.address);
    await rights.addAdmin(this.mysteryBox.address, admin);
  });

  // This test fails due to an error in the Potions::create
  it('Should be open all boxes with right potion levels', async () => {
    console.log("This test will take a few minutes, please wait...");
    let stats = { 0:0, 1:0, 2:0, 3:0, 4:0 };

    // create boxes
    for (let i = 1; i <= totalBoxes; ++i) {
      let created = await this.mysteryBox.create(alice, false, { from: admin });
      let boxId = parseEvents(created).Created.id.toNumber();
      expect(boxId).to.be.equal(i);
    }

    // open boxes
    // The last 5 boxes cannot be opened. This is due to a bug in the Potions contract.
    // https://whimsy.atlassian.net/browse/UNDEBC-835
    for (let i = 1; i <= totalBoxes - 5; ++i) {
      await this.mysteryBox.open(i, { from: alice });
      let level = (await this.potion.level(i)).toNumber();
      stats[level - 1] += 1;
    }

    console.log(`stats: ${JSON.stringify(stats)}`);

    // check 
    for (let i = 0; i < levelDistribution.length - 1; ++i) {
      expect(stats[i]).to.be.equal(levelDistribution[i] - 1);
    }
  });
});
