const chai = require("chai");
const { BN, time } = require("@openzeppelin/test-helpers");
const ether = require("@openzeppelin/test-helpers/src/ether");
const { parseEvents } = require("./events.js");
const { expect } = chai;
chai.use(require("chai-bn")(BN));

const Staking = artifacts.require("Staking");
const UDSToken = artifacts.require("UDSToken");
const Zombies = artifacts.require("Zombies");

contract("Staking", (accounts) => {
  const [admin, alice, bob, clara, denis] = accounts;

  before(async () => {
    this.staking = await Staking.deployed();
    this.udsToken = await UDSToken.deployed();
    this.zombies = await Zombies.deployed();

    // Give 1000UDS for Alice and Bob
    await this.udsToken.transferTo(alice, ether("1000"), { from: admin });
    await this.udsToken.transferTo(bob, ether("1000"), { from: admin });

    this.stakingIntervals = await this.staking.getMonthIntervals();
    this.stakingIntervalCoefficients = await this.staking.getIntervalCoefficients();
    this.stakingBoostCoefficients = await this.staking.getBoostCoefficients();
  });

  it("Should stake 100 UDS", async () => {
    const stakingAmount = BN('100'); // no zeros after the decimal point
    const interval = '0';

    // approve tokens for staking contract
    await this.udsToken.approve(this.staking.address, ether(stakingAmount), {
      from: alice,
    });
    const stakeTransaction = await this.staking.stake(stakingAmount, interval, {
      from: alice,
    });

    const addedEvent = parseEvents(stakeTransaction).StakeAdded;
    expect(addedEvent.staker).to.be.eq(alice);
    expect(addedEvent.zombieId).to.be.bignumber.eq('0');
    expect(addedEvent.boostCoefficient).to.be.bignumber.eq('100');

    const stakingId = addedEvent.stakeId;
    const userStaking = await this.staking.getStake(stakingId);
    const sharesExpect = stakingAmount.mul(this.stakingIntervalCoefficients[interval]).mul(BN('100'));

    expect(userStaking.amount).to.be.bignumber.eq(stakingAmount);
    expect(userStaking.shares).to.be.bignumber.eq(sharesExpect);

    const now = await time.latest();
    const estimatedFinish = now.add(this.stakingIntervals[interval].mul(BN(30 * 86400)));
    expect(BN(userStaking.lockedUntil)).to.be.bignumber.eq(estimatedFinish);
    expect(userStaking.interval).to.be.bignumber.eq(interval);


  });

  it("Should add another stake with owned zombie", async () => {
    const stakingAmount = BN('200');
    const interval = '1';
    const zombieId = '100';
    const zomblieLevel = 0;
    await mintZombie.call(this, zombieId, alice);

    // approve tokens for staking contract
    await this.udsToken.approve(this.staking.address, ether(stakingAmount), {
      from: alice,
    });
    const stakeTransaction = await this.staking.stakeByZombieOwner(stakingAmount, interval, zombieId, {
      from: alice,
    });

    const addedEvent = parseEvents(stakeTransaction).StakeAdded;
    expect(addedEvent.staker).to.be.eq(alice);
    expect(addedEvent.zombieId).to.be.bignumber.eq(zombieId);
    expect(addedEvent.boostCoefficient).to.be.bignumber.eq(this.stakingBoostCoefficients[0]);

    const stakingId = addedEvent.stakeId;
    const userStaking = await this.staking.getStake(stakingId);
    const sharesExpect = stakingAmount.mul(this.stakingIntervalCoefficients[interval])
      .mul(this.stakingBoostCoefficients[zomblieLevel]);

    expect(BN(userStaking.amount)).to.be.bignumber.eq(stakingAmount);
    expect(BN(userStaking.shares)).to.be.bignumber.eq(sharesExpect);

    const now = await time.latest();
    const estimatedFinish = now.add(this.stakingIntervals[interval].mul(BN(30 * 86400)));
    expect(userStaking.lockedUntil).to.be.bignumber.eq(estimatedFinish);
    expect(userStaking.interval).to.be.bignumber.eq(interval);
  });

  it("Should claim 100 UDS with rewards", async () => {
    // add 10UDS to reward pool
    await this.udsToken.transferTo(this.staking.address, ether("10"), { from: admin });

    const stakingId = '1';
    await time.increase(this.stakingIntervals[0].mul(BN(30 * 86400 + 1))); // skip staking time interval

    const stakingAmount = ether((await this.staking.getStake(stakingId)).amount);
    const expectedRewards = await this.staking.rewardOf(stakingId);
    const claimTransaction = await this.staking.claim(stakingId, {
      from: alice,
    });

    const claimedEvent = parseEvents(claimTransaction).StakeClaimed;
    expect(claimedEvent.staker).to.be.eq(alice);
    expect(claimedEvent.totalAmount).to.be.bignumber.eq(stakingAmount.add(expectedRewards));

    const userStaking = await this.staking.getStake(stakingId);
    expect(userStaking.amount).to.be.bignumber.eq('0');
  });

  it("Should claim 200 UDS with rewards with max APR", async () => {
    await this.udsToken.transferTo(this.staking.address, ether("10000"), { from: admin });
    
    const stakingId = 2;
    const staking = await this.staking.getStake(stakingId);
    const maxApr = await this.staking.getMaxApr();
    await time.increase(this.stakingIntervals[staking.interval].mul(BN(30 * 86400 + 1))); // skip staking time interval

    const claimTransaction = await this.staking.claim(stakingId, {
      from: alice,
    });

    const claimedEvent = parseEvents(claimTransaction).StakeClaimed;
    expect(claimedEvent.staker).to.be.eq(alice);
    expect(claimedEvent.stakeId).to.be.bignumber.eq(BN(stakingId));

    const unwrappedStakingAmount = BN(staking.amount).mul(ether('1'));
    const maxReward = this.stakingIntervals[staking.interval]
      .mul(unwrappedStakingAmount)
      .mul(BN(maxApr))
      .div(BN('120000'))
      .add(unwrappedStakingAmount);
    expect(claimedEvent.totalAmount).to.be.bignumber.eq(maxReward);
  });

  async function mintZombie(id, owner) {
    await this.zombies.mint(
      id,
      owner,
      [1100, 1100, 1100, 1100, 1100, 1100, 1100, 1100, 1100, 1200],
      true,
      true,
      0,
      0,
      true,
      { from: admin }
    );
  }
});
