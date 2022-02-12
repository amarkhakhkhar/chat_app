import 'package:chat_app/components/primary_button.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/screens/messages/message_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController searchcontroller = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  bool showmessagebox = false;
  late String searchname;
  late String searchmail;

  initiateSearch() async {
    if (searchcontroller.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchcontroller.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        String results1 = snapshot.docs.map((doc)=> {doc["name"].toString()}).toString();
        String results2 = (snapshot.docs.map((doc)=> {doc["email"].toString()}).toString());
        if(results1== "()" || results2 == "()"){
            searchname = "Not Found";
            searchmail = "Not Found";
        }else{
        searchname = results1.split('{')[1].split('}')[0];
        searchmail = results2.split('{')[1].split('}')[0];
        showmessagebox= true;
        }
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      return results1;
      });
    }
  }

    createChatRoomAndStartConversation(String username){

      String chatroomId = getChatRoomId(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatroomId
      };
        databaseMethods.createChatRoom(chatroomId, chatRoomMap);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MessagesScreen(chatroomId, searchname)));
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Search Page"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric( horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,),
          child: Column(
            children: [
              TextField(
                controller: searchcontroller,
                decoration:
                    InputDecoration(hintText: "Enter username to be searched"),
              ),
              SizedBox(
                height: 20,
              ),
              PrimaryButton(text: "Search", press: () => initiateSearch()),
              userList()
            ],
          ),
        ),
      );
    }
     Widget userTile(String userName,String userEmail, bool messagebox){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          messagebox ? GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ) : Container()
        ],
      ),
    );
  }

    Widget userList(){
    return haveUserSearched ? 
    searchResultSnapshot.docs.length == 0 ? 
    ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
        itemBuilder: (context, index){
        return userTile(
          searchname,
          searchmail,
          showmessagebox,
        );
        }) :ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchname,
          searchmail,
          showmessagebox,
        );}) : Container();
  }  

}


 

getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
