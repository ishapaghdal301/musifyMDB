const mongoose = require('mongoose');

const songSchema = new mongoose.Schema({
    title : String,
    singer : String,
    url : String,
    imageUrl : String
});

module.exports = mongoose.model('Song', songSchema);
