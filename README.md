# blockchainnd-supplychain-part-b
Project for Part B of Term 2 Blockchain Udacity Nanodeegre Supply Chain project

For more information about Udacity BLockchain Developer Nanodegree check the [site](https://www.udacity.com/course/blockchain-developer-nanodegree--nd1309).
Some code from [here](https://github.com/udacity/nd1309-Project-6b-Example-Template) was imported to the contract.

**Describe a Supply Chain using Blockchain for the process of writing and selling a book. Since the abract and book approval to proced until the delivery to libraries.**

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
   1. to start Ganache with the same mnemonic (dev purpose only, DO NOT USE THIS IN PRODUCTION!):
      1. `ganache-cli -m "scale suit normal possible arm boost ridge blame orphan pilot rigid quit"`
1. Remix IDE to code solidity (.sol) files
   1. To compile and SYNC with local files the remixd npm module was used, see more details [here](https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html):
      1. `remixd -s <absolute-path-to-the-shared-folder> --remix-ide https://remix.ethereum.org`
   
For dev mode Ganache was used with one account per Role, when deployed in Rinkeby network only one account was used to reproduce the Roles.
### Smart Contract Rinkeby address:
>https://rinkeby.etherscan.io/address/0x6921b8078372867a9b5ed1c30f03158feb10cd70

### Default Account
>https://rinkeby.etherscan.io/address/0x5ccc6d873cc47149a9a303332b007ba65ff3301d

### Tx
>https://rinkeby.etherscan.io/tx/0xe08484fda805fcc133a48233a28478170a7d79710629220a51f5367d6b778061

## Smart Contract files
1. Folder `accesscontrol` contains the contracts with logic for the Roles:
1. Folder `base` contains the supply chain contract and the Transactions recorded:
    1. `SupplyChain.sol` supply chain with the method to interect with the Supply Chain
    1. `book1_scenario.json` file with the Transactions recorded in the Remix IDE Runtime, see how to use it [here](https://remix.readthedocs.io/en/latest/run_tab.html).
    Use this file to reproduce the scenario tested.
1. Folder `coew` contains the contract to ownership and transfer functions.
    
# Web Server
Webserver with Node.js with express to server as http server.
Open the terminal in the root folder and run to install depencies:
```
npm i
```

after that start the http server
```
node index.js
```
open your brower in [http://localhost], can change the port by a variable with the same name.
