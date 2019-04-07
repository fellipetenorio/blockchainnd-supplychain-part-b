var Test = require('./testConfig.js');

const writerName = "ferrer";
const title = "title";
const abstract = "abstract";
const draft = "draft";
const draft2 = "draft2";
const finalText = "finalText";
const price = 1;

const Abstract = "Abstract";
const Submitted = "Submitted";
const Approved = "Approved";
const Written = "Written";
const Reviewed = "Reviewed";
const Art = "Art";
const Ordered = "Ordered";
const Produced = "Produced";
const Shipped = "Shipped";
const Received = "Received";

async function writeAbstractTest(upc, sender, config) {
    await config.bookSP.writerAbstract(upc, writerName, title, abstract, draft, price, {from: sender});
}

async function submitTest(upc, publisher, sender, config) {
    await config.bookSP.submitAbstract(upc, publisher, {from: sender});
}

async function approveTest(upc, reviewer, sender, config) {
    await config.bookSP.approves(upc, reviewer, {from: sender});
}

async function writeBookTest(upc, text, sender, config) {
    await config.bookSP.writeBook(upc, text, {from: sender});
}

async function reviewTest(upc, text, sender, config) {
    await config.bookSP.review(upc, text, {from: sender});
}

async function artTest(upc, assetsUrl, sender, config) {
    await config.bookSP.artBook(upc, assetsUrl, {from: sender});
}

async function orderBook(upc, sender, value, config) {
    await config.bookSP.orderBook(upc, {from: sender, value: value});
}

async function produceBookTest(upc, sender, config) {
    await config.bookSP.produceBook(upc, {from: sender});
}

async function shipTest(upc, sender, config) {
    await config.bookSP.ship(upc, {from: sender});
}

async function receiveTest(upc, sender, config) {
    await config.bookSP.receive(upc, {from: sender});
}

contract('BookSupplyChain', async (accounts) => {

  var config;
  let owner = accounts[0];
  let writer = accounts[0];
  let publisher = accounts[0];
  let reviewer = accounts[0];
  let library = accounts[0];

  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('write book abstract', async () => {
    let upc = 1;
    await writeAbstractTest(upc, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    console.log('book', fetchedBook);
    assert.equal(fetchedBook.writerName, writerName, "Invalid book writer name");
    assert.equal(fetchedBook.title, title, "Invalid book title");
    assert.equal(fetchedBook.bAbstract, abstract, "Invalid book abstract");
    assert.equal(fetchedBook.text, draft, "Invalid book text");
    assert.equal(fetchedBook.state, Abstract, "Invalid book state");
    assert.equal(fetchedBook.price, price, "Invalid book price");
  });

  it('submit book abstract', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await submitTest(upc, publisher, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Submitted, "Invalid book state");
  });

  it('approve book', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await approveTest(upc, reviewer, publisher, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Approved, "Invalid book state");
  });

  it('write book final text', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await writeBookTest(upc, draft2, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Written, "Invalid book state");
  });

  it('review book final text', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await reviewTest(upc, finalText, reviewer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Reviewed, "Invalid book state");
  });

  it('create book art', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await artTest(upc, "https://example.com/1/assets", publisher, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Art, "Invalid book state");
  });

  it('order book', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await orderBook(upc, library, 10, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Ordered, "Invalid book state");
  });

  it('produce book', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await produceBookTest(upc, publisher, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Produced, "Invalid book state");
  });

  it('ship book', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await shipTest(upc, publisher, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Shipped, "Invalid book state");
  });

  it('receive book', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await receiveTest(upc, library, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Received, "Invalid book state");
  });
 
});
