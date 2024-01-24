const chai = require("chai");
const { expect } = chai;

const Randomizer = artifacts.require("LehmerRandomizer");

contract("LehmerRandomizer", () => {

  it("Should return ~50% 0 and 1 values", async () => {
      const instance = await Randomizer.deployed();  
      const outs=[];
      for (var j = 0; j < 100; j++) {
        await instance.randomize();
        outs.push(Number((await instance.last()).toString()));
      }
      const odds = outs.filter(a => a == 0).length;
      const evens = outs.filter(a => a == 1).length;
      const diff = Math.abs(odds-evens);
      console.log('odds', odds);
      console.log('evens', evens);
      console.log('diff', diff);
      expect(diff).to.be.below(20, 'Too differs');
  });
});
