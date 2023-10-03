import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/config.dart';
import 'dart:convert';
import 'dart:math';

class PlayListPage extends StatefulWidget {
  final dynamic user;
  const PlayListPage({super.key, required this.user});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  List<dynamic> songs = [];

  void shuffleSongs() {
    print("hello");
    final random = Random();
    for (var i = songs.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = songs[i];
      songs[i] = songs[j];
      songs[j] = temp;
    }
  }

  @override
  void initState() {
    super.initState();
    shuffleSongs();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final playlist = arguments['playlist'];
    print(playlist);
    songs = List.from(playlist['songs']);

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xff303151).withOpacity(0.6),
            const Color(0xff303151).withOpacity(0.9),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.back,
                          color: Color(0xff899ccf),
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: shuffleSongs,
                        child: Icon(
                          Icons.more_vert,
                          color: Color(0xff899ccf),
                          size: 30,
                        ),
                      )
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "images/logo2.png",
                  width: 250,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(playlist['playlistName'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 170,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Play All",
                              style: TextStyle(
                                color: Color(0xff30314D),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Color(0xff30314D),
                              size: 40,
                            )
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 170,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xff30314D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Shuffle",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.shuffle,
                              color: Colors.white,
                              size: 25,
                            )
                          ]),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              ...songs.map((song) {
                return Container(
                  margin: EdgeInsets.only(top: 15, right: 12, left: 5),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF30314D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          var reqbody = {
                            "songId": song['_id'],
                            "userId": widget.user['_id'],
                          };

                          try {
                            var response = await http.post(
                              Uri.parse('$uri/user/isfavourite'),
                              headers: {
                                "Content-type": "application/json",
                              },
                              body: jsonEncode(reqbody),
                            );

                            if (response.statusCode == 201) {
                              var res = jsonDecode(response.body);
                              bool isFavourite = res['isFavourite'];

                              Navigator.pushNamed(
                                context,
                                "musicPage",
                                arguments: {
                                  "item": song,
                                  "isFavourite": isFavourite,
                                },
                              );
                            } else {
                              var res = jsonDecode(response.body);
                              print(res['error']);
                              // Handle the error case if needed.
                            }
                          } catch (error) {
                            print("Error: $error");
                            // Handle any unexpected errors here.
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            song['imageUrl'],
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var reqbody = {
                            "songId": song['_id'],
                            "userId": widget.user['_id'],
                          };

                          try {
                            var response = await http.post(
                              Uri.parse('$uri/user/isfavourite'),
                              headers: {
                                "Content-type": "application/json",
                              },
                              body: jsonEncode(reqbody),
                            );

                            if (response.statusCode == 201) {
                              var res = jsonDecode(response.body);
                              bool isFavourite = res['isFavourite'];

                              Navigator.pushNamed(
                                context,
                                "musicPage",
                                arguments: {
                                  "item": song,
                                  "isFavourite": isFavourite,
                                },
                              );
                            } else {
                              var res = jsonDecode(response.body);
                              print(res['error']);
                              // Handle the error case if needed.
                            }
                          } catch (error) {
                            print("Error: $error");
                            // Handle any unexpected errors here.
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${song['title']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${song['singer']}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 25,
                          color: Color(0xff31314f),
                        ),
                      )
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 30,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
