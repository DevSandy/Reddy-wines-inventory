import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddywines/Screens/Stores/manage_stores.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class managestore{
  CollectionReference stores = dbpaths.storepath;
  Random random = new Random();


  Future<bool> addstore(String name,String address) async {
    int randomNumber = random.nextInt(99999); // from 0 upto 99 included
    String StoreId = "RDW-STR-"+randomNumber.toString();
    await stores.add(
      {
        'Id':StoreId,
        'Store_Name':name,
        'Store_Address':address
      }
    ).then((value){
      return true;
    })
    .catchError((error){
      return false;
    });
    return true;
  }

  getstores() async {
    List<Store> storeslist=[];
    await stores.get().then((value) => value.docs.forEach((element) {
      Map? data = element.data() as Map?;
      storeslist.add(
        Store(name: data!['Store_Name'], id: data['Id'], address: data['Store_Address'],Key:element.id)
      );
    }));
    return storeslist;
  }

  updatestore(key,name,address) async{
    await stores.doc(key)
        .update({
      'Store_Address':address,
      'Store_Name':name
    })
        .then((value) => print('updtated'))
        .onError((error, stackTrace) => print(error));
    return true;

  }

  deletestore(String key) async {
    await stores.doc(key)
        .delete()
        .then((value) => print('store deleted'))
        .catchError((error)=>print('failed to delete store'));
    return true;
  }
}