import 'package:flutter/material.dart';
import 'package:musify/screens/MusicPage.dart';
import 'package:musify/screens/signin_screen.dart';

import 'HomePage.dart';
import 'PlayListPage.dart';

class HomeScreen extends StatefulWidget {
  final dynamic user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       FirebaseAuth.instance.signOut().then((value) {
      //            print("Signout"); 
      //            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      //      });   
      //     },
      //     child: Text("Logout"),
      //   ),
      // ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => HomePage(user: widget.user),
        "playlistPage" : (context) => PlayListPage(),
        "musicPage" : (context) => MusicPage(),
      }
    );
  }
}
