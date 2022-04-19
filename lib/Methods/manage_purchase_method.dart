import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Screens/Products/manage_products.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class manage_purchase_method{
  CollectionReference purchasesref = dbpaths.purchasepath;
  CollectionReference inventoryfef = dbpaths.inventorypath;
  CollectionReference profuctsref = dbpaths.productspath;

  makepurchase(String selectedproduct, String selectedtype, String quantity, String buyingprice, String selectedstore, DateTime selecteddate, List<ProductModel> productlist) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    await purchasesref.add(
      {
        'name':selectedproduct,
        'type':selectedtype,
        'qty':quantity,
        'bp':buyingprice,
        'store':selectedstore,
        'date':date,
        'timestamp':selecteddate
      }
    ).then((value) async {
      await addtoinventory(selectedproduct,selectedtype,quantity,buyingprice,selectedstore,date,productlist,date);
      return true;
    })
    .catchError((e) {
      return false;
    });

  }

  addtoinventory(String selectedproduct, String selectedtype, String quantity, String buyingprice, String selectedstore, String selecteddate, List<ProductModel> productlist, String date) async {
    String productid ='';
    String qtyincase = '';
    String sellingpriceperbtl = '';
    int totalbottles = 0 ;
    double buyingpriceperbtl = 0 ;
    double marginpriceperbtl = 0 ;
    
    inventoryfef
    .where('store_id',isEqualTo: selectedstore)
    .where('product',isEqualTo: selectedproduct)
    .get()
    .then((value) async {
      for(int i = 0;i<productlist.length;i++){
        if(selectedproduct==productlist[i].name){
          productid = productlist[i].key;
          qtyincase = productlist[i].qtyincase;
          sellingpriceperbtl = productlist[i].sellingprice;
        }
      }
      if(selectedtype == 'Cases'){
        totalbottles = int.parse(quantity)*int.parse(qtyincase);
        buyingpriceperbtl = double.parse(buyingprice)/(double.parse(qtyincase)*int.parse(quantity));
      }
      if(selectedtype=='Bottle'){
        totalbottles = int.parse(quantity);
        buyingpriceperbtl = double.parse(buyingprice)/int.parse(quantity);
      }
      marginpriceperbtl = double.parse(sellingpriceperbtl)-buyingpriceperbtl;

      if(value.docs.length==0){
        await inventoryfef.add(
            {
              'product_Id':productid,
              'product':selectedproduct,
              'qty':totalbottles,
              'bp':buyingpriceperbtl,
              'sp':sellingpriceperbtl,
              'margin':marginpriceperbtl,
              'date':date,
              'store_id':selectedstore
            }
        ).then((value) {
          return true;
        })
            .catchError((e) {
          return false;
        });
      }else{
        int bptoupdate = (value.docs[0]['bp']+buyingpriceperbtl)/2;
        int qtytoupdate = value.docs[0]['qty']+totalbottles;
        marginpriceperbtl = double.parse(sellingpriceperbtl)-bptoupdate;
        await inventoryfef.doc(value.docs[0].id).update(
            {
              'product_Id':productid,
              'product':selectedproduct,
              'qty':qtytoupdate,
              'bp':bptoupdate,
              'sp':sellingpriceperbtl,
              'margin':marginpriceperbtl,
              'date':date,
              'store_id':selectedstore
            }
        ).then((value) {
          return true;
        })
            .catchError((e) {
          return false;
        });
      }
    });


  }

   Future<List<PlutoRow>>getpurchases(String selectedstore, DateTime selecteddate) async {
    List<PlutoRow> purchaseslist =[];
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    await purchasesref.where('date', isEqualTo: date)
    .where('store',isEqualTo: selectedstore)
    .get()
    .then((value) {
      value.docs.forEach((element) {
        Map? data = element.data() as Map?;
        purchaseslist.add(
          PlutoRow(
            cells: {
              'name': PlutoCell(value: data!['name']),
              'type': PlutoCell(value: data['type']),
              'bp': PlutoCell(value: data['bp']),
              'qty': PlutoCell(value: data['qty']),
              'date': PlutoCell(value: data['date']),
              'id': PlutoCell(value: element.id),
              'timestamp':PlutoCell(value: data['timestamp'].seconds),
            },
          )
        );
      });
    })
    .catchError((e) {
      return null;
    });
    purchaseslist.sort((a,b) => b.cells['timestamp']!.value.toString().toLowerCase().compareTo(a.cells['timestamp']!.value.toString().toLowerCase()));
    return purchaseslist;
   }

  deletepurchase(String docid, qty, String selectedstore, DateTime selecteddate,String productname, type) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    await purchasesref.doc(docid).delete().then((value) async {
      await updateinventory(selectedstore,qty,productname,type);
    });
  }

  updateinventory(String selectedstore, qty, String productname, type) async {
    await inventoryfef.where('store_id', isEqualTo: selectedstore)
        .where('product',isEqualTo: productname)
        .get().then((value) {
          value.docs.forEach((element) async {
            Map? data = element.data() as Map?;
            await updateqty(element.id,qty,data!['qty'],type,productname);
          });
        });

  }

  updateqty(String id, qty, oldqty, type, String productname) {
    int newqty = 0;
    if(type=='Bottle'){
      newqty = oldqty-qty;
      if(newqty<0){
        newqty=0;
      }
    }
    if(type=='Cases'){
      profuctsref.where('name',isEqualTo: productname)
      .get().then((value) {
        value.docs.forEach((element) async {
          Map? data = element.data() as Map?;
          int qtytodelete = data!['qtyincase']*int.parse(qty);
          newqty = oldqty-qtytodelete;
        });
      });
    }
    if(newqty<0){
      newqty=0;
    }
    inventoryfef.doc(id).update({
      'qty':newqty
    });
  }
}