const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: { type: String, unique: true },
  email : String  ,
  password: String, 
  favourite: [{
    type: mongoose.Schema.Types.ObjectId,
    ref:"Songs"
  }]
});

module.exports = mongoose.model('User', userSchema);