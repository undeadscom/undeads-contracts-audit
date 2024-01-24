// https://github.com/trufflesuite/truffle/tree/v5.1.5/packages/hdwallet-provider
// https://web3js.readthedocs.io/en/v1.3.0/web3.html#providers
// https://iancoleman.io/bip39/
require('dotenv').config({ path: process.env.NODE_ENV ?  `.env.${process.env.NODE_ENV}` : '.env' });

const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3HttpProvider = require('web3-providers-http');

// Read properties for local standalone Ganache CLI node
const mnemonic = process.env.BIP39_MNEMONIC;

// https://www.npmjs.com/package/web3-providers-http
const defaultHttpOptions = {
  keepAlive: true, timeout: 100000
}

module.exports = {

  // https://www.trufflesuite.com/docs/truffle/reference/configuration#networks
  // https://github.com/trufflesuite/truffle/tree/develop/packages/hdwallet-provider#general-usage
  // https://www.npmjs.com/package/web3-providers-http
  // https://www.npmjs.com/package/web3-providers-ws
  // https://web3js.readthedocs.io/en/v1.7.0/web3.html#providers
  networks: {

    test: {
      network_id: '*',
      port: 8545,
      total_accounts: 20,
      hardfork: 'shanghai',
      gasLimit: 30000000,
      gasPrice: 2000000000
    },

    mainnet: {
      provider: () => new HDWalletProvider({
        chainId: 1,
        mnemonic: mnemonic,
        providerOrUrl: new Web3HttpProvider("https://nd-873-799-561.p2pify.com/b45859045712330cab06d7a88ab97964", defaultHttpOptions),
        pollingInterval: 16000
      }),
      networkCheckTimeout: 999999, 
      network_id: '1',
      skipDryRun: true,
      disableConfirmationListener: true
    },
  },

  // Set default mocha options here, use special reporters etc.
  // https://github.com/mochajs/mocha/blob/v8.1.2/lib/mocha.js#L97
  // https://mochajs.org/#command-line-usage
  // https://mochajs.org/api/mocha
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions: {
      currency: "USD",
    },
    color: true,
    fullTrace: true,
    noHighlighting: false,
    timeout: 600000,
    parallel: false
  },

  // Configure your compilers
  // https://www.trufflesuite.com/docs/truffle/reference/configuration#compiler-configuration
  // https://docs.soliditylang.org/en/v0.8.13/using-the-compiler.html
  compilers: {
    solc: {
      version: "0.8.17",  // https://github.com/trufflesuite/truffle/releases/tag/v5.2.0
      settings: {
        viaIR: true,
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    },
  },

  plugins: [
    'truffle-plugin-stdjsonin',
    'truffle-plugin-verify',
    'truffle-plugin-verify-proxy'
  ],
};
