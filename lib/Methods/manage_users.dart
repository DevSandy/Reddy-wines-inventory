import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddywines/Screens/Staff/manage_staff.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class manageusers{

  CollectionReference users = dbpaths.userpath;


  getusers() async {
    List<UserModel> userlist=[];
    await users.get().then((value) => value.docs.forEach((element) {
      Map? data = element.data() as Map?;
      userlist.add(
          UserModel(firstname: data!['firstname'], lastname: data['lastname'], username: data['username'], store: data['store'], role: data['role'], created: data['created_at'], key: element.id,storename:data['storename'], phone: data['phone'] )
      );
    }));
    return userlist;
  }

  updateuser(String fname, String lname, String key, String role, String store, String storename, String phone) async {
    await users.doc(key).update(
      {
        'firstname':fname,
        'lastname':lname,
        'role':role,
        'store':store,
        'storename':storename,
        'phone':phone,
      }
    ).then((value) => print('user updated'))
    .catchError((e)=>print(e));
    return true;
  }

  deletestore(String key) async {
    await users.doc(key).delete().then((value) => print('deleted')).catchError((e)=>print(e));
    return true;
  }

}