const express = require("express");
const port = 80;
let app = express();

app.use(express.static("./"));

app.listen(port, ()=>{console.log('listening http://localhost:8080')});