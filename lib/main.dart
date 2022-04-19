import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Screens/Auth/login_screen.dart';
import 'package:reddywines/Screens/Dashboard/dashboard_main.dart';
import 'package:reddywines/Screens/Verify/self_verify.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'Screens/Auth/splash_screen.dart';
import 'Screens/Verify/verify_sm.dart';
import 'Utils/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: rdcolors.primarycolor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Splash.route,
      routes: {
        Splash.route: (context) => const Splash(),
        Login.route: (context) => const Login(),
        Dashboard_Main.route: (context) => const Dashboard_Main(),
        VerifySM.route: (context) => const VerifySM(),
        Selfverify.route: (context) => const Selfverify(),
      },
    );
  }
}
