/*
* NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
* function when declaring them. Failure to do so will cause commands to hang. ex:
* ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
const HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "scale suit normal possible arm boost ridge blame orphan pilot rigid quit";
//TODO - this is default address created from mnemonic above
//TODO - rinkeby transaction for 3 ether
// https://rinkeby.etherscan.io/address/TODO - contract on rinkeby
module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    compilers: {
        solc: {
            version: "^0.5.2"
        }
    },
    networks: {
        development_cli: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            websockets: true
        },
        development_ui: {
            host: "127.0.0.1",
            port: 7545,
            network_id: 5777
        },
        rinkeby: {
            provider: function() {
                return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/2b74d3c874324bd9a18a6d658831bb5b");
            },
            network_id: 4,
            gas: 7000000,
            gasPrice: 10000000000
        }
    }
};