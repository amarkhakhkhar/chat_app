import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/messages/message_screen.dart';
import 'package:chat_app/screens/searchPage/searchPage.dart';
import 'package:chat_app/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool loading = true;
  late Stream<QuerySnapshot> snapshot= databaseMethods.getChatRooms(Constants.myName);

  @override
  void initState() {
    // snapshot =   databaseMethods.getChatRooms(Constants.myName);
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    setState(() {
      snapshot == null? loading = true :loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: loading == true ? Container(
        child: Center(child: Icon(
          Icons.timelapse,
          size: 60,
        )),
      ):
      Column(
        children: [
          Container(
            padding:
                const EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, 0),
            color: kPrimaryColor,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: snapshot,
                builder: (context, streamsnapshot) {
                  return ListView.builder(
                      itemCount: streamsnapshot.data?.docs.length,
                      itemBuilder: (context, index) => 
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => MessagesScreen(streamsnapshot.data?.docs[index].get('chatRoomId'), streamsnapshot.data?.docs[index].get('chatRoomId').toString().replaceAll("_", "").replaceAll(Constants.myName, ""))),),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                  vertical: kDefaultPadding * 0.75),
                              child: Row(
                                children: [ 
                                  loadingchatscreen(streamsnapshot.data?.docs[index].get('chatRoomId').toString().replaceAll("_", "").replaceAll(Constants.myName, ""),streamsnapshot.data?.docs.length)],
                              ),
                            ),
                          ));
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => searchPage()));
        },
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  loadingchatscreen(String? message, int? index) {
    if(message != null && index!= 0){
    return Stack(children: [
                                    const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: kPrimaryColor,
                                      // backgroundImage: Image.network(Lu),
                                    ),
                                  
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message,
                                              style:const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 8),
                                            const Opacity(
                                              opacity: 0.64,
                                              // child: Text(
                                              //   "chat.lastMessage",
                                              //   maxLines: 1,
                                              //   overflow: TextOverflow.ellipsis,
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    // Opacity(
                                    //   opacity: 0.64,
                                    //   child: Text(chat.time),
    ]);
    }else{
      return Text("Welcome, Keep conversating");
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Chats"),
      actions: [
        IconButton(
          icon: Icon(Icons.power_settings_new),
          onPressed: () {
            authMethods.SignOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SigninOrSignupScreen()));
          },
        ),
      ],
    );
  }
}
