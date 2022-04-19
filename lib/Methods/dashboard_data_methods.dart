import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reddywines/Utils/Db_Paths.dart';

class dashboard_data_methods{
  CollectionReference salesref = dbpaths.salespath;
  CollectionReference expensesref = dbpaths.expences;
  CollectionReference storesref = dbpaths.storepath;
  CollectionReference usersref = dbpaths.userpath;
  Map? data ;

  getallsalesdata() async {
    double netsales = 0;
    double netprofit = 0;
    double netexpenses = 0;
    double netpnl = 0;
    int totalstores = 0;
    int totalstaff = 0;
    int totaladmin = 0;
    int totalsm = 0;
    await salesref.get().then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
        netsales = netsales+data!['total_sale_amount'];
        netprofit = netprofit+data!['total_profit'];
      });
    });

    await expensesref.get().then((value) {
      value.docs.forEach((element) {
        data = element.data() as Map?;
        netexpenses = netexpenses+double.parse(data!['amount']);
      });
    });

    await storesref.get().then((value) {
      totalstores = value.docs.length;
    });

    await usersref.where('role',isNotEqualTo: 'admin').get().then((value) {
      totalstaff = value.docs.length;
    });

    await usersref.where('role',isEqualTo: 'admin').get().then((value) {
      totaladmin = value.docs.length;
    });

    await usersref.where('role',isEqualTo: 'Sales Manager').get().then((value) {
      totalsm = value.docs.length;
    });
    netpnl = netprofit-netexpenses;
    Map res = {
      'netsales':netsales,
      'netprofit':netprofit,
      'netexpenses':netexpenses,
      'netpnl':netpnl,
      'totalstores':totalstores,
      'totalstaff':totalstaff,
      'totaladmin':totaladmin,
      'totalsm':totalsm
    };
    return res;
  }
}