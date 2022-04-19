import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Screens/Dashboard/dashboard_main.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Methods/auth.dart';
import '../../Methods/auth.dart';
import '../Verify/self_verify.dart';
import '../Verify/verify_sm.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String route = '/Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: LoginMobile(),
      tablet: LoginDesktop()
    );
  }
}

class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  _LoginMobileState createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final AuthMethod authmethod= AuthMethod();

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: Container(
        padding: EdgeInsets.all(screensize.width/8),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.1),
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 1.5,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png',width: screensize.width/4,),
                    Text('Reddy Wines',style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: screensize.width/1.7,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: usernamecontroller,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.all(5)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: screensize.width/1.7,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: passwordcontroller,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.all(5)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: screensize.width/1.75,
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            Future<bool> status = authmethod.signInWithEmailAndPassword(usernamecontroller.text,passwordcontroller.text);
                            status.then((value) {
                              if(value==true){
                                if(prefs.getString('role')=='Sales Manager'){
                                  print('verify now');
                                }
                                else if(prefs.getString('role')=='Manager'){
                                  print('self verify now');
                                }
                                if(prefs.getString('role')=='admin'){
                                  print('i am admin');
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful'),));
                                  Navigator.of(context).pushNamed(Dashboard_Main.route);
                                }
                              }
                              if(value==false){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Credentials ! Try Again'),));
                              }
                            }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: rdcolors.secondarycolor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}


class LoginDesktop extends StatefulWidget {
  const LoginDesktop({Key? key}) : super(key: key);

  @override
  _LoginDesktopState createState() => _LoginDesktopState();
}

class _LoginDesktopState extends State<LoginDesktop> {

  final AuthMethod authmethod= AuthMethod();

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screensize.width/2,
            height: screensize.height,
            child: Image.asset('assets/images/pattern.png',fit: BoxFit.fill,),
          ),
          Container(
            width: screensize.width/2,
            child: Container(
                padding: EdgeInsets.all(50),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/logo.png',width: screensize.width/8,),
                            Text('Reddy Wines',style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            ),),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: screensize.width/1.7,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: TextField(
                                controller: usernamecontroller,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Username',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.all(5)
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 50,
                              width: screensize.width/1.7,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: TextField(
                                controller: passwordcontroller,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.all(5)
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  Future<bool> status = authmethod.signInWithEmailAndPassword(usernamecontroller.text,passwordcontroller.text);
                                  status.then((value) {
                                    if(value==true){
                                      if(prefs.getString('role')=='Sales Manager'){
                                        print('verify now');
                                        Navigator.of(context).pushNamed(VerifySM.route);
                                      }
                                      else if(prefs.getString('role')=='Manager'||prefs.getString('role')=='admin'){
                                        print('self verify now');
                                        Navigator.of(context).pushNamed(Selfverify.route);
                                        // Navigator.of(context).pushNamed(Dashboard_Main.route);
                                      }
                                    }
                                    if(value==false){
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Credentials ! Try Again'),));
                                    }
                                  }
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: rdcolors.secondarycolor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20),),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}


