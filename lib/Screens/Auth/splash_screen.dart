import 'package:flutter/material.dart';
import 'package:reddywines/Screens/Auth/login_screen.dart';
import 'package:reddywines/Screens/Dashboard/dashboard_main.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Methods/auth.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  static const String route = '/Spalsh';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            Text('Reddy Wines',style: TextStyle(fontSize: 25,color: Colors.white),)
          ],
        ),
      )
    );
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('username')==null||prefs.getString('username')==""){
      await AuthMethod().logout();
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushNamed(Login.route);
    }else{
      if(prefs.getString('role')=='admin'){
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).pushNamed(Dashboard_Main.route);
      }
      if(prefs.getString('role')=='Manager'){
        if(prefs.getBool('isselfverified')==true){
          await Future.delayed(Duration(seconds: 3));
          Navigator.of(context).pushNamed(Dashboard_Main.route);
        }else{
          await AuthMethod().logout();
          await Future.delayed(Duration(seconds: 3));
          Navigator.of(context).pushNamed(Login.route);
        }
      }
      if(prefs.getString('role')=='Sales Manager'){
        if(prefs.getBool('isverified')==true){
          await Future.delayed(Duration(seconds: 3));
          Navigator.of(context).pushNamed(Dashboard_Main.route);
        }else{
          await AuthMethod().logout();
          await Future.delayed(Duration(seconds: 3));
          Navigator.of(context).pushNamed(Login.route);
        }
      }
    }
  }
}
