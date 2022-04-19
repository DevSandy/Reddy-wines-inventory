import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reddywines/Methods/manage_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Methods/manage_purchase_method.dart';
import '../Methods/manage_sale_method.dart';
import '../Screens/Products/manage_products.dart';

class dialog_make_sale{
  final focus = FocusNode();


  showMyDialog(BuildContext context, String selectedstore, DateTime selecteddate) async {
    String selectedproduct = '';
    TextEditingController quantitycontroller = TextEditingController();
    List<ProductModel> productlist = await manage_product().getproducts(selectedstore);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                title: Text('Make a Sale'),
                content:SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      DropdownSearch<String>(
                        //mode of dropdown
                        mode: Mode.DIALOG,
                        //to show search box
                        showSearchBox: true,
                        showSelectedItems: true,
                        //list of dropdown items
                        items: [
                          for(int i = 0;i<productlist.length;i++)
                            productlist[i].name
                        ],
                        label: "Product",
                        onChanged: (value){
                          selectedproduct = value!;
                          FocusScope.of(context).requestFocus(focus);
                        },
                        //show selected item
                        selectedItem: "Select Product",
                      ),
                      TextField(
                        focusNode: focus,
                        controller: quantitycontroller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Quantity',
                            hintText: 'Enter Quantity'
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
                      bool saleapproved = false;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if(prefs.getString('role')=='admin'||prefs.getString('role')=='Manager')
                        {
                          saleapproved = true;
                        }
                      if(prefs.getString('role')=='Sales Manager'){
                        saleapproved = false;
                      }
                      bool res = await manage_sale_method().makesale(selectedproduct,quantitycontroller.text,selectedstore,selecteddate,productlist,saleapproved);
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