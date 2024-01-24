const chai = require("chai");
const { BN, expectRevert, time } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;

const Potions = artifacts.require('Potions');
const Zombies = artifacts.require('Zombies');
const Router = artifacts.require('Router');
const Rights = artifacts.require('Rights');

contract('Zombies', (accounts) => {
  const [admin, alice, bob, clara, denis, ella] = accounts;
  const PLACEHOLDER_HASH = 'QmZ9bCTRBNwgyhuaX6P7Xfm8D1c7jcUMZ4TFUDggGBE6hb';

  before(async () => {
    this.router = await Router.new();
    this.rights = await Rights.new();
    this.router.setAddress("Rights", this.rights.address);

    this.zombies = await Zombies.new(this.rights.address, 6666);
    
    await this.rights.addAdmin(this.zombies.address, admin);
  })

  it('Should unpack potion and create adult zombie with correct owner and born/adult time', async () => {
    const instance = await Zombies.deployed();
    const instancePotions = await Potions.deployed();

    const id = 20;
    await instancePotions.createPotion(alice, 3, id, { from: admin });
    await instancePotions.open(id, { from: alice });

    const owner = await instance.ownerOf(id);
    expect(owner).to.be.equal(alice);

    const isAdult = await instance.isAdult(id);
    expect(isAdult).to.be.true;

    const bornTime = (await instance.getBornTime(id)).toNumber();
    const adultTime = (await instance.getAdultTime(id)).toNumber();
    expect(bornTime).to.be.greaterThan(0);
    expect(bornTime).to.be.equal(adultTime);
  });

  it('Should create adult zombie by admin with correct owner and born/adult time, calculate rank', async () => {
    const instance = await Zombies.deployed();

    const id = 30;
    await instance.mint(
      id,
      bob,
      [1100,1100,1100,1100,1100,1100,1100,1100,1100,1200],
      true,
      true,
      0,
      0,
      true,
      { from: admin }
    );

    const owner = await instance.ownerOf(id);
    expect(owner).to.be.equal(bob);

    const isAdult = await instance.isAdult(id);
    expect(isAdult).to.be.true;

    const bornTime = (await instance.getBornTime(id)).toNumber();
    const adultTime = (await instance.getAdultTime(id)).toNumber();
    expect(bornTime).to.be.greaterThan(0);
    expect(bornTime).to.be.equal(adultTime);

    const rank = (await instance.getRank(id)).toNumber();
    // rank is an average of props
    expect(rank).to.be.equal(1110);
  });

  it('Should throw an error creating zombie by user', async () => {
    const instance = await Zombies.deployed();

    const id = 40;
    await expectRevert(instance.mint(
      id,
      alice,
      [1100,1100,1100,1100,1100,1100,1100,1100,1100,1200],
      true,
      true,
      0,
      0,
      true,
      { from: alice }
    ), 'No rights');
  });

  it('Should throw an error, ID is claimed already', async () => {
    const instance = await Zombies.deployed();

    const id = 50;
    await instance.mint(
        id,
        alice,
        [1100,1100,1100,1100,1100,1100,1100,1100,1100,1200],
        true,
        true,
        0,
        0,
        true,
        { from: admin }
    );

    await expectRevert(instance.mint(
        id,
        alice,
        [1100,1100,1100,1100,1100,1100,1100,1100,1100,1200],
        true,
        true,
        0,
        0,
        true,
        { from: admin }
    ), 'token already minted');
  });

  it('Should have adult male placeholder in tokenURI', async () => {
    const sex = true;
    const adultTime = (await time.latest()).sub(new BN('10'));
    const id = 60;
    await this.zombies.mint(
      id,
      bob, 
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      true
  );

    const tokenURI = await this.zombies.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/am/meta.json`);
  });

  it('Should have adult female placeholder in tokenURI', async () => {
    const sex = false;
    const adultTime = (await time.latest()).sub(new BN('10'));
    const id = 70;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      true
    );

    const tokenURI = await this.zombies.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/af/meta.json`);
  });

  it('Should have kid placeholder in tokenURI if male', async () => {
    const sex = true;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 80;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      true
    );

    const tokenURI = await this.zombies.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/kid/meta.json`);
  });

  it('Should have kid placeholder in tokenURI if female', async () => {
    const sex = false;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 90;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      true
    );

    const tokenURI = await this.zombies.tokenURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/kid/meta.json`);
  });

  it('Should not allow of immaculate set both chilt and adult', async () => {
    const sex = false;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 100;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      true
    );

    await expectRevert(
      this.zombies.setMetadataHashes(id, "kid-hash-1", "adult-hash-1"), 
      "Actor: only nonimmaculate",
    );    
  });

  it('Should have right token URI after it was set when kid', async () => {
    const sex = false;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 110;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      false
    );

    const tokenURI = await this.zombies.tokenURI(id);
    const tokenURIKid = await this.zombies.tokenKidURI(id);
    const tokenURIAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/kid/meta.json`);
    expect(tokenURIKid).to.be.equal("");
    expect(tokenURIAdult).to.be.equal("");

    await this.zombies.setMetadataHashes(id, "kid-hash-1", "adult-hash-1");
    const tokenURIAfter = await this.zombies.tokenURI(id);
    const tokenURIAfterKid = await this.zombies.tokenKidURI(id);
    const tokenURIAfterAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURIAfter).to.be.equal(`ipfs://kid-hash-1`);
    expect(tokenURIAfterKid).to.be.equal(`ipfs://kid-hash-1`);
    expect(tokenURIAfterAdult).to.be.equal(`ipfs://adult-hash-1`);
  });

  it('Should have right token URI after it was set when adult', async () => {
    const sex = false;
    const adultTime = (await time.latest()).sub(new BN('100'));
    const id = 120;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      false
    );

    const tokenURI = await this.zombies.tokenURI(id);
    const tokenURIKid = await this.zombies.tokenKidURI(id);
    const tokenURIAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/af/meta.json`);
    expect(tokenURIKid).to.be.equal("");
    expect(tokenURIAdult).to.be.equal("");

    await this.zombies.setMetadataHashes(id, "kid-hash-2", "adult-hash-2");
    const tokenURIAfter = await this.zombies.tokenURI(id);
    const tokenURIAfterKid = await this.zombies.tokenKidURI(id);
    const tokenURIAfterAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURIAfter).to.be.equal(`ipfs://adult-hash-2`);
    expect(tokenURIAfterKid).to.be.equal(`ipfs://kid-hash-2`);
    expect(tokenURIAfterAdult).to.be.equal(`ipfs://adult-hash-2`);
  });

  it('Should not allow to use same metadata in different tokens', async () => {
    const sex = false;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 130;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      false
    );

    const tokenURI = await this.zombies.tokenURI(id);
    const tokenURIKid = await this.zombies.tokenKidURI(id);
    const tokenURIAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/kid/meta.json`);
    expect(tokenURIKid).to.be.equal("");
    expect(tokenURIAdult).to.be.equal("");

    await expectRevert(
      this.zombies.setMetadataHashes(id, "kid-hash-1", "adult-hash-SDFJ#FU#@Fhe"), 
      "Actor: meta already used",
    ); 
    await expectRevert(
      this.zombies.setMetadataHashes(id, "adult-hash-SDFJ#FU#@Fhe", "adult-hash-1"), 
      "Actor: meta already used",
    ); 
  });

  it('Should not allow to use same metadata in different tokens', async () => {
    const sex = false;
    const adultTime = (await time.latest()).add(new BN('100'));
    const id = 140;
    await this.zombies.mint(
      id,
      bob,
      [1253,1150,1212,1210,1216,1246,1217,1251,1158,1236],
      sex,
      true,
      adultTime,
      1,
      false
    );

    const tokenURI = await this.zombies.tokenURI(id);
    const tokenURIKid = await this.zombies.tokenKidURI(id);
    const tokenURIAdult = await this.zombies.tokenAdultURI(id);
    expect(tokenURI).to.be.equal(`ipfs://${PLACEHOLDER_HASH}/zo/kid/meta.json`);
    expect(tokenURIKid).to.be.equal("");
    expect(tokenURIAdult).to.be.equal("");

    await this.zombies.setMetadataHashes(id, "kid-hash-3", "adult-hash-3");
    
    await expectRevert(
      this.zombies.setMetadataHashes(id, "kid-hash-4", "adult-hash-4"), 
      "Actor: already set",
    ); 
  });
});
