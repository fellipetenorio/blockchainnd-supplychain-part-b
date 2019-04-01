pragma solidity ^0.5.2;

import {PublisherRole} from "../accesscontrol/PublisherRole.sol";

// Define a contract 'Supplychain'
contract SupplyChain {
    // Define 'owner'
    address owner;

    // Define a variable called 'upc' for Universal Product Code (UPC)
    uint  upc;

    // Define a variable called 'sku' for Stock Keeping Unit (SKU)
    uint  sku;

    // Define a public mapping 'Books' that maps the UPC to an Book.
    mapping(uint => Book) Books;

    // Define a public mapping 'BooksHistory' that maps the UPC to an array of TxHash,
    // that track its journey through the supply chain -- to be sent from DApp.
    mapping(uint => string[]) BooksHistory;

    // TODO map the book orders
    // mapping to Libraries Orders
    // library => [upc => Order]
    mapping(address => mapping(uint => Order)) Orders;

    // DONE
    // Define enum 'State' with the following values:
    enum State
    {
        Abstract, // 0
        Submitted, // 1
        Approved, // 2
        Written, // 3
        Reviewed, // 4
        Art // 5
    }

    enum OrderState {
        Ordered, // 0
        Produced, // 1
        Shipped, // 2
        Received  // 3
    }

    // Define a struct 'Book' with the following fields:
    struct Book {
        uint sku;  // Stock Keeping Unit (SKU)
        uint upc; // Universal Product Code (UPC), generated by the Writer, goes on the package, can be verified by the Library
        address ownerID;  // Metamask-Ethereum address of the current owner as the product moves through 9 stages
        address writerID; // Metamask-Ethereum address of the Writer
        string writerName; // Writer Name
        string draftTitle; // Initial title
        string bAbstract; // Book Abstract
        string draft; // Book Draft
        string finalText; // Book final version
        string assetsURL;
        uint productID;  // Product ID potentially a combination of upc + sku
        string productNotes; // Product Notes
        uint productPrice; // Product Price
        State BookState;  // Product State as represented in the enum above
        address publisherID;  // Metamask-Ethereum address of the Publisher
        string urlToOrder; // Publisher URL to catalog or to order the book
        address reviewerID;  // Metamask-Ethereum address of the Reviewer
        address libraryID; // Metamask-Ethereum address of the Library
    }

    // Once a book can be ordered by many libraries a Order Status is necessary
    struct Order {
        uint quantity;
        State OrderState;
    }

    // DONE
    // Define 9 events with the same 9 state values and accept 'upc' as input argument
    event Abstract(uint upc);
    // book and publisher
    event Submitted(uint upc, address publisherID);
    event Approved(uint upc);
    event Written(uint upc);
    event Reviewed(uint upc);
    event Art(uint upc, string assetsUrl);
    event Ordered(uint upc, uint _quantity, address libraryID);
    event Produced(uint upc, address libraryID);
    event Shipped(uint upc, address libraryID);
    event Received(uint upc, address libraryID);

    // DONE
    // Define a modifer that checks to see if msg.sender == owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // DONE
    // Define a modifer that verifies the Caller
    modifier verifyCaller (address _address) {
        require(msg.sender == _address);
        _;
    }

    // DONE
    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint _upc, uint _quantity) {
        uint _price_unity = Books[_upc].productPrice;
        require(msg.value >= _price_unity * _quantity);
        _;
    }

    // DONE
    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint _upc) {
        _;
        uint _price = Books[_upc].productPrice;
        uint _quantity = Orders[msg.sender];
        uint amountToReturn = msg.value * _quantity - _price;
        Books[_upc].consumerID.transfer(amountToReturn);
    }

    modifier currentOwner(uint _upc) {
        require(Books[_upc].ownerID == msg.sender, "You don't have permission to modify this book");
        _;
    }

    modifier availableUpc(uint _upc) {
        require(!Books.has(_upc), "UPC already used");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc is Abstract
    modifier bAbstract (uint _upc) {
        require(Books[_upc].BookState == State.Abstract, "The book needs substract");
        _;
    }

    // DONE
    modifier submitted(uint _upc) {
        require(Books[_upc].BookState == State.Submitted, "The book need to be Submitted");
        _;
    }

    // DONE
    modifier approved(uint _upc) {
        require(Books[_upc].BookState == State.Approved, "The book needs approval");
        _;
    }

    // DONE
    modifier written(uint _upc) {
        require(Books[_upc].BookState == State.Written, "Write the book!");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc is Reviewed
    modifier reviewed(uint _upc) {
        require(Books[_upc].BookState == State.Reviewed, "The book need to be reviewed");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc is Reviewed
    modifier art(uint _upc) {
        require(Books[_upc].BookState == State.Art, "The book need assets");
        _;
    }

    modifier ordable (uint _upc) {
        require(!Orders.has(_upc) ||
            (), "This Library already ordered this book");
        require(Books[_upc].BookState == State.Art, "Book not ready for sale");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc was ordered by the library
    modifier ordered(uint _upc, address libraryID) {
        require(Orders[libraryID] > 0, "This Library didn't ordered this Book");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc is produced
    modifier produced(uint _upc) {
        require(Books[_upc].BookState == State.Produce, "The book have to be produced");
        _;
    }

    // DONE
    // Define a modifier that checks if an Book.state of a upc is Shipped
    modifier shipped(uint _upc) {
        require(Books[_upc].BookState == State.Shipped, "Ship the book first");
        _;
    }

    // DONE
    modifier received(uint _upc) {
        require(Books[_upc].BookState == State.Received, "Book not received yet");
        _;
    }


    // DONE
    // In the constructor set 'owner' to the address that instantiated the contract
    // and set 'sku' to 1
    // and set 'upc' to 1
    constructor() public payable {
        owner = msg.sender;
        sku = 1;
        upc = 1;
    }

    // DONE
    // Define a function 'kill' if required
    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    // DONE (TODO add log)
    /// Start a Book project! First of all define the temporary title and the abstract
    function abstractBook(uint _upc, address _originWriterID, string _originFarmName, string _originFarmInformation,
        string _originFarmLatitude, string _originFarmLongitude, string _productNotes) public
    availableUpc(_upc)
    onlyWriter
    {
        // Increment sku
        sku = sku + 1;
        // Initialize only the essential
        Books[_upc] = Book({
            sku : sku,
            upc : _upc,
            ownerID : msg.sender,
            writerID : msg.sender,
            draftTitle : _draftTitle,
            bAbstract : _abstract,
            BookState : State.Abstract
            });
        // Emit the appropriate event
        emit Abstract(_upc);
    }

    // TODO maybe new function to update abstract before submit?

    // DONE (TODO add log)
    // After some negotiation the writer set the Publisher (later feature: change the book's Publisher)
    function submit(uint _upc, address publisherID) public
        // Submit only abstract books
    bAbstract(_upc)
    onlyOwner()
    libraryOwner(publisherID)
    currentOwner(_upc)
    {
        // Update the appropriate fields
        // 1 library is the new owner
        Books[_upc].ownerID = publisherID;
        Books[_upc].BookState = State.Submitted;

        // Emit the appropriate event
        emit Submitted(_upc, publisherID);
    }

    // TODO improve to allow a Publisher to reprove abstract and the Writer submit to other

    // DONE (TODO add log)
    // Define a function 'packBook' that allows a Writer to mark an Book 'Packed'
    function approve(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage
    submitted(_upc)
        // Call modifier to verify caller of this function
    onlyPublisher
    currentOwner(_upc)
    {
        // Update the appropriate fields
        Books[_upc].ownerID = Books[_upc].writerID;
        Books[_upc].BookState = State.Approved;

        // Emit the appropriate event
        emit Approved(_upc);
    }

    // DONE (TODO add log)
    // Writer submit the book text to review
    function write(uint _upc, address publisherID, string text) public
    approved(_upc)
    onlyWriter
    currentOwner(_upc)
    {
        Books[_upc].ownerID = publisherID;
        Books[_upc].BookState = State.Submitted;
        Books[_upc].draft = text;

        emit Written(_upc);
    }

    // DONE (TODO add log)
    // in this smart contract the reviewer set the final text (can improve later)
    function review(uint _upc, string finalText) public
    written(_upc)
    onlyReviewer
    currentOwner(_upc)
    {
        Books[_upc].ownerID = Books[_upc].publisherID;
        Books[_upc].BookState = State.Reviewed;
        Books[_upc].finalText = finalText;

        emit Reviewed(_upc);
    }

    // DONE (TODO add log)
    // create the art (for now the art will be an URL do book's assets)
    function artBook(uint _upc, string assetsURL) public
        // Call modifier to check if upc has passed previous supply chain stage
    reviewed(_upc)
        // Call modifier to verify caller of this function
    onlyPublisher
    currentOwner(_upc)
    {
        // Update the appropriate fields
        Books[_upc].BookState = State.Art;
        Books[_upc].assetsURL = assetsURL;

        // Emit the appropriate event
        emit Art(_upc, assetsURL);
    }



    // DONE (TODO add log)
    // from this moment the library can order (buy) the book
    // In this smart contract, the library will pay the total amount of books
    // For the sake of simplicity only one order by book (any quantity) by Library is allowed
    // In this scenario the value of the order is 50/50 to writer and publisher
    function orderBook(uint _upc, uint _quantity) public payable
        // Call modifier to check if upc has passed previous supply chain stage
    onlyLibrary
    availableUpc(_upc)
    ordable(_upc)
        // Call modifer to check if buyer has paid enough
    paidEnough(_upc, _quantity)
        // Call modifer to send any excess ether back to buyer
    checkValue(_upc)
    {

        // Update the appropriate fields - ownerID, distributorID, BookState
        Orders[msg.sender] = Order({
            quantity : _quantity,
            OrderState : OrderState.Ordered
            });
        uint _totalPayment = Books[_upc].productPrice * _quantity;
        uint _publisherPayment = _totalPayment / 2;

        // Publisher payment
        Books[_upc].writerID.transfer(_publisherPayment);
        // Transfer money to Writer
        Books[_upc].writerID.transfer(_totalPayment - _publisherPayment);

        // emit the appropriate event
        emit Ordered(_upc, _quantity, msg.sender);
    }


    // DONE (TODO add log)
    // produce the book by demand
    function produceBook(uint _upc, address _libraryID) public
        // Call modifier to check if upc has passed previous supply chain stage
    art(_upc)
    ordered(_libraryID)
        // Call modifier to verify caller of this function
    libraryOwner(_libraryID)
    onlyPublisher
    currentOwner(_upc)
    {
        // Update the appropriate fields
        Books[_upc].BookState = State.Produce;

        // Emit the appropriate event (some order was produced)
        emit Produced(_upc, _libraryID);
    }

    // DONE (TODO add log)
    // Define a function 'shipBook' that allows the distributor to mark an Book 'Shipped'
    // Use the above modifier to check if the Book is sold (have map to this book)
    function shipBook(uint _upc, address _libraryID) public
        // Call modifier to check if upc has passed previous supply chain stage
    produced(_upc)
        // Call modifier to verify caller of this function
    currentOwner(_upc)
    ordered(_upc, _libraryID)
    {
        // Update the appropriate fields
        Books[_upc].BookState = State.Shipped;

        // In this Smart Contract the owner is still the Publisher because
        // there is many orders, so change the book ownership to library would
        // invalidate all orders

        // Emit the appropriate event
        emit Shipped(_upc, _libraryID);
    }


    // DONE (TODO add log)
    // Define a function 'receiveBook' that allows the retailer to mark an Book 'Received'
    // Use the above modifiers to check if the Book is shipped
    function receiveBook(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage
    shipped(_upc)
        // Access Control List enforced by calling Smart Contract / DApp
    onlyLibrary
    {
        // Update the appropriate fields - ownerID, retailerID, BookState

        // after received the books, the Order is deleted, so

        // Emit the appropriate event

    }

    // Define a function 'fetchBookBufferOne' that fetches the data
    function fetchBookBufferOne(uint _upc) public view returns
    (
        uint BookSKU,
        uint BookUPC,
        address ownerID,
        address originWriterID,
        string originFarmName,
        string originFarmInformation,
        string originFarmLatitude,
        string originFarmLongitude
    )
    {
        // Assign values to the 8 parameters


        return
        (
        BookSKU,
        BookUPC,
        ownerID,
        originWriterID,
        originFarmName,
        originFarmInformation,
        originFarmLatitude,
        originFarmLongitude
        );
    }

    // Define a function 'fetchBookBufferTwo' that fetches the data
    function fetchBookBufferTwo(uint _upc) public view returns
    (
        uint BookSKU,
        uint BookUPC,
        uint productID,
        string productNotes,
        uint productPrice,
        uint BookState,
        address distributorID,
        address retailerID,
        address consumerID
    )
    {
        // Assign values to the 9 parameters


        return
        (
        BookSKU,
        BookUPC,
        productID,
        productNotes,
        productPrice,
        BookState,
        distributorID,
        retailerID,
        consumerID
        );
    }
}
