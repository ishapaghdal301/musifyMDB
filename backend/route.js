const express = require('express');
const router = express.Router();
const User = require('./model/User');
const Song = require('./model/Song');

router.post("/register", async (req, res) => {
    try {
        console.log(req.body);
        
        const { username, password , email } = req.body;
        // const hashedPassword = await bcrypt.hash(password, 10); // Hash the password
    
        const user = new User({
          username,
          email,
          password,
        });
    
        await user.save();
        res.status(201).json({ message: 'User registered successfully' });
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Registration failed' });
      }
});

router.post("/login", async (req, res) => {
  try {
      
      const { username, password  } = req.body;
      // const hashedPassword = await bcrypt.hash(password, 10); // Hash the password
  
      const user = await User.findOne({username});
      if(!user){
        return res.status(400).json({error : "Inavalid username or password"});
      }
      
      if(user.password == password){
        res.status(201).json({message : "You are succsessfully loged in" , user : user});
        console.log(user);
      }
      else{
        return res.status(400).json({error : "Inavalid username or password"});
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Login failed' });
    }
});

router.post("/addsong", async (req, res) => {
  try{ 
  console.log(req.body);
        
  const { title , singer , url , imageUrl } = req.body;
  // const hashedPassword = await bcrypt.hash(password, 10); // Hash the password

  const song = new Song({
    title,
    singer,
    url,
    imageUrl
  });

  await song.save();
  res.status(201).json({ message: 'Song added successfully' });
} catch (error) {
  console.error(error);
  res.status(500).json({ error: ' failed' });
}
});

router.get("/getsongs", async (req, res) => {
  try {
  
      const songs = await Song.find();
      if(!songs){
        return res.status(400).json({error : "No songs Found"});
      }
      
      res.status(201).json({songs : songs});
        console.log(songs);
     
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Login failed' });
    }
});


module.exports = router;
