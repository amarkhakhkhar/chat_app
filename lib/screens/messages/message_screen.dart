import 'dart:async';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/chats/chats_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';
import 'package:flutter/material.dart';


class MessagesScreen extends StatefulWidget {
  final String chatRoomId;
  bool loading = true;
  final String? name;
  TextEditingController messagecontroller = TextEditingController();
  MessagesScreen(this.chatRoomId, this.name);  
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  int SL = -1;
   final ScrollController scrollController = ScrollController();
  late Stream<QuerySnapshot> snapshot = databaseMethods.getConversationMessages(widget.chatRoomId);


  @override
  void initState(){
  getSnapshot();
    super.initState();
  }
    @override
    getSnapshot()async{
      int snapshotLength = await databaseMethods.getNumberOfMessages(widget.chatRoomId);
      setState((){
        SL = snapshotLength;
        widget.loading = false;
      });
    // return value;
    }
  
   _scrollToEnd(){
     scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // scrollController.animateTo(
    // scrollController.position.maxScrollExtent,
    // duration : Duration(microseconds: 1),
    // curve: Curves.linear
    // );
  }
    
  
   sendMessage(){
    if(widget.messagecontroller.text.isNotEmpty){
    Map<String, dynamic> messageMap = {
      "message" : widget.messagecontroller.text,
      "sendBy" : Constants.myName,
      "timestamp" : DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
    widget.messagecontroller.text = "";
  }
  Widget build(BuildContext context) {
  
    if(widget.loading == true || snapshot == null || SL ==null){
      return Center(
        child: Icon(
          Icons.timelapse
        ),
      );
    }
    else{ 
    return Scaffold(
      appBar: buildAppBar(widget.name),
      body: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                          stream: snapshot,
                          builder: (context, streamsnapshot) {
                            return ListView.builder(
                                controller: scrollController,
                                itemCount: streamsnapshot.data?.docs.length,
                                itemBuilder: (context, index) => Container(
                                    margin:const EdgeInsets.symmetric( horizontal: kDefaultPadding * 0.75,
                                        vertical: kDefaultPadding / 2,),
                                      padding:const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding * 0.75,
                                        vertical: kDefaultPadding / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: streamsnapshot.data?.docs[index].get('sendBy') == Constants.myName ? Colors.green : Colors.black,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: bindingmessages(streamsnapshot.data?.docs[index].get('message'),streamsnapshot.data?.docs.length, streamsnapshot.data?.docs[index].get('sendBy'))    
                                )
                                );
                          }),
            ))),
        Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: kPrimaryColor),
            SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: widget.messagecontroller,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                      onPressed: sendMessage,
                      icon :Icon(Icons.send),
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
      ],
    ),
    );
    } 
  }

  bindingmessages(String? message, int? count, String? sender){
    if(message != null && count!= 0){
      snapshot.listen((event) {
        if(event != null){
          _scrollToEnd();
        }
                            });
      return Text(
                                     message,
                                      style: TextStyle(
                                        color: 
                                        true
                                            ? Colors.white
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                      ),
                                    );
    }else{
      return Text(
                                     "",
                                      style: TextStyle(
                                        color: 
                                        sender== Constants.myName 
                                            ? Colors.white
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                      ),
                                    );

    }
  }

  AppBar buildAppBar(String? name) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(onPressed:(() =>  Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>   ChatsScreen()))), icon: Icon(Icons.arrow_back_ios)),
          CircleAvatar(
            // backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               name!,
                style: TextStyle(fontSize: 16),
              ),
              // Text(
              //   "Active 3m ago",
              //   style: TextStyle(fontSize: 12),
              // )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
