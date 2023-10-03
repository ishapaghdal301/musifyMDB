import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/config.dart';
import 'dart:convert';

class PlayList extends StatefulWidget {
  final dynamic user;

  PlayList({required this.user});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  List<dynamic> playlists = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var reqbody = {"userId": widget.user['_id']};
    var response = await http.post(
      Uri.parse('$uri/user/fetchplaylist'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(reqbody),
    );

    var res = jsonDecode(response.body);
    setState(() {
      playlists = res['playlists'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ...playlists.map((playlist) {
          return Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xff30314D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "playlistPage" ,arguments: {
                                "playlist" : playlist
                              },);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/logo2.png",
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist['playlistName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      playlist['songs'].length.toString() +" song",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.6),
                  size: 30,
                )
              ],
            ),
          );
        })
      ],
    ));
  }
}
