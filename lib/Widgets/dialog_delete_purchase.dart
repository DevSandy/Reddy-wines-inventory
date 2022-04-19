import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reddywines/Methods/manage_purchase_method.dart';
import 'package:reddywines/Methods/manage_sale_method.dart';

class dialogdeletepurchase{
  showMyDialog(BuildContext context, String docid, value, qty, String selectedstore, DateTime selecteddate, type) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete This Purchase $value')
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
                bool res = await manage_purchase_method().deletepurchase(docid,qty,selectedstore,selecteddate,value,type);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}