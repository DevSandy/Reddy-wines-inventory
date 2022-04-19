
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Screens/Stores/manage_stores.dart';

import '../Methods/auth.dart';
import '../Methods/manage_otp_verifiers.dart';

class dialog_add_otp_verifier {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  showMyDialog(BuildContext context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Fill in the form below.'),
                TextField(
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Title',
                      hintText: 'Enter Title'
                  ),
                ),
                TextField(
                  controller: phonecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Phone',
                      hintText: 'Enter Phone Number'
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email',
                      hintText: 'Enter Email'
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
                await manage_otp_verifiers().addverifier(titlecontroller.text,phonecontroller.text,emailcontroller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}