import 'package:flutter/material.dart';
import 'package:musify/screens/signin_screen.dart';
import 'package:musify/widgets/FavouriteList.dart';
import 'package:musify/widgets/MusicList.dart';
import 'package:musify/widgets/PlayList.dart';
import 'package:musify/widgets/NewSongList.dart';
import 'package:musify/widgets/TreandingList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final dynamic user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var username = user['username'];
    return DefaultTabController(
      length: 5,
      child: Container(
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
                child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.sort_rounded,
                            color: Color(0xff899ccf),
                            size: 30,
                          ),
                        ),
                        InkWell(
                            onTap: () {},
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('token');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff899ccf),
                                textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 10,
                                    fontStyle: FontStyle.normal),
                              ),
                              child: Text("Logout"),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Welcome ${user['username']}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "What you want to hear?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 20, bottom: 20),
                    child: Container(
                      height: 50,
                      width: 380,
                      decoration: BoxDecoration(
                        color: const Color(0xff31314f),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          width: 200,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Search the music",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        )
                      ]),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 18),
                    indicator: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 3,
                      color: Color(0xFF899CCF),
                    ))),
                    tabs: [
                      Tab(
                        text: "Music",
                      ),
                      Tab(
                        text: "Playlists",
                      ),
                      Tab(
                        text: "Favourites",
                      ),
                      Tab(
                        text: "New",
                      ),
                      Tab(
                        text: "Trending",
                      ),
                    ],
                  ),
                  Flexible(
                      flex: 1,
                      child: TabBarView(
                        children: [
                          MusicList(user: user),
                          PlayList(user: user),
                          FavouriteList(user: user),
                          NewSongList(user: user),
                          TreandingList(user: user),
                        ],
                      ))
                ],
              ),
            ))),
      ),
    );
  }
}
