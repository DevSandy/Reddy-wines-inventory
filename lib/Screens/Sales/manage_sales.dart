import 'dart:convert';
import 'dart:html';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:new_keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:reddywines/Methods/manage_expense_method.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Methods/manage_sale_method.dart';
import '../../Methods/manage_store.dart';
import '../../Widgets/Header.dart';
import '../../Widgets/dialog_delete_sale.dart';
import '../../Widgets/dialog_make_sale.dart';
import '../Stores/manage_stores.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column,Row,Border;
import 'package:flutter/foundation.dart' show kIsWeb;

class Manage_Sales extends StatefulWidget {
  const Manage_Sales({Key? key}) : super(key: key);

  @override
  _Manage_SalesState createState() => _Manage_SalesState();
}

class _Manage_SalesState extends State<Manage_Sales> {
  ScrollController _scrollController = ScrollController();
  String selectedstore = '';
  DateTime? selecteddate = DateTime.now();
  List<PlutoRow> rows =[];
  bool isdateselected = false;
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  List<Store> storesFiltered = [];
  List<Store> stores = [];
  int? tag;

  double netrevenue = 0;
  double netprofit = 0;
  double realisedpl = 0;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    stores = await managestore().getstores();
    storesFiltered = stores;
    setState(() {});
  }
  int expenses= 0;

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      floatingActionButton: selectedstore!=''?FloatingActionButton.extended(
        onPressed: () async {
          await dialog_make_sale().showMyDialog(context,selectedstore,selecteddate!);
          netrevenue=0;
          netprofit =0;
          realisedpl =0;
          rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
          setState(() {
            isdateselected=false;
          });
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            isdateselected =true;
          });
        },
        backgroundColor: rdcolors.secondarycolor,
        label: Text('Make Sale'),
        icon: Icon(Icons.add),
        tooltip: 'Ctrl+Q',
      ):Container(),
      body: KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyQ},
        onKeysPressed: () async {
          selectedstore!=''?await dialog_make_sale().showMyDialog(context,selectedstore,selecteddate!):print('no store detected');
          netrevenue=0;
          netprofit =0;
          realisedpl =0;
          rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
          setState(() {
            isdateselected=false;
          });
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            isdateselected =true;
          });
        },
        child: SingleChildScrollView(
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
                  margin: EdgeInsets.only(top:8),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult = value;
                              storesFiltered = stores
                                  .where((storef) =>
                              storef.name.contains(_searchResult) ||
                                  storef.id.contains(_searchResult) ||
                                  storef.address.contains(_searchResult)
                              )
                                  .toList();
                            });
                          }),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            _searchResult = '';
                            storesFiltered = stores;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                //selectable card
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      ChipsChoice<int>.single(
                        value: tag,
                        onChanged: (val) async {
                          setState((){
                            isdateselected=false;
                            selectedstore ='';
                            expenses =0;
                          });
                          netrevenue=0;
                          netprofit =0;
                          realisedpl =0;
                          expenses =await manage_expense_method().getexpensestotal(storesFiltered[val].id, selecteddate!);
                          rows =  await manage_sale_method().getsales(storesFiltered[val].id,selecteddate!);
                          await Future.delayed(Duration(milliseconds: 500));
                          setState(() {
                            tag = val;
                            selectedstore = storesFiltered[val].id;
                            isdateselected = true;
                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: [
                            for(int i=0;i<storesFiltered.length;i++)
                              storesFiltered[i].name
                          ],
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                      )
                    ],
                  ),
                ),
                selectedstore!=''?Selectdate(selectedstore,context):Center(child: Container(
                    margin: EdgeInsets.all(8),
                    child: Text('No Store Selected')),),
                isdateselected?TableWidget(selectedstore,context,selecteddate!):Center(
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Selectdate(String selectedstore, BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    TextEditingController countcontroller = TextEditingController();
    return Container(
      width: screensize.width,
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent Sales',style: TextStyle(fontSize: 25,color: Colors.white),),
              Spacer(),
              ElevatedButton(
                onPressed: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('How many entries'),
                      content: TextField(
                        controller: countcontroller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Entries count',
                            hintText: 'Enter count'
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
                          child: const Text('Done'),
                          onPressed: () async {
                            for(int i = 0;i<int.parse(countcontroller.text);i++){
                              await dialog_make_sale().showMyDialog(context,selectedstore,selecteddate!);
                              netrevenue=0;
                              netprofit =0;
                              realisedpl =0;
                              rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
                              setState(() {
                                isdateselected=false;
                              });
                              await Future.delayed(Duration(milliseconds: 500));
                              setState(() {
                                isdateselected =true;
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
                }, child: Text('Rapid entry'),),
              SizedBox(width: 20,),
              ElevatedButton(
                  onPressed: (){
                    if(rows.length==0){
                      print('no data');
                    }else{
                      Createxls(rows,selectedstore);
                    }
                  },
                  child: Text('Download')
              )
            ],
          ),
          CalendarTimeline(
            initialDate: selecteddate!,
            firstDate: DateTime(2020, 1, 01),
            lastDate: DateTime.now(),
            onDateSelected: (date) async {
              setState(() {
                isdateselected=false;
                expenses =0;
              });
              netrevenue=0;
              netprofit =0;
              realisedpl =0;
              expenses =await manage_expense_method().getexpensestotal(selectedstore, date!);
              rows =  await manage_sale_method().getsales(selectedstore,date);
              await Future.delayed(Duration(milliseconds: 500));
              setState(() {
                isdateselected = true;
                selecteddate=date;
              });
              // selected_date = date!;
              // setState(() {
              // });
            },
            leftMargin: screensize.width/1.5,
            monthColor: Colors.white,
            dayColor: rdcolors.secondarycolor,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: rdcolors.secondarycolor,
            dotsColor: Color(0xFF333A47),
            locale: 'en_ISO',
          ),
        ],
      ),
    );
  }

  TableWidget(String selectedstore, BuildContext context, DateTime selecteddate) {
    netrevenue=0;
    netprofit =0;
    realisedpl =0;
    var screensize = MediaQuery.of(context).size;
    for(int i = 0;i<rows.length;i++){
      PlutoRow a = rows[i];
      netrevenue = netrevenue+a.cells['total_sale_amount']!.value;
      netprofit = netprofit+a.cells['total_profit']!.value;
    }

    realisedpl = netprofit-expenses;

    List<PlutoColumn> columns = [
      /// Text Column definition
      PlutoColumn(
        enableRowChecked: true,
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
                      Text('₹$expenses',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
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
              onRowChecked: handleOnRowChecked,
              columns: columns,
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                // stateManager = event.stateManager;
              },
              onChanged: (PlutoGridOnChangedEvent event) {
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

  Future<void> handleOnRowChecked(PlutoGridOnRowCheckedEvent event) async {
    String docid = await manage_sale_method().getsaledocid(event.row?.cells['saleid']?.value,context);
    await dialogdeletesale().showMyDialog(context,docid,event.row?.cells['saleid']?.value);
    setState(() {
      isdateselected=false;
    });
    netrevenue=0;
    netprofit =0;
    realisedpl =0;
    rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isdateselected = true;
    });
  }
  dialogsalewarning(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'This Sale is already submitted,You cannot edit it once submitted')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  Createxls(List<PlutoRow> rowss, String selectedstore) async {
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
    for(int i = 0 ;i<rowss.length;i++){
      sheet.getRangeByIndex(i+3, 1).setText(rowss[i].cells['saleid']!.value);
      sheet.getRangeByIndex(i+3, 2).setText(rowss[i].cells['product']!.value);
      sheet.getRangeByIndex(i+3, 3).setText(rowss[i].cells['qty']!.value.toString());
      sheet.getRangeByIndex(i+3, 4).setText(rowss[i].cells['total_bp']!.value.toString());
      sheet.getRangeByIndex(i+3, 5).setText(rowss[i].cells['total_profit']!.value.toString());
      sheet.getRangeByIndex(i+3, 6).setText(rowss[i].cells['total_sale_amount']!.value.toString());
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
    sheet.getRangeByName('A1').setText(selectedstore);
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
