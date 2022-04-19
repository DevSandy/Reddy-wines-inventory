import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reddywines/Methods/manage_product.dart';
import 'package:reddywines/Screens/Products/manage_products.dart';

class dialog_delete_product{
  showMyDialog(BuildContext context, ProductModel productsFiltered) {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete product '+productsFiltered.name)
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
                bool res = await manage_product().deletestore(productsFiltered.key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

}