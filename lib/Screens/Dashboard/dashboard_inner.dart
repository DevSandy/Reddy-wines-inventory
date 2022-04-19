import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Methods/dashboard_data_methods.dart';
import 'package:reddywines/Methods/manage_expense_method.dart';
import 'package:reddywines/Methods/manage_sale_method.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:reddywines/Widgets/Header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column,Row,Border;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../Methods/manage_store.dart';
import '../Stores/manage_stores.dart';
class Dashboard_inner extends StatefulWidget {
  const Dashboard_inner({Key? key}) : super(key: key);

  @override
  _Dashboard_innerState createState() => _Dashboard_innerState();
}

class _Dashboard_innerState extends State<Dashboard_inner> {
  ScrollController _scrollController = ScrollController();
  String dropdownValue = 'SELECT MONTH';
  String dropdownValue2 = 'SELECT YEAR';
  String dropdownValue3 = 'SELECT STORE';
  List<Store> stores = [];
  List<String> storelist = ['SELECT STORE'];
  Map res={} ;
  List<PlutoRow> rows =[];
  double netrevenue = 0;
  double netprofit = 0;
  double realisedpl = 0;
  int expense = 0;
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  width: screensize.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Analytics",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              res['netsales']!=null?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Net Sales',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['netsales'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Net Profit',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['netprofit'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Net Expenses',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['netexpenses'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),

                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Net P&L',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['netpnl'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),

                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ):Container(),
              res['netsales']!=null?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Stores',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['totalstores'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),

                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Staff',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['totalstaff'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Admins',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['totaladmin'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: screensize.width/6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Sales Managers',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Text(res['totalsm'].toString(),style: TextStyle(color: Colors.white,fontSize: 30),),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ):Container(),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  width: screensize.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "SALES",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            value: dropdownValue,
                            dropdownColor: rdcolors.primarycolor,
                            icon: const Icon(Icons.arrow_downward,color: Colors.white,),
                            elevation: 16,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['SELECT MONTH', '1', '2', '3','4','5','6','7','8','9','10','11','12']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: TextStyle(color: Colors.white),),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: 20,),
                          DropdownButton<String>(
                            value: dropdownValue2,
                            icon: const Icon(Icons.arrow_downward,color: Colors.white,),
                            elevation: 16,
                            dropdownColor: rdcolors.primarycolor,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            },
                            items: <String>['SELECT YEAR', '2015', '2016', '2017','2018','2019','2020','2021','2022','2023','2024','2025','2026']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: TextStyle(color: Colors.white),),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: 20,),
                          DropdownButton<String>(
                            value: dropdownValue3,
                            icon: const Icon(Icons.arrow_downward,color: Colors.white,),
                            elevation: 16,
                            dropdownColor: rdcolors.primarycolor,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue3 = newValue!;
                              });
                            },
                            items: storelist
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: TextStyle(color: Colors.white),),
                              );
                            }).toList(),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  primary: rdcolors.secondarycolor
                              ),
                              onPressed: () async {
                                String storeid='';
                                for(int i = 0;i<stores.length;i++){
                                  if(stores[i].name == dropdownValue3){
                                     storeid  = stores[i].id;
                                  }
                                }
                                rows =  await manage_sale_method().getcustomsale(dropdownValue,dropdownValue2,dropdownValue3,storeid);
                                expense = await manage_expense_method().getcustomexpence(dropdownValue,dropdownValue2,dropdownValue3,storeid);
                                setState(() {});
                              }, child: const Text('Apply'),
                          ),
                          SizedBox(width: 30,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: rdcolors.secondarycolor
                            ),
                            onPressed: () async {
                              if(rows.length==0){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Please select the fields first'),
                                ));
                              }else{
                                Createxls(rows,dropdownValue3);
                              }
                            },
                            child: const Text('Download'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              rows.length!=0?TableWidget():Center(child: Text('No Data found',style: TextStyle(color: Colors.white),))
            ],
          ),
        ),
      ),
    );
  }

  init() async {
     res = await dashboard_data_methods().getallsalesdata();
     stores = await managestore().getstores();
     for(int i = 0;i<stores.length;i++){
       storelist.add(stores[i].name);
     }
     setState(() {});
  }

  TableWidget() {

    var screensize = MediaQuery.of(context).size;
    for(int i = 0;i<rows.length;i++){
      PlutoRow a = rows[i];
      netrevenue = netrevenue+a.cells['total_sale_amount']!.value;
      netprofit = netprofit+a.cells['total_profit']!.value;
    }

    realisedpl = netprofit-expense;

    List<PlutoColumn> columns = [
      /// Text Column definition
      PlutoColumn(
        readOnly: true,
        title: 'SaleId',
        field: 'saleid',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Product',
        field: 'product',
        type: PlutoColumnType.text(),
      ),
      /// Number Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Qty',
        field: 'qty',
        type: PlutoColumnType.text(),
      ),
      /// Select Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Total Buying Price',
        field: 'total_bp',
        type: PlutoColumnType.text(),
      ),

      /// Time Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Total Profit',
        field: 'total_profit',
        type: PlutoColumnType.text(),
      ),

      PlutoColumn(
        readOnly: true,
        title: 'Total Sale Amount',
        field: 'total_sale_amount',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Date',
        field: 'date',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Submitted',
        field: 'submitted',
        type: PlutoColumnType.text(),
      ),
    ];
    return rows.length!=0?Container(
      width: screensize.width,
      height: screensize.height,
      margin: EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                width: screensize.width/6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Net Revenue',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('₹$netrevenue',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                width: screensize.width/6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Net Profit',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('₹$netprofit',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                width: screensize.width/6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Net Expenses',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('₹$expense',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                width: screensize.width/6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Realised P&L',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('₹$realisedpl',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PlutoGrid(
              columns: columns,
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                // stateManager = event.stateManager;
              },
              onChanged: (PlutoGridOnChangedEvent event) {
                print(event);
              },
              configuration: const PlutoGridConfiguration(
                  scrollbarConfig: PlutoGridScrollbarConfig(
                    isAlwaysShown: true,
                    draggableScrollbar: true,
                    scrollbarRadius: Radius.circular(50),
                    scrollbarRadiusWhileDragging: Radius.circular(50),
                    scrollbarThickness: 10,
                    scrollbarThicknessWhileDragging: 10,
                  ),
                  enableColumnBorder: true,
                  borderColor: rdcolors.secondarycolor,
                  gridBackgroundColor: rdcolors.primarycolor,
                  cellTextStyle: TextStyle(color: Colors.white),
                  columnTextStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                  menuBackgroundColor: rdcolors.primarycolor,
                  cellColorInEditState: Colors.black,
                  activatedColor: Colors.black26,
                  cellColorInReadOnlyState: rdcolors.primarycolor,
                  activatedBorderColor: rdcolors.secondarycolor
              ),
            ),
          ),
        ],
      ),
    ):Center(child: Text('No Record Found'),);
  }

  Future<void> Createxls(List<PlutoRow> rowss, String storename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rows= ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A2').setText('SALE ID');
    sheet.getRangeByName('B2').setText('PRODUCT');
    sheet.getRangeByName('C2').setText('QTY');
    sheet.getRangeByName('D2').setText('TOTAL BUYING PRICE');
    sheet.getRangeByName('E2').setText('TOTAL PROFIT');
    sheet.getRangeByName('F2').setText('TOTAL SALE AMOUNT');
    sheet.getRangeByName('G2').setText('SALE DATE');
    for(int i = 0 ;i<rowss.length;i++){
      sheet.getRangeByIndex(i+3, 1).setText(rowss[i].cells['saleid']!.value);
      sheet.getRangeByIndex(i+3, 2).setText(rowss[i].cells['product']!.value);
      sheet.getRangeByIndex(i+3, 3).setText(rowss[i].cells['qty']!.value.toString());
      sheet.getRangeByIndex(i+3, 4).setText(rowss[i].cells['total_bp']!.value.toString());
      sheet.getRangeByIndex(i+3, 5).setText(rowss[i].cells['total_profit']!.value.toString());
      sheet.getRangeByIndex(i+3, 6).setText(rowss[i].cells['total_sale_amount']!.value.toString());
      sheet.getRangeByIndex(i+3, 7).setText(rowss[i].cells['date']!.value);
    }

    final Style globalStyle1 = workbook.styles.add('globalStyle1');
    globalStyle1.fontSize = 14;
    globalStyle1.fontColor = '#362191';
    globalStyle1.hAlign = HAlignType.center;
    globalStyle1.vAlign = VAlignType.center;
    globalStyle1.borders.bottom.lineStyle = LineStyle.thin;
    globalStyle1.borders.bottom.color = '#829193';
    globalStyle1.numberFormat = '0.00';
    sheet.getRangeByName('A1:F1').merge();
    sheet.getRangeByName('A1').setText(storename);
    sheet.getRangeByName('A1').cellStyle=globalStyle1;
    sheet.getRangeByIndex(rowss.length+3, 5).setText("Total Sales : "+netrevenue.toString());
    sheet.getRangeByIndex(rowss.length+4, 5).setText("Total Profit : "+netprofit.toString());
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.xlsx')
        ..click();
    }
  }
}
