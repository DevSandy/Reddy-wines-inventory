
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_users.dart';
import 'package:reddywines/Screens/Staff/manage_staff.dart';
import 'package:reddywines/Screens/Stores/manage_stores.dart';

import '../Methods/auth.dart';

class dialog_manage_user {
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  String role = '';
  String store = '';
  String storename = '';

  TextEditingController myController = TextEditingController();

  final focus = FocusNode();
  final submitfocus = FocusNode();

  showMyDialog(BuildContext context, UserModel userModel, List<Store> storeslist) async {
    List <String>storenames = [];
    fnamecontroller.text=userModel.firstname;
    lnamecontroller.text=userModel.lastname;
    emailcontroller.text=userModel.username;
    phonecontroller.text=userModel.phone;
    role=userModel.role;
    store=userModel.store;
    storename=userModel.storename;
    for(int i = 0;i<storeslist.length;i++){
      storenames.add(storeslist[i].name);
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new user'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Fill in the form below.'),
                TextField(
                  controller: fnamecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'First Name',
                      hintText: 'Enter First Name'
                  ),
                ),
                TextField(
                  controller: lnamecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Last Name',
                      hintText: 'Enter Last Name'
                  ),
                ),
                DropdownSearch<String>(
                  //mode of dropdown
                  mode: Mode.DIALOG,
                  //to show search box
                  showSearchBox: true,
                  showSelectedItems: true,
                  //list of dropdown items
                  items: const [
                    "Manager",
                    "Sales Manager",
                  ],
                  label: "Role",
                  onChanged: (value){
                    role=value!;
                    FocusScope.of(context).requestFocus(focus);
                  },
                  //show selected item
                  selectedItem: userModel.role,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: phonecontroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Phone',
                      hintText: 'Enter Phone Number'
                  ),
                ),
                DropdownSearch<String>(
                  //mode of dropdown
                  mode: Mode.DIALOG,
                  //to show search box
                  showSearchBox: true,
                  showSelectedItems: true,
                  //list of dropdown items
                  items: storenames,
                  label: "Store",
                  onChanged: (value){
                    for(int i =0;i<storeslist.length;i++){
                      if(storeslist[i].name==value){
                        store = storeslist[i].id;
                        storename = storeslist[i].name;
                      }
                    }
                    FocusScope.of(context).requestFocus(submitfocus);
                  },
                  //show selected item
                  selectedItem: userModel.storename,
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
              focusNode: submitfocus,
              child: const Text('Submit'),
              onPressed: () async {
                //update user
                await manageusers().updateuser(fnamecontroller.text,lnamecontroller.text,userModel.key,role,store,storename,phonecontroller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}