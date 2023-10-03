const express = require('express');
const router = express.Router();
const User = require('./model/User');
const Song = require('./model/Song');
const PlayList = require('./model/Playlist');

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
     
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Login failed' });
    }
});


router.post('/getfavouritesongs', async (req, res) => {
  try {
    const { userId } = req.body;
    console.log(userId);

    // Find the user by ID and populate the 'favourite' field with song objects
    const user = await User.findById(userId).populate('favourite');
    
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const favoriteSongs = user.favourite;
    console.log(favoriteSongs);

    res.status(200).json({ songs: favoriteSongs });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});



router.post("/addfavourite", async (req, res) =>{
  const {userId , songId} = req.body;
  console.log(req.body);
 try{
  const user = await User.findOne({_id : userId , favourite : songId});

  if(!user){
    await User.findByIdAndUpdate(userId, { $addToSet: { favourite: songId } });
    res.status(201).json({ message: 'Song added successfully' , isFavourite : true});
  }else{
    await User.findByIdAndUpdate(
      userId,
      { $pull: { favourite: songId } },
      { new: true } // To get the updated user document
    );
  res.status(201).json({ message: 'Song removed successfully' , isFavourite : false});
  }
 }catch(e){
    console.log(e);
    res.status(500).json({ error: 'Failed' });
 }

});



router.post("/isfavourite", async (req, res) =>{
  const {userId , songId} = req.body;
  console.log(req.body);
 try{
  const user = await User.findOne({_id : userId , favourite : songId});

  if(!user){
    res.status(201).json({isFavourite : false});
  }else{
  res.status(201).json({isFavourite : true});
  }
 }catch(e){
    console.log(e);
    res.status(500).json({ error: 'Failed' });
 }

});

router.get('/newsongs', async (req, res) => {
  try {
    const newSongs = await Song.find({}).sort({ releaseDate: -1 }).limit(10);
    res.status(200).json({songs : newSongs});
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

router.get('/trendingsongs', async (req, res) => {
  try {
    const trendingSongs = await Song.find({}).sort({ trendingScore: -1 }).limit(10); // Sort by trending score
    res.status(200).json({songs : trendingSongs});
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

router.post("/createplaylist", async (req, res) => {
  const { playlistName, userId,songId } = req.body;
  try {
    const playlist = await PlayList.create({ playlistName, userId });
    const song = await Song.findById(songId);
    playlist.songs.push(song);
    await playlist.save();
    res.status(201).json({playlist : playlist});
  } catch (error) {
    res.status(500).json({ error: 'Failed to create a new playlist' });
  }
});

router.post("/addtoplaylist",  async (req, res) => {
  const { playlistId, songId } = req.body;
  // console.log(req.body);
  try {
    const playlist = await PlayList.findById(playlistId);
    const song = await Song.findById(songId);

    if (!playlist || !song) {
      return res.status(404).json({ error: 'Playlist or song not found' });
    }

    playlist.songs.push(song);
    await playlist.save();
    res.status(201).json(playlist);
  } catch (error) {
    res.status(500).json({ error: 'Failed to add a song to the playlist' });
  }
});

router.post("/fetchplaylist", async (req, res) => {
  const { userId } = req.body;

  try {
    const playlists = await PlayList.find({ userId }).populate('songs');
    res.status(201).json({playlists : playlists});
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch user playlists' });
  }
});

router.post("/deleteplaylist",  async (req, res) => {
  const { playlistId } = req.params;

  try {
    await PlayList.findByIdAndRemove(playlistId);
    res.status(204).end();
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete the playlist' });
  }
});

router.post("/deletesong", async (req, res) => {
  const { playlistId, songId } = req.body;

  try {
    const playlist = await PlayList.findById(playlistId);

    if (!playlist) {
      return res.status(404).json({ error: 'Playlist not found' });
    }

    playlist.songs.pull(songId);
    await playlist.save();
    res.status(200).json(playlist);
  } catch (error) {
    res.status(500).json({ error: 'Failed to remove the song from the playlist' });
  }
});

module.exports = router;