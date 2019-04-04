module.exports = {
  networks: {
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