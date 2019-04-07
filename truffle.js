const HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "scale suit normal possible arm boost ridge blame orphan pilot rigid quit";

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
            websockets: true,
            gas: 9999999
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