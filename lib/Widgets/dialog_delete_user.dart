import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_users.dart';

import '../Methods/manage_store.dart';

class dialog_delete_user{
  showMyDialog(BuildContext context, String key, String name) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete User $name')
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
                bool res = await manageusers().deletestore(key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}