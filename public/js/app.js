App = {
    web3Provider: null,
    web3: null,
    contracts: {},
    contractAddress: "0x6921b8078372867a9b5ed1c30f03158feb10cd70",
    contractNetwork: 0, //rinkeby
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 0,
    upc: 0,
    metamaskAccountID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    writerID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    writerName: null,
    title: null,
    bAbstract: null,
    price: 0,
    publisherID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    reviewerID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    buyerID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",

    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.sku = $("#sku").val();
        App.upc = $("#upc").val();

        App.writerName = $("#writerName").val();
        App.title = $("#title").val();
        App.bAbstract = $("#bAbstract").val();
        App.text = $("#text").val();
        App.assetsUrl = $("#assetsUrl").val();
        App.price = $("#price").val();
        App.writer = $("#writer").val();
        App.publisher = $("#publisher").val();
        App.reviewer = $("#reviewer").val();
        App.buyer = $("#buyer").val();

        console.log(
            App.sku,
            App.upc,
            App.writerName,
            App.title,
            App.bAbstract,
            App.text,
            App.assetsUrl,
            App.price,
            App.writer,
            App.publisher,
            App.reviewer,
            App.buyer
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }

        App.web3 = new Web3(App.web3Provider);

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        // Retrieving accounts
        web3.eth.getAccounts(function (err, res) {
            if (err) {
                console.log('Error:', err);
                return;
            }
            console.log('getMetaskID:', res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain = '/public/js/abi/BookSupplyChain.json';

        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function (data) {
            console.log('data', data);
            // var SupplyChainArtifact = data;
            App.contracts.SupplyChain = App.web3.eth.contract(data);
            App.contracts.SupplyChainContract = App.contracts.SupplyChain.at(App.contractAddress);

            App.fetchAllEvents();

        });

        return App.bindEvents();
    },

    bindEvents: function () {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function (event) {
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId', processId);

        switch (processId) {
            case 1:
                return await App.registerBook(event);
                break;
            case 2:
                return await App.processItem(event);
                break;
            case 3:
                return await App.packItem(event);
                break;
            case 4:
                return await App.sellItem(event);
                break;
            case 5:
                return await App.buyItem(event);
                break;
            case 6:
                return await App.shipItem(event);
                break;
            case 7:
                return await App.receiveItem(event);
                break;
            case 8:
                return await App.purchaseItem(event);
                break;
            case 9:
                return await App.fetchItemBufferOne(event);
                break;
            case 10:
                return await App.fetchItemBufferTwo(event);
                break;
        }
    },

    registerBook: function (event) {
        event.preventDefault();

        new Promise((reject, resolve) => {
            App.contracts.SupplyChainContract.fetchBook(1, function (error, book) {
                if (error) reject(error);

                resolve(book);
            })
        }).then(console.log)
        .catch(console.log);
    },


    purchaseItem: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function (instance) {
            return instance.purchaseItem(App.upc, {from: App.metamaskAccountID});
        }).then(function (result) {
            $("#ftc-item").text(result);
            console.log('purchaseItem', result);
        }).catch(function (err) {
            console.log(err.message);
        });
    },
    fetchAllEvents: function () {
        App.contracts.SupplyChainContract.allEvents(function (err, log) {
            if (!err)
                $("#ftc-events").append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
        });

    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});
