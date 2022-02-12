import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/screens/chats/chats_screen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

import '../../components/primary_button.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({ Key? key }) : super(key: key);

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String chatRoomId = "";

  signMeUp(BuildContext context){

    if(formKey.currentState!.validate()){
      authMethods.signUpWithEmailAndPassword(emailcontroller.text, passwordcontroller.text).then((result){
         if(result != null){
              if(result.toString() == "Instance of 'LUser'"){
              Map<String,String> userDataMap = {
                "name" : usernamecontroller.text,
                "email" : emailcontroller.text
              };

              HelperFunctions.saveUserEmailSharedPreference(emailcontroller.text);
              HelperFunctions.saveUserNameSharedPreference(usernamecontroller.text);
              databaseMethods.addUserInfo(userDataMap);

               Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatsScreen()));
         };}else{
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content : Text("Error try again")));
         }
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    Text("Welcome to Chat App,Please sign up to continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (val){
                        return val!.isEmpty ? "Please provide appropriate username": null;
                      },
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                        hintText: "Username"  
                      ),
                    ),
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
                    text: "Sign Up",
                    press: () => signMeUp(context)
                       ),
                  ],
                    ),
                  ),
                ),
          ),
            ),
      ),
    );
  }
}