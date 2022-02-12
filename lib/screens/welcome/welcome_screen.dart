import 'package:firebase_core/firebase_core.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '/constants.dart';
import '/screens/signinOrSignUp/signin_or_signup_screen.dart';
import 'package:flutter/material.dart';

// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Spacer(flex: 2),
//             // Image.asset("assets/images/welcome_image.png"),
//             Spacer(flex: 3),
//             Text(
//               "Welcome to our messaging app",
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline5!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//             Spacer(),
//             Text(
//               "A basic attempt at building message application\nPlease mail if any bugs found at amarkhakhkhar2241566@gmail.com",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .color!
//                     .withOpacity(0.64),
//               ),
//             ),
//             Spacer(flex: 3),
//             FittedBox(
//               child: TextButton(
//                   onPressed: () => {
//                     Firebase.initializeApp(),
//                   Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SigninOrSignupScreen(),
//                         ),
//                       ),},
//                   child: Row(
//                     children: [
//                       Text(
//                         "Skip",
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                               color: Theme.of(context)
//                                   .textTheme
//                                   .bodyText1!
//                                   .color!
//                                   .withOpacity(0.8),
//                             ),
//                       ),
//                       SizedBox(width: kDefaultPadding / 4),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 16,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyText1!
//                             .color!
//                             .withOpacity(0.8),
//                       )
//                     ],
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Welcome to Chat App",
        description: "Chat with your dear ones through this app",
        backgroundColor: Colors.green,
      ),
    );
    slides.add(
      new Slide(
        title: "Sign in or Sign up",
        description: "If you are a member already then sign in or else sign up for using this app",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "Under development",
        description: "This app is still under progress\n Currently working feature is only sending text message.\nPlease wait for further updates.\nContact below if found any bugs.\namarkhakhkhar2241566@gmail.com",
       backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    Firebase.initializeApp();
                  Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninOrSignupScreen(),
                        ),
                      );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
