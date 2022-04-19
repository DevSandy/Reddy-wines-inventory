import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class manage_otp_verifiers{
  CollectionReference otpverifierpath = dbpaths.otpverifiers;

  addverifier(String title, String phone, String email) async {
    await otpverifierpath.add(
      {
        'title':title,
        'email':email,
        'phone':phone
      }
    );
    return true;
  }

  getallverifiers() async {
    List<otpverifiers> otpverifierlist=[];
    await otpverifierpath.get()
        .then((value) {
            value.docs.forEach((element) {
              Map? data = element.data() as Map?;
              otpverifierlist.add(otpverifiers(title: data!['title'], email: data['email'], phone: data['phone'], Key: element.id));
            });
        })
        .catchError((e) {
          return null;
        });
    return otpverifierlist;
  }

  deleteverifier(String key) async {
    await otpverifierpath.doc(key).delete();
    return true;
  }

}

class otpverifiers {
  String title;
  String email;
  String phone;
  String Key;

  otpverifiers({required this.title, required this.email, required this.phone,required this.Key});
}
