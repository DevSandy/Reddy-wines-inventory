import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Screens/Products/manage_products.dart';
import 'package:reddywines/Utils/Db_Paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class manage_sale_method{
  CollectionReference salesref = dbpaths.salespath;
  CollectionReference inventoryref = dbpaths.inventorypath;
  Map? data ;
  String inventoryid ='';
  makesale(String selectedproduct, String Quantity, String selectedstore, DateTime selecteddate, List<ProductModel> productlist,saleapproved) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";

    Random random = new Random();
    int randomNumber = random.nextInt(100000);

    String saleid = 'RDW-SALE-'+randomNumber.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await inventoryref
    .where('store_id',isEqualTo: selectedstore)
    .where('product', isEqualTo: selectedproduct)
    .get()
    .then((value) {
      if(value.docs.length!=0){
        value.docs.forEach((element) {
          inventoryid = element.id;
          data = element.data() as Map?;
        });
      }else{
        return false;
      }
    })
    .catchError((e) {
      return false;
    });
    try{
      if(data!['qty']>=int.parse(Quantity)){
        await inventoryref.doc(inventoryid).update(
          {
            'qty':data!['qty']-int.parse(Quantity)
          }
        )
        .then((value) {
        })
        .catchError((e) {
        });
        await salesref.add(
            {
              'saleid':saleid,
              'date':date,
              'timestamp':selecteddate,
              'product':selectedproduct,
              'qty':Quantity,
              'total_bp':data!['bp']*double.parse(Quantity),
              'total_sale_amount':double.parse(data!['sp'])*double.parse(Quantity),
              'total_profit':data!['margin']*double.parse(Quantity),
              'store':selectedstore,
              'sale_by': prefs.getString('username'),
              'sale_approved':saleapproved,
              'month':selecteddate.month.toString(),
              'year':selecteddate.year.toString(),
            }
        );
        return true;
      }else{
        return false;
      }
    }
    catch(e){
      return false;
    }

  }



  Future<List<PlutoRow>>getsales(String selectedstore, DateTime selecteddate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<PlutoRow> saleslist =[];
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    if(prefs.getString('role')=='Sales Manager'){
      await salesref
          .where('date', isEqualTo: date)
          .where('store',isEqualTo: selectedstore)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          Map? data = element.data() as Map?;
          saleslist.add(
              PlutoRow(
                cells: {
                  'saleid': PlutoCell(value: data!['saleid']),
                  'product': PlutoCell(value: data['product']),
                  'qty': PlutoCell(value: data['qty']),
                  'total_bp': PlutoCell(value: data['total_bp'].toStringAsFixed(3)),
                  'total_profit': PlutoCell(value: data['total_profit'].toStringAsFixed(3)),
                  'total_sale_amount': PlutoCell(value: data['total_sale_amount'].toStringAsFixed(3)),
                  'submitted': PlutoCell(value: data['sale_approved']),
                  'date': PlutoCell(value: data['date']),
                  'timestamp':PlutoCell(value: data['timestamp'].seconds),
                },
              )
          );
        });
      })
          .catchError((e) {
        return null;
      });
      saleslist.sort((a,b) => b.cells['timestamp']!.value.toString().toLowerCase().compareTo(a.cells['timestamp']!.value.toString().toLowerCase()));

      return saleslist;
    }else{
      await salesref
          .where('date', isEqualTo: date)
          .where('store',isEqualTo: selectedstore)
          .where('sale_approved',isEqualTo: true)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          Map? data = element.data() as Map?;
          saleslist.add(
              PlutoRow(
                cells: {
                  'saleid': PlutoCell(value: data!['saleid']),
                  'product': PlutoCell(value: data['product']),
                  'qty': PlutoCell(value: data['qty']),
                  'total_bp': PlutoCell(value: data['total_bp']),
                  'total_profit': PlutoCell(value: data['total_profit']),
                  'total_sale_amount': PlutoCell(value: data['total_sale_amount']),
                  'submitted': PlutoCell(value: data['sale_approved']),
                  'timestamp':PlutoCell(value: data['timestamp'].seconds),
                },
              )
          );
        });
      })
          .catchError((e) {
        return null;
      });
      saleslist.sort((a,b) => b.cells['timestamp']!.value.toString().toLowerCase().compareTo(a.cells['timestamp']!.value.toString().toLowerCase()));

      return saleslist; 
    }

  }

  checkifsaleisapproved(saleid) async {
    await salesref.where('saleid',isEqualTo: saleid)
    .get()
    .then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
      });
    });
    return data!['sale_approved'];
  }

  getsaledocid(saleid, BuildContext context) async {
    String docid = '';
    await salesref
        .where('saleid',isEqualTo: saleid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        docid = element.id;
      });
    });
    return docid;
  }

  deletesale(String docid) async {
    String deletedproduct = '';
    String deletedfrmstore = '';
    String deletedqty = '';
    String delinventoryid ='';
    int delinventoryqty =0;
    await salesref.doc(docid).get().then((value) {
      deletedproduct = value.get('product');
      deletedfrmstore = value.get('store');
      deletedqty = value.get('qty');
    });
    await inventoryref.where('store_id',isEqualTo: deletedfrmstore).where('product',isEqualTo: deletedproduct)
    .get()
    .then((value) {
      value.docs.forEach((element) {
        Map? data = element.data() as Map?;
        delinventoryid = element.id;
        delinventoryqty = data!['qty'];
      });
    });

    await inventoryref.doc(delinventoryid).update(
      {
        'qty':int.parse(deletedqty)+delinventoryqty
      }
    ).then((value) {
    });
    await salesref.doc(docid).delete().then((value) => print('sale deleted'));
    return true;
  }

  submitsales(String selectedstore, String date) async {
    List<String> saleelementids=[];
    await salesref
    .where('date' ,isEqualTo: date)
    .where('store',isEqualTo: selectedstore)
    .where('sale_approved',isEqualTo: false)
    .get().then((value) {
      value.docs.forEach((element) {
        saleelementids.add(element.id);
      });
    });
    for(int i = 0 ;i<saleelementids.length;i++){
      salesref.doc(saleelementids[i]).update(
        {
          'sale_approved':true
        }
      );
    }
    return true;
  }

  Future<List<PlutoRow>>getcustomsale(String month, String year, String storename, String storeid) async {
    List<PlutoRow> saleslist =[];

    await salesref.
    where('month',isEqualTo: month)
        .where('year' ,isEqualTo: year)
    .where('store',isEqualTo: storeid)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            Map? data = element.data() as Map?;
            saleslist.add(
                PlutoRow(
                  cells: {
                    'saleid': PlutoCell(value: data!['saleid']),
                    'product': PlutoCell(value: data['product']),
                    'qty': PlutoCell(value: data['qty']),
                    'total_bp': PlutoCell(value: data['total_bp']),
                    'total_profit': PlutoCell(value: data['total_profit']),
                    'total_sale_amount': PlutoCell(value: data['total_sale_amount']),
                    'submitted': PlutoCell(value: data['sale_approved']),
                    'date': PlutoCell(value: data['date']),
                  },
                )
            );
          });
        });
    return saleslist;
  }
}