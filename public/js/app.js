App = {
    web3Provider: null,
    web3: null,
    contracts: {},
    contractAddress: "0x3d72b0afe217b64a3d1885b13bad87baa7afbc8b",
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 0,
    upc: 0,
    state: "",
    metamaskAccountID: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    writerName: null,
    title: null,
    bAbstract: null,
    price: 0,
    writer: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    publisher: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    reviewer: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",
    buyer: "0x5CCc6d873CC47149A9a303332b007Ba65Ff3301d",

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
    },

    initWeb3: async function () {

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
            App.metamaskAccountID = res[0];
            $('#current-account').html(App.metamaskAccountID);
            $('#writer, #publisher, #reviewer, #buyer').val(App.metamaskAccountID);
        })
    },

    initSupplyChain: function () {
        /// ABI
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
        $('button').on('click', App.handleButtonClick);
    },

    handleButtonClick: async function (event) {
        event.preventDefault();

        App.readForm();
        App.getMetaskAccountID();
        var action = parseInt($(event.target).data('id'));
        console.log('action', action);

        switch (action) {
            case 1:
                return await App.registerBook(event);
            case 2:
                return await App.submit(event);
            case 3:
                return await App.approve(event);
            case 4:
                return await App.write(event);
            case 5:
                return await App.review(event);
            case 6:
                return await App.artBook(event);
            case 7:
                return await App.orderBook(event);
            case 8:
                return await App.produceBook(event);
            case 9:
                return await App.ship(event);
            case 10:
                return await App.receive(event);
            case 11:
                return await App.fetchBook(event);
        }
    },

    registerBook: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.writerAbstract(App.upc, App.writerName, App.title, App.bAbstract,
                App.text, App.price,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book registred');
        }).catch(alert);
    },

    submit: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.submitAbstract(App.upc, App.publisher,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book submitted');
        }).catch(alert);
    },

    approve: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.approves(App.upc, App.reviewer,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book approved');
        }).catch(alert);
    },
    write: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.writeBook(App.upc, App.text,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book writen');
        }).catch(alert);
    },
    review: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.review(App.upc, App.text,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book review');
        }).catch(alert);
    },
    artBook: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.artBook(App.upc, App.assetsUrl,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book artBook');
        }).catch(alert);
    },
    orderBook: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.orderBook(App.upc,
                {from: App.metamaskAccountID, value: App.price, gas: 3000000},
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book ordered');
        }).catch(alert);
    },
    produceBook: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.produceBook(App.upc,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book produced');
        }).catch(alert);
    },
    ship: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.ship(App.upc,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book shiped');
        }).catch(alert);
    },
    receive: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");
            App.contracts.SupplyChainContract.receive(App.upc,
                function (error, book) {
                    if (error) throw new Error(error);

                    resolve(book);
                })
        }).then(b => {
            console.log(b);
            alert('book received');
        }).catch(alert);
    },

    fetchBook: function (event) {
        event.preventDefault();

        new Promise((resolve, reject) => {
            if (!App.upc)
                throw new Error("Invalid UPC");

            App.contracts.SupplyChainContract.fetchBook(App.upc, function (error, book) {
                if (error) throw new Error(error);

                resolve(book);
            });
        }).then(book => {
            console.log('book', book);
            $('#fetch-sku').val(book[0]);
            $('#fetch-upc').val(book[1]);
            $('#fetch-writer-name').val(book[2]);
            $('#fetch-title').val(book[3]);
            $('#fetch-abstract').val(book[4]);
            $('#fetch-text').val(book[5]);
            $('#fetch-price').val(book[6]);
            $('#fetch-state').val(book[7]);
        }).catch(alert);
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
