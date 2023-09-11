import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = Duration();
  bool isPlaying = false;
  Timer? timer;

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
        position = currentPosition ?? Duration(); // Use Duration() as a default value
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

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
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
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
                              Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 35,
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
