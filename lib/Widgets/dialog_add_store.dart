import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_store.dart';

class dialog_add_store{

  TextEditingController namecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();


   showMyDialog(BuildContext context) async {

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
                bool res = await managestore().addstore(namecontroller.text,addresscontroller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}