import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class manage_inventory_method{
  CollectionReference inventoryfef = dbpaths.inventorypath;
  getinventory(String storeid, DateTime selecteddate) async {
    List<PlutoRow> inventorylist = [];
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    await inventoryfef
    .where('store_id',isEqualTo: storeid)
    .get()
    .then((value) {
      value.docs.forEach((element) {
        Map? data = element.data() as Map?;
        inventorylist.add(
            PlutoRow(
              cells: {
                'name': PlutoCell(value: data!['product']),
                'bp': PlutoCell(value: data['bp'].toStringAsFixed(3)),
                'sp': PlutoCell(value: data['sp']),
                'qty': PlutoCell(value: data['qty']),
                'margin': PlutoCell(value: data['margin'].toStringAsFixed(3)),
                'date': PlutoCell(value: data['date']),
              },
            )
        );
      });
    })
    .catchError((e) {
      return null;
    });
    return inventorylist;
  }
  
}