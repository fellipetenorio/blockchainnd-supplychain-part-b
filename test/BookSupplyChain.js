var Test = require('./testConfig.js');

const writerName = "ferrer";
const title = "title";
const abstract = "abstract";
const draft = "draft";
const price = 1;

async function writeAbstractTest(upc, writer, config) {
    // ASSERT
    await config.bookSP.writerAbstract(upc, writerName, title, abstract, draft, price, {from: writer});
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

  it('contract owner can register new user', async () => {
    let upc = 1;
    await writeAbstractTest(upc, writer, config);

    let fetchedBook = await config.bookSP.fetchBook.call(upc);
    console.log('book', fetchedBook);
    assert.equal(fetchedBook.writerName, writerName, "Invalid book writer name");
    assert.equal(fetchedBook.title, title, "Invalid book writer name");
    assert.equal(fetchedBook.bAbstract, abstract, "Invalid book writer name");
    assert.equal(fetchedBook.text, draft, "Invalid book writer name");
    assert.equal(fetchedBook.state, "Abstract", "Invalid book writer name");
    assert.equal(fetchedBook.price, price, "Invalid book writer name");

  });

 
});
