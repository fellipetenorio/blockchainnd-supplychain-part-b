var Test = require('./testConfig.js');

const writerName = "ferrer";
const title = "title";
const abstract = "abstract";
const draft = "draft";
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
    // ASSERT
    await config.bookSP.writerAbstract(upc, writerName, title, abstract, draft, price, {from: sender});
}

async function submitTest(upc, publisher, sender, config) {
    // ASSERT
    await config.bookSP.submitAbstract(upc, publisher, {from: sender});
}

contract('BookSupplyChain', async (accounts) => {

  var config;
  let owner = accounts[0];
  let writer = accounts[0];
  let publisher = accounts[0];
  let reviewer = accounts[0];
  let wrilibraryter = accounts[0];

  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('write book abstract', async () => {
    let upc = 1;
    await writeAbstractTest(upc, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    console.log('book', fetchedBook);
    assert.equal(fetchedBook.writerName, writerName, "Invalid book writer name");
    assert.equal(fetchedBook.title, title, "Invalid book writer name");
    assert.equal(fetchedBook.bAbstract, abstract, "Invalid book writer name");
    assert.equal(fetchedBook.text, draft, "Invalid book writer name");
    assert.equal(fetchedBook.state, Abstract, "Invalid book writer name");
    assert.equal(fetchedBook.price, price, "Invalid book writer name");
  });

  it('submit book abstract', async () => {
    let upc = 1;
    // in the same test, the blockchain will be the same, so the previous submitted is already registred
    await submitTest(upc, publisher, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    assert.equal(fetchedBook.state, Submitted, "Invalid book writer name");
  });
 
});
