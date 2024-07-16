// SPDX-License-Identifier: PROPRIERTARY

// Author: Dmitry Kharlanchuk
// Email: kharlanchuk@scand.com

const { toWei } = require('web3-utils');
const { deployProxy } = require("@openzeppelin/truffle-upgrades");

const ERC721Mock = artifacts.require('ERC721Mock');
const ERC1155Mock = artifacts.require('ERC1155Mock');
const ERC721UpgradeableMock = artifacts.require('ERC721UpgradeableMock');
const ERC1155UpgadeableMock = artifacts.require('ERC1155UpgadeableMock');
const USDTMock = artifacts.require('USDTMock');
const Router = artifacts.require('Router');

module.exports = async function(deployer, network, addresses) {
  if (!['development', 'test', 'devnet'].includes(network) ) {
    return;
  }

  const router = await Router.at(process.env.ROUTER);

  // deploy multicall
  await web3.eth.sendTransaction({
    from: addresses[0],
    to: multicallDeployer,
    value: toWei('0.1')
  });
  const tx = await web3.eth.sendSignedTransaction(multicallRawTransaction);
  console.log(`Multicall3 deployed ${tx.transactionHash}`);

  await deployer.deploy(ERC721Mock);
  console.log(`ERC721Mock deployed ${(await ERC721Mock.deployed()).address}`);

  await deployer.deploy(ERC1155Mock);
  console.log(`ERC1155Mock deployed ${(await ERC1155Mock.deployed()).address}`);

  await deployProxy(ERC721UpgradeableMock, [ ], { deployer });
  console.log(`ERC721UpgradeableMock deployed ${(await ERC721UpgradeableMock.deployed()).address}`);

  await deployProxy(ERC1155UpgadeableMock, [ ], { deployer });
  console.log(`ERC1155UpgadeableMock deployed ${(await ERC1155UpgadeableMock.deployed()).address}`);

  await deployer.deploy(USDTMock);
  const usdtAddress = (await USDTMock.deployed()).address;
  console.log(`USDTMock deployed ${usdtAddress}`); 
  process.env.USDT = usdtAddress;

  await router.setAddress('USDTMock', usdtAddress);
  console.log(`USDTMock contract added to router with ${usdtAddress}`);
};

const multicallDeployer = '0x05f32b3cc3888453ff71b01135b34ff8e41263f2';
const multicallRawTransaction = '0xf90f538085174876e800830f42408080b9' +
'0f00608060405234801561001057600080fd5b50610ee0806100206000396000f3fe6' +
'080604052600436106100f35760003560e01c80634d2301cc1161008a578063a8b057' +
'4e11610059578063a8b0574e1461025a578063bce38bd714610275578063c3077fa91' +
'4610288578063ee82ac5e1461029b57600080fd5b80634d2301cc146101ec57806372' +
'425d9d1461022157806382ad56cb1461023457806386d516e81461024757600080fd5' +
'b80633408e470116100c65780633408e47014610191578063399542e9146101a45780' +
'633e64a696146101c657806342cbb15c146101d957600080fd5b80630f28c97d14610' +
'0f8578063174dea711461011a578063252dba421461013a57806327e86d6e1461015b' +
'575b600080fd5b34801561010457600080fd5b50425b6040519081526020015b60405' +
'180910390f35b61012d610128366004610a85565b6102ba565b604051610111919061' +
'0bbe565b61014d610148366004610a85565b6104ef565b604051610111929190610bd' +
'8565b34801561016757600080fd5b50437fffffffffffffffffffffffffffffffffff' +
'ffffffffffffffffffffffffffffff0140610107565b34801561019d57600080fd5b5' +
'046610107565b6101b76101b2366004610c60565b610690565b604051610111939291' +
'90610cba565b3480156101d257600080fd5b5048610107565b3480156101e55760008' +
'0fd5b5043610107565b3480156101f857600080fd5b50610107610207366004610ce2' +
'565b73ffffffffffffffffffffffffffffffffffffffff163190565b34801561022d5' +
'7600080fd5b5044610107565b61012d610242366004610a85565b6106ab565b348015' +
'61025357600080fd5b5045610107565b34801561026657600080fd5b5060405141815' +
'2602001610111565b61012d610283366004610c60565b61085a565b6101b761029636' +
'6004610a85565b610a1a565b3480156102a757600080fd5b506101076102b63660046' +
'10d18565b4090565b60606000828067ffffffffffffffff8111156102d8576102d861' +
'0d31565b60405190808252806020026020018201604052801561031e57816020015b6' +
'040805180820190915260008152606060208201528152602001906001900390816102' +
'f65790505b5092503660005b828110156104775760008582815181106103415761034' +
'1610d60565b6020026020010151905087878381811061035d5761035d610d60565b90' +
'5060200281019061036f9190610d8f565b60408101359586019590935061038860208' +
'50185610ce2565b73ffffffffffffffffffffffffffffffffffffffff16816103ac60' +
'60870187610dcd565b6040516103ba929190610e32565b60006040518083038185875' +
'af1925050503d80600081146103f7576040519150601f19603f3d011682016040523d' +
'82523d6000602084013e6103fc565b606091505b50602080850191909152901515808' +
'452908501351761046d577f08c379a000000000000000000000000000000000000000' +
'000000000000000000600052602060045260176024527f4d756c746963616c6c333a2' +
'063616c6c206661696c656400000000000000000060445260846000fd5b5050600101' +
'610325565b508234146104e6576040517f08c379a0000000000000000000000000000' +
'00000000000000000000000000000815260206004820152601a60248201527f4d756c' +
'746963616c6c333a2076616c7565206d69736d6174636800000000000060448201526' +
'064015b60405180910390fd5b50505092915050565b436060828067ffffffffffffff' +
'ff81111561050c5761050c610d31565b6040519080825280602002602001820160405' +
'2801561053f57816020015b606081526020019060019003908161052a5790505b5091' +
'503660005b8281101561068657600087878381811061056257610562610d60565b905' +
'06020028101906105749190610e42565b92506105836020840184610ce2565b73ffff' +
'ffffffffffffffffffffffffffffffffffff166105a66020850185610dcd565b60405' +
'16105b4929190610e32565b6000604051808303816000865af19150503d8060008114' +
'6105f1576040519150601f19603f3d011682016040523d82523d6000602084013e610' +
'5f6565b606091505b5086848151811061060957610609610d60565b60209081029190' +
'9101015290508061067d576040517f08c379a00000000000000000000000000000000' +
'0000000000000000000000000815260206004820152601760248201527f4d756c7469' +
'63616c6c333a2063616c6c206661696c6564000000000000000000604482015260640' +
'16104dd565b50600101610546565b5050509250929050565b43804060606106a08686' +
'8661085a565b905093509350939050565b6060818067ffffffffffffffff811115610' +
'6c7576106c7610d31565b60405190808252806020026020018201604052801561070d' +
'57816020015b604080518082019091526000815260606020820152815260200190600' +
'1900390816106e55790505b5091503660005b828110156104e6576000848281518110' +
'61073057610730610d60565b6020026020010151905086868381811061074c5761074' +
'c610d60565b905060200281019061075e9190610e76565b925061076d602084018461' +
'0ce2565b73ffffffffffffffffffffffffffffffffffffffff1661079060408501856' +
'10dcd565b60405161079e929190610e32565b6000604051808303816000865af19150' +
'503d80600081146107db576040519150601f19603f3d011682016040523d82523d600' +
'0602084013e6107e0565b606091505b50602080840191909152901515808352908401' +
'3517610851577f08c379a000000000000000000000000000000000000000000000000' +
'000000000600052602060045260176024527f4d756c746963616c6c333a2063616c6c' +
'206661696c656400000000000000000060445260646000fd5b50600101610714565b6' +
'060818067ffffffffffffffff81111561087657610876610d31565b60405190808252' +
'80602002602001820160405280156108bc57816020015b60408051808201909152600' +
'08152606060208201528152602001906001900390816108945790505b509150366000' +
'5b82811015610a105760008482815181106108df576108df610d60565b60200260200' +
'1015190508686838181106108fb576108fb610d60565b905060200281019061090d91' +
'90610e42565b925061091c6020840184610ce2565b73fffffffffffffffffffffffff' +
'fffffffffffffff1661093f6020850185610dcd565b60405161094d929190610e3256' +
'5b6000604051808303816000865af19150503d806000811461098a576040519150601' +
'f19603f3d011682016040523d82523d6000602084013e61098f565b606091505b5060' +
'20830152151581528715610a07578051610a07576040517f08c379a00000000000000' +
'000000000000000000000000000000000000000000081526020600482015260176024' +
'8201527f4d756c746963616c6c333a2063616c6c206661696c6564000000000000000' +
'00060448201526064016104dd565b506001016108c3565b5050509392505050565b60' +
'00806060610a2b60018686610690565b919790965090945092505050565b600080836' +
'01f840112610a4b57600080fd5b50813567ffffffffffffffff811115610a63576000' +
'80fd5b6020830191508360208260051b8501011115610a7e57600080fd5b925092905' +
'0565b60008060208385031215610a9857600080fd5b823567ffffffffffffffff8111' +
'15610aaf57600080fd5b610abb85828601610a39565b90969095509350505050565b6' +
'000815180845260005b81811015610aed57602081850181015186830182015201610a' +
'd1565b81811115610aff576000602083870101525b50601f017ffffffffffffffffff' +
'fffffffffffffffffffffffffffffffffffffffffffffe01692909201602001929150' +
'50565b600082825180855260208086019550808260051b84010181860160005b84811' +
'015610bb1578583037fffffffffffffffffffffffffffffffffffffffffffffffffff' +
'ffffffffffffe001895281518051151584528401516040858501819052610b9d81860' +
'183610ac7565b9a86019a9450505090830190600101610b4f565b5090979650505050' +
'505050565b602081526000610bd16020830184610b32565b9392505050565b6000604' +
'08201848352602060408185015281855180845260608601915060608160051b870101' +
'935082870160005b82811015610c52577ffffffffffffffffffffffffffffffffffff' +
'fffffffffffffffffffffffffffa0888703018452610c40868351610ac7565b955092' +
'84019290840190600101610c06565b509398975050505050505050565b60008060006' +
'0408486031215610c7557600080fd5b83358015158114610c8557600080fd5b925060' +
'2084013567ffffffffffffffff811115610ca157600080fd5b610cad86828701610a3' +
'9565b9497909650939450505050565b83815282602082015260606040820152600061' +
'0cd96060830184610b32565b95945050505050565b600060208284031215610cf4576' +
'00080fd5b813573ffffffffffffffffffffffffffffffffffffffff81168114610bd1' +
'57600080fd5b600060208284031215610d2a57600080fd5b5035919050565b7f4e487' +
'b71000000000000000000000000000000000000000000000000000000006000526041' +
'60045260246000fd5b7f4e487b7100000000000000000000000000000000000000000' +
'000000000000000600052603260045260246000fd5b600082357fffffffffffffffff' +
'ffffffffffffffffffffffffffffffffffffffffffffff81833603018112610dc3576' +
'00080fd5b9190910192915050565b60008083357fffffffffffffffffffffffffffff' +
'ffffffffffffffffffffffffffffffffffe1843603018112610e0257600080fd5b830' +
'18035915067ffffffffffffffff821115610e1d57600080fd5b602001915036819003' +
'821315610a7e57600080fd5b8183823760009101908152919050565b600082357ffff' +
'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc183360301' +
'8112610dc357600080fd5b600082357ffffffffffffffffffffffffffffffffffffff' +
'fffffffffffffffffffffffffa1833603018112610dc357600080fdfea26469706673' +
'58221220bb2b5c71a328032f97c676ae39a1ec2148d3e5d6f73d95e9b17910152d61f' +
'16264736f6c634300080c00331ca0edce47092c0f398cebf3ffc267f05c8e7076e3b8' +
'9445e0fe50f6332273d4569ba01b0b9d000e19b24c5869b0fc3b22b0d6fa47cd63316' +
'875cbbd577d76e6fde086';