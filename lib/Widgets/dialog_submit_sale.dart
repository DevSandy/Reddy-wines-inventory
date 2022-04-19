import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Methods/manage_sale_method.dart';

class dialog_submit_sale{
  showMyDialog(BuildContext context, String selectedstore, DateTime dateTime) {
    String date = "${dateTime.day}-${dateTime.month}-${dateTime.year}";

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Make a purchase'),
          content: Text('Are You sure to submit sales for $date'),
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
                bool res = await manage_sale_method().submitsales(selectedstore,date);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

}