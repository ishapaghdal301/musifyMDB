const mongoose = require('mongoose');

const playlistSchema = new mongoose.Schema({
    playlistName : String,
    userId : {
        type: mongoose.Schema.Types.ObjectId,
        ref:"User"
    },
    songs: [{
        type: mongoose.Schema.Types.ObjectId,
        ref:"Songs"
      }]
});

mongoose.model('Playlists', playlistSchema);
module.exports = mongoose.model('Playlists');