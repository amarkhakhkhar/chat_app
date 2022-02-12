import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/modal/user.dart';
import 'package:chat_app/screens/chats/chats_screen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/primary_button.dart';

class SignInPage extends StatelessWidget {
  SignInPage({ Key? key }) : super(key: key);

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isLoading = true;
  String chatRoomId = "";
  late QuerySnapshot snapshotuserInfo;

  signMeIn(BuildContext context){

    if(formKey.currentState!.validate()){
      databaseMethods.getUserByUserMail(emailcontroller.text).then((val){
      snapshotuserInfo = val;
      String results1 = snapshotuserInfo.docs.map((doc)=> {doc["name"].toString()}).toString();
      String searchname = results1.split('{')[1].split('}')[0];
      HelperFunctions.saveUserNameSharedPreference(searchname);
      } 
      );
      
      authMethods.signInWithEmailAndPassword(emailcontroller.text, passwordcontroller.text)
      .then((val) => {
      if (val != null){
        print(val),
      if(val.toString() == "Instance of 'LUser'"){
      HelperFunctions.saveUserLoggedInSharedPreference(true),
      Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>   ChatsScreen()))
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content : Text("Error try again")))
      }
      
      }
      
      });
      };
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric( horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,),
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Icon(
                    Icons.message,
                    size: 100,
                  ),
                  Text("Welcome back, Sign in to continue",
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),),
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Enter a valid email";
                      },
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email"  
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    validator: (val){
                      return val!.length < 5 ? "Please provide password with length greater than 5": null;
                    },
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      hintText: "Password"  
                    ),
                  ),
                  SizedBox(height: 20,),
                  PrimaryButton(
                  text: "Sign In",
                  press: () => signMeIn(context)
                     ),
                ],
                  ),
                ),
              ),
        ),
          ),
    );
  }
}