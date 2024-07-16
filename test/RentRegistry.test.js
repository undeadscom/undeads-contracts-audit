const chai = require("chai");
const { BN, time } = require('@openzeppelin/test-helpers');
const { expectRevert } = require('@openzeppelin/test-helpers');
const ether = require("@openzeppelin/test-helpers/src/ether");
const { parseEvents } = require('./events.js');
const { expect } = chai;
chai.use(require('chai-bn')(BN));

const RentRegistry = artifacts.require('RentRegistry');
const UDSToken = artifacts.require('UDSToken');
const Zombies = artifacts.require('Zombies');
const RentResolver = artifacts.require('RentResolver');

contract.only('RentRegistry', (accounts) => {
  // Alice - lender
  // Bob - renter
  const [admin, alice, bob] = accounts;

  before(async () => {
    this.registry = await RentRegistry.deployed();
    this.resolver = await RentResolver.deployed();
    this.udsToken = await UDSToken.deployed();
    this.zombies = await Zombies.deployed();

    // Give 100UDS for Alice and Bob
    await this.udsToken.transferTo(alice, ether('100'), { from: admin });
    await this.udsToken.transferTo(bob, ether('100'), { from: admin });

    // Approve NFT by Alice and Bob for RentRegistry
    this.zombies.setApprovalForAll(this.registry.address, true, { from: alice });
    this.zombies.setApprovalForAll(this.registry.address, true, { from: bob });
  })

  it('Should lend zombie', async () => {
    const zombieId = '100';
    const dailyPrice = packPrice(11.22);
    const maxRentDuration = '1';
    const paymentTokenPointer = '1';
    const autoRenew = true;
    await mintZombie.call(this, zombieId, alice);

    const lendTransaction = await this.registry.lend(
      [0],
      [this.zombies.address],
      [zombieId],
      [1],
      [maxRentDuration],
      [dailyPrice],
      [paymentTokenPointer],
      [autoRenew],
      { from: alice }
    );

    const lendEvent = parseEvents(lendTransaction).Lend;
    expect(lendEvent.is721).to.be.ok;
    expect(lendEvent.dailyRentPrice).to.be.bignumber.eq(dailyPrice);
    expect(lendEvent.lenderAddress).to.be.eq(alice);
    expect(lendEvent.lendAmount).to.be.bignumber.eq('1');
    expect(lendEvent.lendingID).to.be.bignumber.eq('1');
    expect(lendEvent.maxRentDuration).to.be.bignumber.eq(maxRentDuration);
    expect(lendEvent.tokenID).to.be.bignumber.eq(zombieId);
    expect(lendEvent.paymentToken).to.be.bignumber.eq(paymentTokenPointer);
    expect(lendEvent.willAutoRenew).to.be.eq(autoRenew);

    const newOwner = await this.zombies.ownerOf(zombieId);
    expect(newOwner).to.be.eq(this.registry.address);
  });

  it('Should not rent zombie if allowance is insufficient', async () => {
    const zombieId = 100;
    const lendingId = 1;
    const rentDuration = 1;

    await expectRevert(this.registry.rent(
      [0],                    // NFT standart (0 - ERC721, 1 - ERC1155)
      [this.zombies.address], // NFT contract address
      [zombieId],             // Token Id
      [lendingId],            // Lending Id
      [rentDuration],         // Rent duration in days
      [1],                    // Token amount (for ERC721 always 1)
      { from: bob }
    ), 'ERC20: insufficient allowance');
  });

  it('Should rent zombie', async () => {
    const zombieId = 100;
    const lendingId = 1;
    const rentDuration = 1;
    const landing = await this.registry.getLending(
      this.zombies.address,
      zombieId,
      lendingId
    );
    const price = ether(unpackPrice(landing.dailyRentPrice).toString());

    // Approve price for 1 day
    await this.udsToken.approve(this.registry.address, price, { from: bob });

    const balanceBefore = await this.udsToken.balanceOf(bob);
    const rentTransaction = await this.registry.rent(
      [0],                    // NFT standart (0 - ERC721, 1 - ERC1155)
      [this.zombies.address], // NFT contract address
      [zombieId],             // Token Id
      [lendingId],            // Lending Id
      [rentDuration],         // Rent duration in days
      [1],                    // Token amount (for ERC721 always 1)
      { from: bob }
    );
    const balanceAfter = await this.udsToken.balanceOf(bob);

    const rentEvent = parseEvents(rentTransaction).Rent;
    const rent = await this.registry.getRenting(
      this.zombies.address,
      zombieId,
      rentEvent.rentingID
    );
    expect(rentEvent.rentDuration).to.be.bignumber.eq('1');
    expect(rentEvent.renterAddress).to.be.eq(bob);
    expect(rentEvent.renterAddress).to.be.eq(rent.renterAddress);
    expect(rentEvent.rentDuration).to.be.bignumber.eq(rent.rentDuration);
    expect(rentEvent.rentAmount).to.bignumber.eq(rent.rentAmount);
    expect(rentEvent.rentedAt).to.bignumber.eq(rent.rentedAt);
    expect(balanceBefore.sub(balanceAfter)).to.be.bignumber.eq(price);
  });

  it('Should not claim if rent not finished', async () => {
    await time.increase(60);
    const zombieId = 100;
    const lendingId = 1;
    const rentingId = 1;
    await expectRevert(this.registry.claimRent(
      [0],                    // NFT standart (0 - ERC721, 1 - ERC1155)
      [this.zombies.address], // NFT contract address
      [zombieId],             // Token Id
      [lendingId],            // Lending Id
      [rentingId],            // Rent duration in days
      { from: alice }
    ), 'ReNFT::return date not passed')
  });

  it('Should claim rent', async () => {
    await time.increase(60 * 60 * 24);
    const zombieId = '100';
    const lendingId = '1';
    const rentingId = '1';
    const landing = await this.registry.getLending(
      this.zombies.address,
      zombieId,
      lendingId
    );
    const paymentToken = await this.resolver.getPaymentToken(landing.paymentToken);
    const price = ether(unpackPrice(landing.dailyRentPrice).toString());
    const feePercent = await this.registry.getRentFee(paymentToken);
    const lenderReward = price.sub(price.mul(feePercent).div(new BN('10000')));

    const balanceBefore = await this.udsToken.balanceOf(alice);
    const clamTransaction = await this.registry.claimRent(
      [0],                    // NFT standart (0 - ERC721, 1 - ERC1155)
      [this.zombies.address], // NFT contract address
      [zombieId],             // Token Id
      [lendingId],            // Lending Id
      [rentingId],            // Rent duration in days
      { from: alice }
    );
    const balanceAfter = await this.udsToken.balanceOf(alice);

    const claimedEvent = parseEvents(clamTransaction).RentClaimed;
    expect(claimedEvent.rentingID).to.be.bignumber.eq(rentingId);
    expect(balanceAfter.sub(balanceBefore)).to.be.bignumber.eq(lenderReward);
  });

  it('Should stop lend', async () => {
    const zombieId = '100';
    const lendingId = '1';
    
    const stopTransaction = await this.registry.stopLend(
      [0],                    // NFT standart (0 - ERC721, 1 - ERC1155)
      [this.zombies.address], // NFT contract address
      [zombieId],             // Token Id
      [lendingId],            // Lending Id
      { from: alice }
    );

    const stopEvent = parseEvents(stopTransaction).StopLend;
    expect(stopEvent.lendingID).to.be.bignumber.eq(lendingId);
  });

  async function mintZombie(id, owner) {
    await this.zombies.mint(
      id,
      owner,
      [1100,1100,1100,1100,1100,1100,1100,1100,1100,1200],
      true,
      true,
      0,
      0,
      true,
      { from: admin }
    );
  }

  // This function converts a decimal number to a 4 byte hex string
  function packPrice(price) {
    const parts = price.toString().split('.');
    const whole = parts[0];
    const decimal = parts[1] ?? '0';
    if (whole.length > 4) {
      throw new Error('Price per day cannot be more than 9999.9999');
    }
    if (decimal.length > 4) {
      throw new Error('The fractional part cannot be longer than 4 characters');
    }
    return '0x' +
      parseInt(whole).toString(16).padStart(4, '0') +
      parseInt(decimal.padEnd(4, '0')).toString(16).padStart(4, '0');
  }

  // This function converts 4 byte hex string to a decimal number
  function unpackPrice(price) {
    if (!price.startsWith('0x') || price.length != 10) {
      throw new Error('Invalid input. Expected 4 byte hex string.');
    }
    const whole = parseInt(price.substring(0, 6), 16);
    const decimal = parseInt(price.substring(6), 16).toString().padStart(4, '0');
    return parseFloat(whole + '.' + decimal);
  }
});
