pragma solidity ^0.5.2;

import {Ownable} from "../core/Ownable.sol";

import {PublisherRole} from "../accesscontrol/PublisherRole.sol";
import {LibraryRole} from "../accesscontrol/LibraryRole.sol";
import {ReviewerRole} from "../accesscontrol/ReviewerRole.sol";
import {WriterRole} from "../accesscontrol/WriterRole.sol";

// Define a contract 'Supplychain'
contract SupplyChain {
    address owner;
    uint  sku;

    constructor() public payable {
        owner = msg.sender;
        sku = 1;
    }

    enum State {
        Abstract, // 0
        Submitted, // 1
        Approved, // 2
        Written, // 3
        Reviewed, // 4
        Art, // 5
        Ordered, // 6
        Produced, // 7
        Shipped, // 8
        Received  // 9
    }

    // Define a struct 'Book' with the following fields:
    struct Book {
        uint sku;
        uint upc;
        string writerName;
        string draftTitle;
        string bAbstract;
        string draft;
        string finalText;
        uint price;
        State state;
        address owner;
        address payable writer;
        address publisher;
        address reviewer;
        address payable buyer;
    }

    mapping(uint => Book) Books;

    event Abstract(uint upc);
    event Submitted(uint upc, address publisher);
    event Approved(uint upc, address reviewer);
    event Written(uint upc);
    event Reviewed(uint upc);
    event Art(uint upc, string assetsUrl);
    event Ordered(uint upc, address buyer);
    event Produced(uint upc);
    event Shipped(uint upc);
    event Received(uint upc);

    function stateLabel(State state) internal view returns (string) {
        if (state == Abstract) return "Abstract";
        if (state == Submitted) return "Submitted";
        if (state == Approved) return "Approved";
        if (state == Written) return "Written";
        if (state == Reviewed) return "Reviewed";
        if (state == Art) return "Art";
        if (state == Ordered) return "Ordered";
        if (state == Produced) return "Produced";
        if (state == Shipped) return "Shipped";
        if (state == Received) return "Received";
        return "";
    }

    modifier availableUpc(uint _upc) {
        require(Books[_upc].upc == 0 ||
        (Books[_upc].writer == msg.sender && Books[_upc].state == State.Abstract),
            "UPC already in use");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner());
        _;
    }

    modifier callerIs (address _address) {
        require(msg.sender == _address, "you don't have permission");
        _;
    }

    modifier paidEnough(uint _upc) {
        require(Books[_upc].price > 0, "invalid book price");
        require(msg.value >= Books[_upc].price, "need more money to buy the book");
        _;
    }

    modifier checkValue(uint _upc) {
        _;
        uint _price = Books[_upc].productPrice;
        uint amountToReturn = msg.value - _price;
        msg.sender.transfer(amountToReturn);
    }

    modifier currentOwner(uint _upc) {
        require(Books[_upc].ownerID == msg.sender, "You don't have permission to modify this book");
        _;
    }

    modifier bookStateIs(uint _upc, State state) {
        require(Books[_upc].state == state, "Invalid Book state (" + stateLabel(state) + ") for this action");
        _;
    }

    // DONE
    // Define a function 'kill' if required
    function kill() public {
        if (msg.sender == owner()) {
            selfdestruct(owner());
        }
    }

    // Write(or update) the abstract
    function registerBook(uint _upc, string memory _writerName, string memory _draftTitle,
        string memory _bAbstract, string memory _draft, uint _price)
    public availableUpc(_upc) {
        // Initialize only the essential
        Books[_upc] = Book({
            sku : sku,
            upc : _upc,
            writerName : _writerName,
            draftTitle : _draftTitle,
            bAbstract : _bAbstract,
            draft : _draft,
            finalText : "",
            price : _price,
            state : State.Abstract,
            owner : msg.sender,
            writer : msg.sender,
            publisher : address(0),
            reviewer : address(0)
            });

        sku = sku + 1;

        // Emit the appropriate event
        emit Abstract(_upc);
    }

    // After finish the abstract submit to some Publisher
    function submit(uint _upc, address publisher) public
    callerIs(Books[_upc].writer)
    bookStateIs(_upc, State.Abstract) {
        Books[_upc].owner = publisher;
        Books[_upc].publisher = publisher;

        // Emit the appropriate event
        emit Submitted(_upc, publisher);
    }

    // in the approval, the publisher set the reviewer
    function approve(uint _upc, address reviewer) public
    callerIs(Books[_upc].publisher)
    bookStateIs(_upc, State.Submitted) {
        // Update the appropriate fields
        Books[_upc].owner = Books[_upc].writer;
        Books[_upc].reviewer = reviewer;
        Books[_upc].BookState = State.Approved;

        // Emit the appropriate event
        emit Approved(_upc, reviewer);
    }

    function write(uint _upc, string memory text) public
    callerIs(Books[_upc].writer)
    bookStateIs(_upc, State.Approved) {

        Books[_upc].owner = Books[_upc].reviewer;
        Books[_upc].draft = text;

        emit Written(_upc);
    }

    // in the review, the reviewer set the final text
    function review(uint _upc, string memory finalText) public
    callerIs(Books[_upc].reviewer)
    bookStateIs(_upc, State.Written) {
        Books[_upc].owner = Books[_upc].publisher;
        Books[_upc].finalText = finalText;

        emit Reviewed(_upc);
    }

    function artBook(uint _upc, string memory _assetsUrl) public
    callerIs(Books[_upc].publisher)
    bookStateIs(_upc, State.Reviewed) {
        Books[_upc].BookState = State.Art;
        Books[_upc].assetsUrl = _assetsUrl;

        // emit the event showing the book art URL
        emit Art(_upc, _assetsURL);
    }

    function orderBook(uint _upc) public payable
    paidEnough(_upc)
    checkValue(_upc)
    bookStateIs(_upc, State.Art)
    {
        Books[_upc].buyer = msg.sender;
        Books[_upc].BookState = State.Ordered;
        Books[_upc].writer.transfer(Books[_upc].price);

        emit Ordered(_upc, msg.sender);
    }


    function produceBook(uint _upc) public
    callerIs(Books[_upc].publisher)
    bookStateIs(_upc, State.Ordered) {
        Books[_upc].BookState = State.Produce;

        emit Produced(_upc);
    }

    function ship(uint _upc) public
    callerIs(Books[_upc].publisher)
    bookStateIs(_upc, State.Produced) {
        Books[_upc].BookState = State.Shipped;
        Books[_upc].owner = Books[_upc].buyer;

        emit Shipped(_upc);
    }


    function receive(uint _upc) public
    callerIs(Books[_upc].buyer)
    bookStateIs(_upc, State.Shipped) {
        Books[_upc].BookState = State.Received;

        // Boom! Book delivered
        emit Received(_upc, msg.sender);
    }

    // Define a function 'fetchBookBufferOne' that fetches the data
    function fetchBook(uint _upc) public view returns
    (
        uint sku,
        uint upc,
        string writerName,
        string draftTitle,
        string bAbstract,
        string draft,
        string finalText,
        uint price,
        State state,
        address owner,
        address payable writer,
        address publisher,
        address reviewer,
        address payable buyer
    )
    {
        // Assign values to the 8 parameters
        Book storage book = Books[_upc];

        sku = book[sku];
        upc = book[upc];
        writerName = book[writerName];
        draftTitle = book[draftTitle];
        bAbstract = book[bAbstract];
        draft = book[draft];
        finalText = book[finalText];
        price = book[price];
        state = stateLabel(book[state]);
        owner = book[owner];
        writer = book[writer];
        publisher = book[publisher];
        reviewer = book[reviewer];
        buyer = book[buyer];
    }
}
