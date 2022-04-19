import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_store.dart';
import 'package:reddywines/Screens/Stores/manage_stores.dart';

class dialog_edit_store{

  TextEditingController namecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();


  showMyDialog(BuildContext context, Store usersFiltered) async {
    namecontroller.text=usersFiltered.name;
    addresscontroller.text=usersFiltered.address;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new store'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Fill in the form below.'),
                TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Store Name',
                      hintText: 'Enter Store Name'
                  ),
                ),
                TextField(
                  controller: addresscontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Store Address',
                      hintText: 'Enter Store Address'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                bool res = await managestore().updatestore(usersFiltered.Key,namecontroller.text,addresscontroller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}