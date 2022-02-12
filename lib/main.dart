import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/chats/chats_screen.dart';
import 'package:chat_app/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import '/screens/welcome/welcome_screen.dart';
import '/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}
  
class _MyAppState extends State<MyApp> {

  bool? isUserLoggedIn = false;
  String chatRoomId = "";

  @override
  void initState() {
    Firebase.initializeApp(); 
    getLoggedinState();
    super.initState();
  }

  getLoggedinState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: WelcomeScreen());     
  }
}
