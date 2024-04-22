const chai = require("chai");
const { expect } = chai;
const { parseEvents } = require('./events.js');
const { BN } = require('@openzeppelin/test-helpers');
chai.use(require('chai-bn')(BN));

const ManagementV2 = artifacts.require("ManagementV2");
const GamePool = artifacts.require("GamePool");

contract("ManagementV2", (accounts) => {
    const [admin1, admin2, admin3, admin4, denis, ella] = accounts;

    before(async () => {
        this.management = await ManagementV2.deployed();
        this.gamePool = await GamePool.deployed();
    });

    it('Should submit transaction', async () => {
        const callData = this.gamePool.contract.methods["setPermitter(address)"](denis).encodeABI();

        const submitted = await this.management.submitTransaction(
            this.gamePool.address, 
            callData,
            { from: admin1 }
        );
        const confirmedEvent = parseEvents(submitted).Confirmed;
        expect(confirmedEvent.sender).to.be.eq(admin1);
        expect(confirmedEvent.transactionId).to.be.bignumber.eq('0');
    });

    it('Should revoke confirmation', async () => {
        const transactionId = '0';

        const revoked = await this.management.revokeConfirmation(transactionId, { from: admin1 });

        const revokedEvent = parseEvents(revoked).Revoked;
        expect(revokedEvent.sender).to.be.eq(admin1);
        expect(revokedEvent.transactionId).to.be.bignumber.eq(transactionId);
    });

    it('Should confirm without execution', async () => {
        const transactionId = '0';

        const confirmed = await this.management.confirmTransaction(transactionId, { from: admin2 });

        const events = parseEvents(confirmed);
        const confirmedEvent = events.Confirmed;
        expect(confirmedEvent.sender).to.be.eq(admin2);
        expect(confirmedEvent.transactionId).to.be.bignumber.eq(transactionId);
    });

    it('Should confirm and execute transaction', async () => {
        const transactionId = '0';

        const confirmed = await this.management.confirmTransaction(transactionId, { from: admin3 });

        const events = parseEvents(confirmed);
        const confirmedEvent = events.Confirmed;
        const executedEvent = events.Executed;
        expect(confirmedEvent.sender).to.be.eq(admin3);
        expect(confirmedEvent.transactionId).to.be.bignumber.eq(transactionId);
        expect(executedEvent.transactionId).to.be.bignumber.eq(transactionId);
    });

    it('Should add admin', async () => {
        const callData = this.management.contract.methods["addAdmin(address)"](denis).encodeABI();

        const submitted = await this.management.submitTransaction(
            this.management.address, 
            callData,
            { from: admin1 }
        );
        const confirmed = await this.management.confirmTransaction(
            parseEvents(submitted).Submitted.transactionId,
            { from: admin2 }
        );

        const adminAddedEvent = parseEvents(confirmed).AdminAdded;
        expect(adminAddedEvent.admin).to.be.eq(denis);
    });

    it('Should remove admin', async () => {
        const callData = this.management.contract.methods["removeAdmin(address)"](denis).encodeABI();
        
        const submitted = await this.management.submitTransaction(
            this.management.address, 
            callData,
            { from: admin1 }
        );

        await this.management.confirmTransaction(
            parseEvents(submitted).Submitted.transactionId,
            { from: admin2 }
        );

        const confirmed = await this.management.confirmTransaction(
            parseEvents(submitted).Submitted.transactionId,
            { from: admin3 }
        );

        const adminRemovedEvent = parseEvents(confirmed).AdminRemoved;
        expect(adminRemovedEvent.admin).to.be.eq(denis);
    });

    it('Should replace admin', async () => {
        const oldAdmin = admin3;
        const newAdmin = admin4;
        const callData = this.management.contract
            .methods["replaceAdmin(address,address)"](oldAdmin, newAdmin)
            .encodeABI();

        const submitted = await this.management.submitTransaction(
            this.management.address, 
            callData,
            { from: admin1 }
        );
        
        const confirmed = await this.management.confirmTransaction(
            parseEvents(submitted).Submitted.transactionId,
            { from: admin2 }
        );

        const events = parseEvents(confirmed);

        const adminRemovedEvent = events.AdminRemoved;
        const adminAddedEvent = events.AdminAdded;
        expect(adminRemovedEvent.admin).to.be.eq(oldAdmin);
        expect(adminAddedEvent.admin).to.be.eq(newAdmin);
        expect(await this.management.isAdmin(oldAdmin)).to.be.not.ok;
        expect(await this.management.isAdmin(newAdmin)).to.be.ok;
    });

})