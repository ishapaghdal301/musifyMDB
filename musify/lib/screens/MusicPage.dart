import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../db/config.dart';

class MusicPage extends StatefulWidget {
  final dynamic user;
  const MusicPage({super.key, required this.user});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = Duration();
  bool isPlaying = false;
  bool isFavourite = false;
  Timer? timer;

  Future<void> _showAddToPlaylistDialog(SongId) async {
    List<dynamic> playlists = [];
    var reqbody = {"userId": widget.user['_id']};

    var response = await http.post(
      Uri.parse('$uri/user/fetchplaylist'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(reqbody),
    );

    if (response.statusCode == 201) {
      var res = jsonDecode(response.body);
      playlists = res['playlists'];
    } else {
      var res = jsonDecode(response.body);
      print(res['error']);
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option to create a new playlist
              ListTile(
                title: Text('Create New Playlist'),
                onTap: () {
                  // Handle creating a new playlist
                  Navigator.pop(context);
                  _showCreatePlaylistDialog(SongId);
                },
              ),
              Divider(),
              // Option to add to existing playlists
              ...playlists.map((playlist) {
                return ListTile(
                  title: Text(playlist['playlistName']),
                  onTap: () {
                    // Handle adding the song to the selected playlist
                    Navigator.pop(context);
                    _addToExistingPlaylist(playlist,SongId);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreatePlaylistDialog(SongId) async {
    String newPlaylistName = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Playlist'),
          content: TextField(
            onChanged: (value) {
              newPlaylistName = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter playlist name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                if (newPlaylistName.isNotEmpty) {
                  // Handle creating the new playlist
                  Navigator.pop(context);
                  _createNewPlaylist(newPlaylistName, SongId);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addToExistingPlaylist(playlist,SongId) async{
    var reqbody = {"playlistId" : playlist['_id'],"songId":SongId};

    var response = await http.post(
      Uri.parse('$uri/user/addtoplaylist'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(reqbody),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      var res = jsonDecode(response.body);
      print(res['error']);
    }
  }

  void _createNewPlaylist(PlayListName, SongId) async {
    var reqbody = {"playlistName": PlayListName, "userId": widget.user['_id'],"songId":SongId};

    var response = await http.post(
      Uri.parse('$uri/user/createplaylist'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(reqbody),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      var res = jsonDecode(response.body);
      print(res['error']);
    }
  }

  void _showBottomSheet(SongId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.playlist_add),
                  title: Text('Add to Playlist'),
                  onTap: () {
                    _showAddToPlaylistDialog(SongId);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Add to Favorites'),
                  onTap: () {
                    // Add to favorites logic
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: () {
                    // Share logic
                    Navigator.pop(context);
                  },
                ),
                // Add more options as needed
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Listen for audio player state changes
    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d ?? Duration(); // Use Duration() as a default value
      });
    });

    // Start a timer to periodically update the audio position
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final currentPosition = await audioPlayer.getCurrentPosition();
      setState(() {
        position =
            currentPosition ?? Duration(); // Use Duration() as a default value
      });
    });

    // var reqbody = {
    //   "songId": item['_id'],
    //   "userId": widget.user['_id'],
    // };
    // var response = await http.post(
    //   Uri.parse('http://localhost:3000/user/isfavourite'),
    //   headers: {
    //     "Content-type": "application/json",
    //   },
    //   body: jsonEncode(reqbody),
    // );

    // if (response.statusCode == 201) {
    //   print("updated");
    //   var res = jsonDecode(response.body);
    //   if (res['isFavourite'] == true) {
    //     setState(() {
    //       isFavourite = true;
    //     });
    //   } else {
    //     setState(() {
    //       isFavourite = false;
    //     });
    //   }
    // } else {
    //   var res = jsonDecode(response.body);
    //   print(res['error']);
    // }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final item = arguments['item'];
    // isFavourite = arguments['isFavourite'] ?? false;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("${item['imageUrl']}"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                Color(0xFF31314F).withOpacity(1),
                Color(0xFF31314F).withOpacity(1),
              ],
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 45, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          }
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showBottomSheet(item['_id']);
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Wrap the Column with Expanded
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 23, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item['title']}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${item['singer']}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  var reqbody = {
                                    "songId": item['_id'],
                                    "userId": widget.user['_id'],
                                  };

                                  var response = await http.post(
                                    Uri.parse('$uri/user/addfavourite'),
                                    headers: {
                                      "Content-type": "application/json",
                                    },
                                    body: jsonEncode(reqbody),
                                  );

                                  if (response.statusCode == 201) {
                                    print("updated");
                                    var res = jsonDecode(response.body);
                                    if (res['isFavourite'] == true) {
                                      setState(() {
                                        isFavourite = true;
                                      });
                                    } else {
                                      setState(() {
                                        isFavourite = false;
                                      });
                                    }
                                  } else {
                                    var res = jsonDecode(response.body);
                                    print(res['error']);
                                  }
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: isFavourite
                                      ? Colors.redAccent
                                      : Colors.white,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Slider(
                              min: 0,
                              max: duration.inMilliseconds.toDouble(),
                              value: position.inMilliseconds.toDouble(),
                              onChanged: (double value) {
                                audioPlayer.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.white54,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _printDuration(position),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _printDuration(duration),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.list,
                              color: Colors.white,
                              size: 32,
                            ),
                            Icon(
                              CupertinoIcons.backward_end_fill,
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Color(0xff31314f),
                                  size: 45,
                                ),
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                  } else {
                                    await audioPlayer.play(UrlSource(item[
                                        'url'])); // Replace 'item['url']' with the actual URL of the MP3
                                  }
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                              ),
                            ),
                            Icon(
                              CupertinoIcons.forward_end_fill,
                              color: Colors.white,
                              size: 30,
                            ),
                            Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 32,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
