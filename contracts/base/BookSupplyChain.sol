pragma solidity ^0.5.2;
import '../core/Ownable.sol';
import '../accesscontrol/WriterRole.sol';
import '../accesscontrol/LibraryRole.sol';
import '../accesscontrol/PublisherRole.sol';
import '../accesscontrol/ReviewerRole.sol';

// Define a contract 'Supplychain'
contract BookSupplyChain is Ownable, WriterRole, PublisherRole, ReviewerRole, LibraryRole {
    uint  currentSku;

    constructor() public payable {
        currentSku = 1;
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
        string title;
        string bAbstract;
        string text;
        string assetsUrl;
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

    function stateLabel(State state) internal pure returns (string memory) {
        if (state == State.Abstract) return "Abstract";
        if (state == State.Submitted) return "Submitted";
        if (state == State.Approved) return "Approved";
        if (state == State.Written) return "Written";
        if (state == State.Reviewed) return "Reviewed";
        if (state == State.Art) return "Art";
        if (state == State.Ordered) return "Ordered";
        if (state == State.Produced) return "Produced";
        if (state == State.Shipped) return "Shipped";
        if (state == State.Received) return "Received";
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
        uint _price = Books[_upc].price;
        uint amountToReturn = msg.value - _price;
        msg.sender.transfer(amountToReturn);
    }

    modifier currentOwner(uint _upc) {
        require(Books[_upc].owner == msg.sender, "You don't have permission to modify this book");
        _;
    }

    modifier bookStateIs(uint _upc, State state) {
        require(Books[_upc].state == state, "Invalid Book state for this action");
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
    function writerAbstract(uint _upc, string memory _writerName, string memory _draftTitle,
        string memory _bAbstract, string memory _draft, uint _price)
    public availableUpc(_upc) onlyWriter {
        // Initialize only the essential
        Books[_upc] = Book({
            sku : currentSku,
            upc : _upc,
            writerName : _writerName,
            title : _draftTitle,
            bAbstract : _bAbstract,
            text : _draft,
            assetsUrl : "",
            price : _price,
            state : State.Abstract,
            owner : msg.sender,
            writer : msg.sender,
            publisher : address(0),
            reviewer : address(0),
            buyer : address(0)
            });

        currentSku++;

        // Emit the appropriate event
        emit Abstract(_upc);
    }

    // After finish the abstract submit to some Publisher
    function submitAbstract(uint _upc, address publisher) public
    onlyWriter currentOwner(_upc)
    bookStateIs(_upc, State.Abstract) {
        Books[_upc].owner = publisher;
        Books[_upc].publisher = publisher;
        Books[_upc].state = State.Submitted;

        // Emit the appropriate event
        emit Submitted(_upc, publisher);
    }

    // in the approval, the publisher set the reviewer
    function approves(uint _upc, address reviewer) public
    onlyPublisher currentOwner(_upc)
    bookStateIs(_upc, State.Submitted) {
        // Update the appropriate fields
        Books[_upc].owner = Books[_upc].writer;
        Books[_upc].reviewer = reviewer;
        Books[_upc].state = State.Approved;

        // Emit the appropriate event
        emit Approved(_upc, reviewer);
    }

    function writeBook(uint _upc, string memory text) public
    onlyWriter currentOwner(_upc)
    bookStateIs(_upc, State.Approved) {

        Books[_upc].owner = Books[_upc].reviewer;
        Books[_upc].text = text;
        Books[_upc].state = State.Written;

        emit Written(_upc);
    }

    // in the review, the reviewer set the final text
    function review(uint _upc, string memory finalText) public
    onlyReviewer currentOwner(_upc)
    bookStateIs(_upc, State.Written) {
        Books[_upc].owner = Books[_upc].publisher;
        Books[_upc].text = finalText;
        Books[_upc].state = State.Reviewed;

        emit Reviewed(_upc);
    }

    function artBook(uint _upc, string memory _assetsUrl) public
    onlyPublisher currentOwner(_upc)
    bookStateIs(_upc, State.Reviewed) {
        Books[_upc].state = State.Art;
        Books[_upc].assetsUrl = _assetsUrl;
        Books[_upc].state = State.Art;

        // emit the event showing the book art URL
        emit Art(_upc, _assetsUrl);
    }

    function orderBook(uint _upc) public payable
    onlyLibrary currentOwner(_upc)
    paidEnough(_upc)
    checkValue(_upc)
    bookStateIs(_upc, State.Art)
    {
        Books[_upc].buyer = msg.sender;
        Books[_upc].state = State.Ordered;
        Books[_upc].writer.transfer(Books[_upc].price);

        emit Ordered(_upc, msg.sender);
    }


    function produceBook(uint _upc) public
    onlyPublisher currentOwner(_upc)
    bookStateIs(_upc, State.Ordered) {
        Books[_upc].state = State.Produced;

        emit Produced(_upc);
    }

    function ship(uint _upc) public
    onlyPublisher currentOwner(_upc)
    bookStateIs(_upc, State.Produced) {
        Books[_upc].state = State.Shipped;
        Books[_upc].owner = Books[_upc].buyer;

        emit Shipped(_upc);
    }

    function receive(uint _upc) public
    callerIs(Books[_upc].buyer)
    bookStateIs(_upc, State.Shipped) {
        Books[_upc].state = State.Received;

        // Boom! Book delivered
        emit Received(_upc);
    }

    function fetchBook(uint _upc) public view returns
    (
        uint sku,
        uint upc,
        string memory writerName,
        string memory title,
        string memory bAbstract,
        string memory text,
        uint price,
        string memory state
        
    )
    {
        // Assign values to the 8 parameters
        Book storage book = Books[_upc];

        sku = book.sku;
        upc = book.upc;
        writerName = book.writerName;
        title = book.title;
        bAbstract = book.bAbstract;
        text = book.text;
        price = book.price;
        state = stateLabel(book.state);
    }
}
