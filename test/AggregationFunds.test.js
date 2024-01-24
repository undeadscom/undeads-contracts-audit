const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const chai = require("chai");
const { BN } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;

  const AggregationFunds = artifacts.require("AggregationFunds");
  const MarketplaceTreasury = artifacts.require("MarketplaceTreasury");
  const Rights = artifacts.require("Rights");
  const Router = artifacts.require("Router");
  const UDSToken = artifacts.require("UDSToken");
  const UGoldToken = artifacts.require("UGoldToken");
  const Zombies = artifacts.require("Zombies");

contract("AggregationFunds", (accounts) => {
  const [bob, alice, richard, alan, hotWallet, coldWallet] = accounts;
  const ethAddress = '0x0000000000000000000000000000000000000000';


  before(async () => {
    this.router = await Router.new();
    this.rights = await Rights.new();
    await this.router.setAddress("Rights", this.rights.address);

    this.marketplaceTreasury = await MarketplaceTreasury.new(this.rights.address);
    this.zombies = await Zombies.new(this.rights.address, 6666);
    this.uds = await UDSToken.new('10000000000000000000', this.rights.address);
    this.ugold = await UGoldToken.new('10000000000000000000', this.rights.address);
    await this.router.setAddress("UDSToken", this.uds.address);
    await this.router.setAddress("UGoldToken", this.ugold.address);

    const claimableEthContracts = [this.marketplaceTreasury.address];
    const claimableUDSContracts = [this.marketplaceTreasury.address];
    const claimableUGLDContracts = [this.marketplaceTreasury.address];

    this.aggregationFunds = await deployProxy(
      AggregationFunds,
      [
        claimableEthContracts,
        claimableUDSContracts,
        claimableUGLDContracts,
        this.rights.address,
        this.uds.address,
        this.ugold.address,
      ],
      { from: alice }
    );

    // set rights
    await this.rights.addAdmin(this.uds.address, bob);
    await this.rights.addAdmin(this.ugold.address, bob);
    await this.rights.addAdmin(this.marketplaceTreasury.address, bob);
    await this.rights.addAdmin(this.zombies.address, bob);
    await this.rights.addAdmin(this.aggregationFunds.address, bob);

    const haveRights = await this.rights.haveRights(this.marketplaceTreasury.address, bob);
    expect(haveRights).to.equal(true);
    
    await this.marketplaceTreasury.approvePayment(this.uds.address, true);
    await this.marketplaceTreasury.approvePayment(this.ugold.address, true);
    await this.marketplaceTreasury.approvePayment(ethAddress, true);

    await this.aggregationFunds.setHotWallet(hotWallet);
    await this.aggregationFunds.setColdWallet(coldWallet);

    await this.aggregationFunds.setMinMax(this.uds.address, 2, 5);
    await this.aggregationFunds.setMinMax(this.ugold.address, 2, 5);
    await this.aggregationFunds.setMinMax(ethAddress, 2, 5);

    // send some tokens
    await this.uds.transferTo(bob, '1000');
    await this.ugold.transferTo(bob, '1000');
  })

  it("should init contracts in the right way", async () => {
    const totalSupply = await this.uds.totalSupply()
    expect(totalSupply).to.be.bignumber.equal('10000000000000000000');
    const coldWalletUDS = await this.uds.balanceOf(coldWallet);
    const coldWalletUGLD = await this.ugold.balanceOf(coldWallet);
    // const coldWalletETH = await this.uds.balanceOf(coldWallet);
    expect(coldWalletUDS).to.be.bignumber.equal('0');
    expect(coldWalletUGLD).to.be.bignumber.equal('0');

    const isApprovedUDS = await this.marketplaceTreasury.isPaymentAssetApproved(this.uds.address);
    expect(isApprovedUDS).to.equal(true);
    const isApprovedUGOLD = await this.marketplaceTreasury.isPaymentAssetApproved(this.ugold.address);
    expect(isApprovedUGOLD).to.equal(true);

    const minMaxUDS = await this.aggregationFunds.getMinMax(this.uds.address);
    const minMaxUGold = await this.aggregationFunds.getMinMax(this.ugold.address);
    const minMaxEth = await this.aggregationFunds.getMinMax(ethAddress);
    expect(minMaxUDS[0]).to.be.bignumber.equal('2');
    expect(minMaxUDS[1]).to.be.bignumber.equal('5');
    expect(minMaxUGold[0]).to.be.bignumber.equal('2');
    expect(minMaxUGold[1]).to.be.bignumber.equal('5');
    expect(minMaxEth[0]).to.be.bignumber.equal('2');
    expect(minMaxEth[1]).to.be.bignumber.equal('5');
  });

  it("should aggregate uds funds from marketplace treasury", async () => {
    // add funds for aggregationFunds contract
    await this.uds.transfer(this.marketplaceTreasury.address, 10);
    await this.marketplaceTreasury.addFunds(this.uds.address, this.aggregationFunds.address, 10);
    const availableToClaimBefore = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.uds.address);
    expect(availableToClaimBefore).to.be.bignumber.equal('10');

    // action
    await this.aggregationFunds.withdraw();

    // checks
    const availableToClaimAfter = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.uds.address);
    expect(availableToClaimAfter).to.be.bignumber.equal('0');
    const coldWalletUDS = await this.uds.balanceOf(coldWallet);
    expect(coldWalletUDS).to.be.bignumber.equal('5');
    const hotWalletUDS = await this.uds.balanceOf(hotWallet);
    expect(hotWalletUDS).to.be.bignumber.equal('5');

    // add funds for aggregationFunds contract
    await this.uds.transfer(this.marketplaceTreasury.address, 10);
    await this.marketplaceTreasury.addFunds(this.uds.address, this.aggregationFunds.address, 10);

    // second action
    await this.aggregationFunds.withdraw();

    // checks
    const availableToClaimAfter2 = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.uds.address);
    expect(availableToClaimAfter2).to.be.bignumber.equal('0');
    const coldWalletUDS2 = await this.uds.balanceOf(coldWallet);
    expect(coldWalletUDS2).to.be.bignumber.equal('15');
    const hotWalletUDS2 = await this.uds.balanceOf(hotWallet);
    expect(hotWalletUDS2).to.be.bignumber.equal('5');
  });

  it("should aggregate ugold funds from marketplace treasury", async () => {
    // add funds for aggregationFunds contract
    await this.ugold.transfer(this.marketplaceTreasury.address, 10);
    await this.marketplaceTreasury.addFunds(this.ugold.address, this.aggregationFunds.address, 10);
    const availableToClaimBefore = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.ugold.address);
    expect(availableToClaimBefore).to.be.bignumber.equal('10');

    // action
    await this.aggregationFunds.withdraw();

    // checks
    const availableToClaimAfter = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.ugold.address);
    expect(availableToClaimAfter).to.be.bignumber.equal('0');
    const coldWalletUDS = await this.ugold.balanceOf(coldWallet);
    expect(coldWalletUDS).to.be.bignumber.equal('5');
    const hotWalletUDS = await this.ugold.balanceOf(hotWallet);
    expect(hotWalletUDS).to.be.bignumber.equal('5');

    // add funds for aggregationFunds contract
    await this.ugold.transfer(this.marketplaceTreasury.address, 10);
    await this.marketplaceTreasury.addFunds(this.ugold.address, this.aggregationFunds.address, 10);

    // second action
    await this.aggregationFunds.withdraw();

    // checks
    const availableToClaimAfter2 = await this.marketplaceTreasury.availableToClaim(this.aggregationFunds.address, this.ugold.address);
    expect(availableToClaimAfter2).to.be.bignumber.equal('0');
    const coldWalletUDS2 = await this.ugold.balanceOf(coldWallet);
    expect(coldWalletUDS2).to.be.bignumber.equal('15');
    const hotWalletUDS2 = await this.ugold.balanceOf(hotWallet);
    expect(hotWalletUDS2).to.be.bignumber.equal('5');
  });
});