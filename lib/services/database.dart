import 'package:chat_app/modal/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserByUserMail(String mail){
    return FirebaseFirestore.instance.collection("users").where('email', isEqualTo: mail).get();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
     FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .get();
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print(e.toString());
  });  }

  Stream<QuerySnapshot> getConversationMessages(String chatRoomId){
    return FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).collection("chats").orderBy("timestamp", descending: false).snapshots();

  }

  getNumberOfMessages(String chatRoomId)async {
    int size = 0;
    await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).collection("chats").get().then((value) => size = value.size);
    return size;
      }

  Stream<QuerySnapshot> getChatRooms(String username){
    return FirebaseFirestore.instance.collection("chatRoom").where("users", arrayContains: username).snapshots();
  }
}
