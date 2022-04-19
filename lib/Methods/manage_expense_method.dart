import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class manage_expense_method{
  Map? data ;

  CollectionReference expensesref = dbpaths.expences;

  makeexpense(String title, String amount, String comment, String selectedstore, DateTime selecteddate) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";

    await expensesref.add({
      'title':title,
      'amount':amount,
      'comment':comment,
      'store':selectedstore,
      'datestamp':selecteddate,
      'date':date,
      'month':selecteddate.month,
      'year':selecteddate.year
    }).then((value) {
      return true;
    });

  }

  getexpenses(String selectedstore, DateTime selecteddate) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    List<PlutoRow> expenselist =[];
    await expensesref
    .where('store',isEqualTo: selectedstore).
    where('date',isEqualTo: date)
    .get()
    .then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
        expenselist.add(
          PlutoRow(cells: {
            'expenseid': PlutoCell(value: element.id),
            'title': PlutoCell(value: data!['title']),
            'comment': PlutoCell(value: data!['comment']),
            'amount': PlutoCell(value: data!['amount']),
            'date': PlutoCell(value: data!['date']),
          })
        );
      });
    });
    return expenselist;
  }

  getexpensestotal(String selectedstore, DateTime selecteddate) async {
    String date = "${selecteddate.day}-${selecteddate.month}-${selecteddate.year}";
    int expenses = 0;
    await expensesref
        .where('store',isEqualTo: selectedstore).
    where('date',isEqualTo: date)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
        expenses = expenses+int.parse(data!['amount']);
      }
      );
    });
    return expenses;
  }

  getcustomexpence(String month, String year, String storename, String storeid) async {
    int expence = 0;
    await expensesref
    .where('store',isEqualTo: storeid)
    .where('month',isEqualTo: int.parse(month))
    .where('year',isEqualTo: int.parse(year))
        .get()
        .then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
        expence = expence+int.parse(data!['amount']);
      }
      );
        });
    return expence;
  }


}