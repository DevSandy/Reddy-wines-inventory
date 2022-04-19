import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reddywines/Methods/manage_product.dart';

import '../Methods/manage_purchase_method.dart';
import '../Screens/Products/manage_products.dart';

class dialog_make_purchase{
  final focus = FocusNode();


  showMyDialog(BuildContext context, String selectedstore, DateTime selecteddate) async {
    String selectedtype = 'Choose Type';
    String selectedproduct = '';
    TextEditingController quantitycontroller = TextEditingController();
    TextEditingController buyingpricecontroller = TextEditingController();
    List<ProductModel> productlist = await manage_product().getproducts(selectedstore);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return AlertDialog(
                title: Text('Make a purchase'),
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

                      DropdownButton<String>(
                        focusNode: focus,
                        isExpanded: true,
                        value: selectedtype,
                        items: <String>[
                          'Choose Type',
                          'Cases',
                          'Bottle',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedtype = value!;
                          });
                        },
                      ),

                      TextField(
                        controller: quantitycontroller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Quantity',
                            hintText: 'Enter Quantity'
                        ),
                      ),
                      TextField(
                        controller: buyingpricecontroller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Buying Price(per qty)',
                            hintText: 'Enter Buying Price'
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
                      await manage_purchase_method().makepurchase(selectedproduct,selectedtype,quantitycontroller.text,buyingpricecontroller.text,selectedstore,selecteddate,productlist);
                      Navigator.of(context).pop();
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