const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');
const route = require('./route');
const cors = require("cors");
// const secureRoutes = require('./routes/secure');

const app = express();
const PORT =  3000;

app.use(bodyParser.json());

app.use(cors());
app.use('/user', route);
// app.use('/secure', secureRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});