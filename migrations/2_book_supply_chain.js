var Book = artifacts.require("./BookSupplyChain.sol");

module.exports = function(deployer) {
    deployer.deploy(Book);
};