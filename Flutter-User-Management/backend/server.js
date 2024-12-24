const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const UserRoute = require('./routes/user.route.js');

const app = express();
const port = 6000;


app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


const dbURI = 'mongodb+srv://heshanjeewantha:CHQq9FuVcVlVyuyN@cluster0.jfxog.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
mongoose.connect(dbURI)
    .then(() => console.log('MongoDB connected successfully'))
    .catch((err) => console.log('MongoDB connection error:', err));



app.use('/user', UserRoute);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
