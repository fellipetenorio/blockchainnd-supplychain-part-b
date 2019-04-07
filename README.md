# blockchainnd-supplychain-part-b
Project for Part B of Term 2 Blockchain Udacity Nanodeegre Supply Chain project

For more information about Udacity BLockchain Developer Nanodegree check the [site](https://www.udacity.com/course/blockchain-developer-nanodegree--nd1309).
Some code from [here](https://github.com/udacity/nd1309-Project-6b-Example-Template) was imported to the contract.

**Describe a Supply Chain using Blockchain for the process of writing and selling a book. Since the abract and book approval to proced until the delivery to libraries.**

To install the dependencies run:
```
npm i
```

Then the http server
```
node index.js
```
open your brower in [http://localhost], can change the port by a variable with the same name.

Resources:
1. **UML Diagrams** (`diagram` folder)
1. **Smart Contract** (`contracts` folder)
1. **WebServer**

#UML Diagrams

*Contain the following Diagrams that describes the Smart Contract:*

1. Book Writing - Activity Diagram
1. Book Writing - Sequence Diagram
1. Book Writing - State Diagram
1. Book Writing - Classes Diagram

#Smart Contract
A Smart Contract was developed using [Solidity](https://solidity.readthedocs.io/en/v0.5.6/) and the [Ethereum Blockchain](https://www.ethereum.org/)

To develop this Smart Contract was used:
1. Truffle Ganache to create a local blockchain. 
   1. Some issues forced the use of JavaScript VM Env for payable method, see more [here](https://github.com/trufflesuite/ganache-cli/issues/497)
   1. to start Ganache with the same mnemonic (notice the high limit gas) (dev purpose only, DO NOT USE THIS IN PRODUCTION!):
      1. `ganache-cli -m "scale suit normal possible arm boost ridge blame orphan pilot rigid quit"  -l 999999999999`
1. Remix IDE to code solidity (.sol) files
   1. To compile and SYNC with local files the remixd npm module was used, see more details [here](https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html):
      1. `remixd -s <absolute-path-to-the-shared-folder> --remix-ide https://remix.ethereum.org`
   
For dev mode Ganache was used with one account per Role, when deployed in Rinkeby network only one account was used to reproduce the Roles.
### Smart Contract Rinkeby address:
You can set the Smart Contract address:
```
public/js/apps.js:5
```
The current address seted is:
>https://rinkeby.etherscan.io/address/0x3d72b0afe217b64a3d1885b13bad87baa7afbc8b

### Default Account
>https://rinkeby.etherscan.io/address/0x5ccc6d873cc47149a9a303332b007ba65ff3301d

### Tx
>https://rinkeby.etherscan.io/tx/0xed020dd4aef4baf568809febff92b3bd9665a404c3ba5a31f47e24590e0e8bf8

## Smart Contract files
1. Folder `accesscontrol` contains the contracts with logic for the Roles:
1. Folder `base` contains the supply chain contract and the Transactions recorded:
    1. `SupplyChain.sol` supply chain with the method to interect with the Supply Chain
    1. `book1_scenario.json` file with the Transactions recorded in the Remix IDE Runtime, see how to use it [here](https://remix.readthedocs.io/en/latest/run_tab.html).
    Use this file to reproduce the scenario tested.
1. Folder `coew` contains the contract to ownership and transfer functions.
    
# Web Server
Webserver with Node.js with express to server as http server.
Node dependencies:
1. Express
1. web3
1. truffle
1. truffle-hdwallet-provider

### Tx Hashes
>Abstract - 0xdbe4a2af2399445c2e72bb6f1ba6233498b7e29b8ac88f0353362c89fa328340
>Submitted - 0x7e705d44837f33139b2e4b63f9350f908ecc2831c0fe57fee12ca6108276d50c
>Approved - 0x5adbcd8b05cb46a2f807c33034fd67e3c06c9c26bd538dee53a66a573601536a
>Written - 0x94634ed289e53ae77a8d4b1e4c8a4204184e4b1965aa4c8691124d367a702b8a
>Reviewed - 0x38868c0ca0c4536d96b257d5b9c002232d78eb602c75f807fb78bb09539b9ac6
>Art - 0xafb53e226a312279e7b06ed31e913e18cd41a386b121248c550c9b46a1136632
>Ordered - 0x18202f839051c344110455fa8e8f667a1b7deaedb2691488014b59a4ee415864
>Produced - 0xfbd70ddff0038019ae068fd122a75998d14134ac4f3578146364312686101f64
>Shipped - 0xbeeadd47cfc737106e6a33de5a1bc81542f8501f350172b40877446e06d04c93
>Received - 0x60282399ff3cdf79e14bfe7ffc94e9b9b6bc68e40c4657603c2f744319311be3


An image connecting the hashes and the state during the functions
![Hashes and State log](images/Hashes_State.PNG)