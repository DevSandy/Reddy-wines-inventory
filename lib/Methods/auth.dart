import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reddywines/Utils/Db_Paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }

  Future<bool> createuserWithEmailAndPassword(String fname,String lname, String email, String password, String role, String store, String storename, String phone,) async{
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      await registeruserintodb(user,email,password,fname,lname,role,store,storename,phone);
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user!;
      await getuserinfo(user.uid);
      return true;
      // Navigator.of(context).pushNamed(Dashboard_Main.route);
    } catch (e) {
      print(e);
      return false;
    }
  }

  getuserinfo(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference users = dbpaths.userpath;
    await users.doc(uid).get().then((value) {
      prefs.setString('uid', uid);
      prefs.setString('username', value.get('username'));
      prefs.setString('password', value.get('password'));
      prefs.setString('role', value.get('role'));
      prefs.setString('firstname', value.get('firstname'));
      prefs.setString('lastname', value.get('lastname'));
      prefs.setString('storeid', value.get('store'));
      prefs.setString('storename', value.get('storename'));
      prefs.setString('phone', value.get('phone'));
    });
  }

  registeruserintodb(User? user, String email, String password, String fname, String lname, String role, String store, String storename, String phone) async {
    CollectionReference users = dbpaths.userpath;
    await users.doc(user!.uid).set({
      'firstname': fname,
      'lastname': lname,
      'password': password,
      'role': role,
      'username': user.email,
      'created_at': DateTime.now(),
      'store': store,
      'storename': storename,
      'phone': phone,
    });
    return;
  }
}
