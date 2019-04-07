
var BookSupplyChain = artifacts.require("BookSupplyChain.sol");

var Config = async function(accounts) {
    
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x5ccc6d873cc47149a9a303332b007ba65ff3301d",
        "0x8d51e91d7ad9cb8dc70148a5b87cf3bee045fdf8",
        "0x78d379c986ea1f003ed96235121d7c53252841c3",
        "0x8ee30d49a761c901ca2818bb9d29fa0d50ba7f7d",
        "0x56d28d8080898c7696a87bac59c0d2e2329ccd08",
        "0x9d883ccf9771a115b7d862489f31fba4590b7414",
        "0xd4c0143c781b91a3a88f66e2550b1bc78161f516",
        "0x71191f8f85f138d0a91e96b0907a6a987923669f",
        "0x3b72ac7289f459588fe430c044ff0a4ed1c80344",
        "0x12194dbdaac7f155b86f990adc9a3becb0e1555b"
    ];


    let owner = accounts[0];
    let bookSP = await BookSupplyChain.new();
    
    return {
        owner,
        testAddresses,
        bookSP
    }
}

module.exports = {
    Config: Config
};