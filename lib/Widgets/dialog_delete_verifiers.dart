import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reddywines/Methods/manage_otp_verifiers.dart';
import 'package:reddywines/Methods/manage_sale_method.dart';

class dialogdeleteverifiers{
  showMyDialog(BuildContext context, String key, title) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete Sale $title')
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
                bool res = await manage_otp_verifiers().deleteverifier(key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}