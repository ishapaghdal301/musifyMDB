import 'package:flutter/material.dart';
import 'package:musify/screens/MusicPage.dart';
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
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => HomePage(user: widget.user),
        "playlistPage" : (context) => PlayListPage(user: widget.user),
        "musicPage" : (context) => MusicPage(user: widget.user),
      }
    );
  }
}