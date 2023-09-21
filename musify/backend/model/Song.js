const mongoose = require('mongoose');

const songSchema = new mongoose.Schema({
    title : String,
    singer : String,
    url : String,
    imageUrl : String,
    releaseDate: Date, 
    trendingScore: Number, 
});

mongoose.model('Songs', songSchema);
module.exports = mongoose.model('Songs');