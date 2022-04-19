import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

import '../Screens/Products/manage_products.dart';

class manage_product{

  CollectionReference products = dbpaths.productspath;


  addproduct(String name, String qtyincase, String sellingprice, String selectedcategory, String selectedstore) async {

    await products.add(
      {
        'name':name.toUpperCase(),
        'qtyincase':qtyincase,
        'category':selectedcategory,
        selectedstore:sellingprice
      }
    ).then((value) {
      return true;
    })
    .catchError((e) {
      return false;
    });
  }

  getproducts(String selectedstore) async {
    List<ProductModel> productlist=[];
    await products.get().then((value) {
      value.docs.forEach((element) {
      Map? data = element.data() as Map?;
      productlist.add(
        ProductModel(category: data!['category'], name: data['name'], qtyincase: data['qtyincase'], sellingprice: data[selectedstore], key: element.id)
      );
    });
    });
    productlist.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return productlist;

  }

  updateproduct(String name, String qtyincase, String sellingprice, String selectedcategory, String key, String selectedstore) async {

    await products.doc(key)
        .update(
        {
          'name':name.toUpperCase(),
          'qtyincase':qtyincase,
          selectedstore:sellingprice,
          'category':selectedcategory
        }
      )
    .then((value) {
      return true;
    })
    .catchError((e) {
      return false;
    });

  }

  deletestore(String key) async {
    await products.doc(key)
        .delete()
        .then((value) {
          return true;
        })
        .catchError((error) {
          return true;
        });
  }
}