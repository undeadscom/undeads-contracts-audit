const chai = require("chai");
const { MerkleTree } = require('merkletreejs');
const { BN, expectRevert, time } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));
const { expect } = chai;

const Router = artifacts.require("Router");
const Rights = artifacts.require("Rights");
const Vesting = artifacts.require("Vesting");
const UDSToken = artifacts.require("UDSToken");

contract("Vesting", (accounts) => {
  const [admin, alice, richard, alan, ella, someAddress] = accounts;

  const generateMerkleTree = (distributions) => {
      const leafNodes = distributions.map(d => {
          return web3.utils.encodePacked(
              {value: d.address, type: 'address'},
              {value: d.key, type: 'uint256'},
              {value: d.intervalId, type: 'uint256'},
              {value: d.intervalTimestamp, type: 'uint256'},
              {value: d.amount, type: 'uint256'},
          );
      }).map((buffer) => {
          return web3.utils.keccak256(buffer);
      })

    return {
      leafNodes,
      tree: new MerkleTree(leafNodes, web3.utils.keccak256, { sortPairs: true }),
    };
  }

  beforeEach(async () => {
    this.rights = await Rights.new();
    this.router = await Router.new();
    this.udsToken = await UDSToken.deployed();
    await this.router.setAddress('Rights', this.rights.address);

    this.vesting = await Vesting.new(this.rights.address, this.udsToken.address);
    await this.rights.addAdmin(this.vesting.address, admin);
  })

  it('should have possibility to add more than 9 vestings', async () => {
    const rootHex = '0x657468657265756d000000000000000000000000000000000000000000000000';
    for (let index = 0; index < 9; index++) {
      await this.vesting.updateRoot(index, rootHex, { from: admin });
    }
    for (let index = 0; index < 9; index++) {
      const gotRoot = await this.vesting.root(index);
      expect(gotRoot).to.be.equal(rootHex);
    }
  });

  it('should have possibility to new vesting only by user who has rights', async () => {
    const rootHex = '0x657468657265756d000000000000000000000000000000000000000000000000';
    await expectRevert(
      this.vesting.updateRoot(0, rootHex, { from: ella }),
      'Guard: No rights'
    );
  });

  it('should have possibility to update token only by user who has rights', async () => {
    await expectRevert(
      this.vesting.updateToken(someAddress, { from: ella }),
      'Guard: No rights'
    );
  });

  it('should have possibility to unpause/upause vesting only by user who has rights', async () => {
    await expectRevert(
      this.vesting.unpause({ from: ella }),
      'Guard: No rights'
    );
    await expectRevert(
      this.vesting.pause({ from: ella }),
      'Guard: No rights'
    );
  });

  it('should have possibility to claim only intervals that unlocked', async () => {
    const currentTimestamp = await time.latest();
    const intervalTimestamps = [100, 300, 400, 600].map(intervalOffset => currentTimestamp.add(new BN(`${intervalOffset}`)));
    const amounts = [150, 350, 450, 650];
    const key = 0;
    const fullAmount = amounts.reduce((acum, next) => acum+next, 0);
    await this.udsToken.transferTo(this.vesting.address, fullAmount);
    const balanceBeforeClaim = await this.udsToken.balanceOf(alice);
    expect(balanceBeforeClaim).to.be.bignumber.equal('0')

    const nodes = intervalTimestamps.map((intervalTimestamp, index) => {
      return {
        key: 0,
        address: alice,
        intervalId: index,
        intervalTimestamp,
        amount: amounts[index],
      };
    });
    const { leafNodes, tree } = generateMerkleTree(nodes);
    await this.vesting.updateRoot(key, tree.getHexRoot(), { from: admin });

    let interval = 0;
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: too early for claim'
    );

    // Somebody can claim tokens for me and pay for gas for me
    await time.increaseTo(intervalTimestamps[interval]);
    await this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
      alice,
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      )
    );
    const balanceAfterClaim = await this.udsToken.balanceOf(alice);
    expect(balanceAfterClaim).to.be.bignumber.equal(amounts[interval].toString());

    interval = 1;
    // I can't claim second portion of tokens if interval not met
    await expectRevert(
      this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: too early for claim'
    );

    // I can't claim not my tokens to my account
    await time.increaseTo(intervalTimestamps[interval]);
    await expectRevert(
      this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: invalid proof'
    );

    // I should have possibility to claim my tokens
    await this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );
    const balanceAfterClaim2 = await this.udsToken.balanceOf(alice);
    expect(balanceAfterClaim2).to.be.bignumber.equal((amounts[interval-1]+amounts[interval]).toString());
  });

  it('should have possibility to set more then 256 intervals', async () => {
    const currentTimestamp = await time.latest();
    const intervalTimestamps = [];
    const amounts = [];
    for (let i = 1; i < 301; ++i) {
      intervalTimestamps.push(currentTimestamp.add(new BN(`${i * 100}`)));
      amounts.push(i * 150);
    }
    const key = 0;
    const fullAmount = amounts.reduce((acum, next) => acum+next, 0);
    await this.udsToken.transferTo(this.vesting.address, fullAmount);
    const balanceBeforeClaim = await this.udsToken.balanceOf(alice);

    const nodes = intervalTimestamps.map((intervalTimestamp, index) => {
      return {
        key: 0,
        address: alice,
        intervalId: index,
        intervalTimestamp,
        amount: amounts[index],
      };
    });
    const { leafNodes, tree } = generateMerkleTree(nodes);
    const updated = await this.vesting.updateRoot(key, tree.getHexRoot(), { from: admin });

    let interval = 0;
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: too early for claim'
    );

    // Somebody can claim tokens for me and pay for gas for me
    await time.increaseTo(intervalTimestamps[interval]);
    await this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
      alice,
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      )
    );
    const balanceAfterClaim = await this.udsToken.balanceOf(alice);
    expect(balanceAfterClaim.sub(balanceBeforeClaim)).to.be.bignumber.equal(amounts[interval].toString());

    interval = 1;
    // I can't claim second portion of tokens if interval not met
    await expectRevert(
      this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: too early for claim'
    );

    // I can't claim not my tokens to my account
    await time.increaseTo(intervalTimestamps[interval]);
    await expectRevert(
      this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: invalid proof'
    );

    const balanceBeforeClaim2 = await this.udsToken.balanceOf(alice);
    interval = 299;
    await time.increaseTo(intervalTimestamps[interval]);
    // I should have possibility to claim my tokens
    await this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );
    const balanceAfterClaim2 = await this.udsToken.balanceOf(alice);
    expect(balanceAfterClaim2.sub(balanceBeforeClaim2)).to.be.bignumber.equal((amounts[interval]).toString());
  });

  it('should have possibility to claim different orders', async () => {
    const currentTimestamp = await time.latest();
    const intervalTimestamps = [100, 300, 400, 600].map(intervalOffset => currentTimestamp.add(new BN(`${intervalOffset}`)));
    const amounts = [150, 350, 450, 650];
    const key = 0;
    const fullAmount = amounts.reduce((acum, next) => acum+next, 0);
    await this.udsToken.transferTo(this.vesting.address, fullAmount);
    const balanceBeforeClaim = await this.udsToken.balanceOf(alice);

    const nodes = intervalTimestamps.map((intervalTimestamp, index) => {
      return {
        key: 0,
        address: alice,
        intervalId: index,
        intervalTimestamp,
        amount: amounts[index],
      };
    });
    const { leafNodes, tree } = generateMerkleTree(nodes);
    await this.vesting.updateRoot(key, tree.getHexRoot(), { from: admin });

    let interval = 3;
    await time.increaseTo(intervalTimestamps[interval]);
    // claim for interval 3
    await this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
      alice,
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );

    // claim for interval 2
    interval = 2;
    await this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );

    // claim for interval 0
    interval = 0;
    await this.vesting.methods['claim(uint256,uint256,uint256,uint256,bytes32[])'](
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );

    const balanceAfterClaim = await this.udsToken.balanceOf(alice);
    expect(balanceAfterClaim.sub(balanceBeforeClaim)).to.be.bignumber.equal((amounts[0]+amounts[2]+amounts[3]).toString());
  });

  it('should not allow to withdraw tokens if the proof is not correct', async () => {
    const currentTimestamp = await time.latest();
    const intervalTimestamps = [100, 300, 400, 600].map(intervalOffset => currentTimestamp.add(new BN(`${intervalOffset}`)));
    const amounts = [150, 350, 450, 650];
    const key = 0;
    const fullAmount = amounts.reduce((acum, next) => acum+next, 0);
    await this.udsToken.transferTo(this.vesting.address, fullAmount);

    const nodes = intervalTimestamps.map((intervalTimestamp, index) => {
      return {
        key: 0,
        address: alice,
        intervalId: index,
        intervalTimestamp,
        amount: amounts[index],
      };
    });
    const { leafNodes, tree } = generateMerkleTree(nodes);
    await this.vesting.updateRoot(key, tree.getHexRoot(), { from: admin });

    let interval = 0;
    await time.increaseTo(intervalTimestamps[interval]);
    // wrong key
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key+1,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: invalid proof'
    );

    // wrong interval
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval+1,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: invalid proof'
    );

    // wrong timestamp
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval+1],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: too early for claim'
    );

    // wrong amount
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval+1],
        tree.getHexProof(
            leafNodes[interval],
        )
      ),
      'Vesting: invalid proof'
    );

    // wrong proof
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval+1],
        )
      ),
      'Vesting: invalid proof'
    );
  });

  it('should not have possibility to claim twice the same interval', async () => {
    const currentTimestamp = await time.latest();
    const intervalTimestamps = [100, 300, 400, 600].map(intervalOffset => currentTimestamp.add(new BN(`${intervalOffset}`)));
    const amounts = [150, 350, 450, 650];
    const key = 0;
    const fullAmount = amounts.reduce((acum, next) => acum+next, 0);
    await this.udsToken.transferTo(this.vesting.address, fullAmount);
    const balanceBeforeClaim = await this.udsToken.balanceOf(alice);

    const nodes = intervalTimestamps.map((intervalTimestamp, index) => {
      return {
        key: 0,
        address: alice,
        intervalId: index,
        intervalTimestamp,
        amount: amounts[index],
      };
    });
    const { leafNodes, tree } = generateMerkleTree(nodes);
    await this.vesting.updateRoot(key, tree.getHexRoot(), { from: admin });

    let interval = 3;
    await time.increaseTo(intervalTimestamps[interval]);
    // first claim
    await this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
      alice,
      key,
      interval,
      intervalTimestamps[interval],
      amounts[interval],
      tree.getHexProof(
          leafNodes[interval],
      ),
      { from: alice },
    );

    // second claim
    await expectRevert(
      this.vesting.methods['claim(address,uint256,uint256,uint256,uint256,bytes32[])'](
        alice,
        key,
        interval,
        intervalTimestamps[interval],
        amounts[interval],
        tree.getHexProof(
            leafNodes[interval],
        ),
        { from: alice },
      ),
      'Vesting: already claimed'
    );
  });
})