const { hdkey } = require('ethereumjs-wallet'); // https://www.npmjs.com/package/ethereumjs-wallet
const { BN } = require('ethereumjs-util'); // https://www.npmjs.com/package/ethereumjs-util
const bip39 = require("bip39"); // https://www.npmjs.com/package/bip39

// https://github.com/ethereumjs/ethereumjs-wallet/tree/master/docs
// https://github.com/ethereumjs/ethereumjs-monorepo/tree/master/packages/util/docs
// https://dev.to/dongri/ethereum-wallet-sample-code-10o2
let env = (process.argv.length < 3) ? 'BIP39_MNEMONIC' : process.argv[2]
console.log(env);
if(!process.env[env]){
  console.error(`No valild mnemonic at the specified environment variable : ${env}, ${process.env[env]}`);
  process.exit(401);
}
const mnemonic = process.env[env];
const rootKey = hdkey.fromMasterSeed(bip39.mnemonicToSeedSync(mnemonic));
const parentKey = rootKey.derivePath("m/44'/60'/0'/0");

const output = {};
output.menomic = mnemonic;
output.baseKey = parentKey.getWallet().getPrivateKeyString();
output.keyPairs = [];
for(let i = 0; i < 20; i++){
  let wallet = parentKey.deriveChild(i).getWallet();
  let keyPair = {};
  keyPair.privateKey = wallet.getPrivateKeyString();
  keyPair.privateKeyInt = new BN(wallet.getPrivateKey(), 10).toString(10);
  keyPair.publicKey = wallet.getPublicKeyString();
  keyPair.publicKeyInt = new BN(wallet.getPublicKey(), 10).toString(10);
  keyPair.address = wallet.getChecksumAddressString();
  output.keyPairs.push(keyPair);
}
console.log(JSON.stringify(output, null, 2));
