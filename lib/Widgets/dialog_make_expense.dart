import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Methods/manage_expense_method.dart';

class dialog_make_expense{
  final focus = FocusNode();


  showMyDialog(BuildContext context, String selectedstore, DateTime selecteddate) async {
    TextEditingController titlecont = TextEditingController();
    TextEditingController amountcont = TextEditingController();
    TextEditingController commentcont = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                title: Text('Make an expense'),
                content:SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: titlecont,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Title',
                            hintText: 'Enter Title'
                        ),
                      ),
                      TextField(
                        controller: amountcont,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Amount',
                            hintText: 'Enter Amount Spent'
                        ),
                      ),
                      TextField(
                        controller: commentcont,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Comments',
                            hintText: 'Enter Comment'
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
                      bool res = await manage_expense_method().makeexpense(titlecont.text,amountcont.text,commentcont.text,selectedstore,selecteddate);
                      Navigator.of(context).pop();
                      if(res == false){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Something Went Wrong ! Check Inventory'),
                        ));
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
    );
  }

}