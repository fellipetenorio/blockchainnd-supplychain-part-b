var Test = require('./testConfig.js');



contract('BookSupplyChain', async (accounts) => {

  var config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('contract owner can register new user', async () => {
    let writer = accounts[0];
    let newUser = config.testAddresses[0]; 
    let upc = 1;
    let writerName = "ferrer";
    let title = "title";
    let abstract = "abstract";
    let draft = "draft";
    let price = 1;

    // ASSERT
    await config.bookSP.writerAbstract(upc, writerName, title, abstract, draft, price,
        {from: writer});
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
