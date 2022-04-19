import 'dart:convert';
import 'dart:html';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Methods/manage_purchase_method.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Methods/manage_store.dart';
import '../../Widgets/Header.dart';
import '../../Widgets/dialog_delete_purchase.dart';
import '../../Widgets/dialog_make_purchase.dart';
import '../Stores/manage_stores.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column,Row,Border;
import 'package:flutter/foundation.dart' show kIsWeb;
class Manage_Purchase extends StatefulWidget {
  const Manage_Purchase({Key? key}) : super(key: key);

  @override
  _Manage_PurchaseState createState() => _Manage_PurchaseState();
}

class _Manage_PurchaseState extends State<Manage_Purchase> {
  ScrollController _scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  String selectedstore = '';
  List<Store> storesFiltered = [];
  List<Store> stores = [];
  int? tag;
  DateTime? selecteddate = DateTime.now();
  bool isdateselected = false;
  List<PlutoRow> rows =[];

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
  TextEditingController countcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      floatingActionButton: selectedstore!=''?FloatingActionButton.extended(
        onPressed: () async {
          await dialog_make_purchase().showMyDialog(context,selectedstore,selecteddate!);
          rows =  await manage_purchase_method().getpurchases(selectedstore,selecteddate!);
          setState(() {
            isdateselected=false;
          });
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            isdateselected =true;
          });
        },
        backgroundColor: rdcolors.secondarycolor,
        label: Text('Make Purchase'),
        icon: Icon(Icons.add),
        tooltip: 'Ctrl+D',
      ):Container(),
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
                        });
                        rows =  await manage_purchase_method().getpurchases(storesFiltered[val].id,DateTime.now());
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
    );
  }

  Selectdate(String selectedstore, BuildContext context) {
    var screensize = MediaQuery.of(context).size;
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
              Text('Recent Purchases',style: TextStyle(fontSize: 25,color: Colors.white),),
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
                              await dialog_make_purchase().showMyDialog(context,selectedstore,selecteddate!);
                              rows =  await manage_purchase_method().getpurchases(selectedstore,selecteddate!);
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
              SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                if(rows.length==0){
                  print('no data');

                }else{
                  Createxls(rows,selectedstore);

                }
              }, child: Text('Download'))
            ],
          ),
          CalendarTimeline(
            initialDate: selecteddate!,
            firstDate: DateTime(2020, 1, 01),
            lastDate: DateTime.now(),
            onDateSelected: (date) async {
              setState(() {
                isdateselected=false;
              });
              rows =  await manage_purchase_method().getpurchases(selectedstore,date!);
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
    var screensize = MediaQuery.of(context).size;
    List<PlutoColumn> columns = [
      /// Text Column definition
      PlutoColumn(
        enableRowChecked: true,
        readOnly: true,
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      /// Number Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Type',
        field: 'type',
        type: PlutoColumnType.text(),
      ),
      /// Select Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Buying Price',
        field: 'bp',
        type: PlutoColumnType.text(),
      ),

      /// Time Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Quantity',
        field: 'qty',
        type: PlutoColumnType.number(),
      ),

      PlutoColumn(
        readOnly: true,
        title: 'Date',
        field: 'date',
        type: PlutoColumnType.text(),
      ),


    ];
    return rows.length!=0?Container(
      width: screensize.width,
      height: screensize.height/2,
      margin: EdgeInsets.only(bottom: 50),
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
        ),
      ),
    ):Center(child: Text('No Record Found'),);
  }


  Createxls(List<PlutoRow> rowss, String selectedstore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rows= ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A2').setText('PRODUCT');
    sheet.getRangeByName('B2').setText('TYPE');
    sheet.getRangeByName('C2').setText('QTY');
    sheet.getRangeByName('D2').setText('BUYING PRICE');
    sheet.getRangeByName('F2').setText('DATE');
    for(int i = 0 ;i<rowss.length;i++){
      sheet.getRangeByIndex(i+3, 1).setText(rowss[i].cells['name']!.value);
      sheet.getRangeByIndex(i+3, 2).setText(rowss[i].cells['type']!.value);
      sheet.getRangeByIndex(i+3, 3).setText(rowss[i].cells['qty']!.value.toString());
      sheet.getRangeByIndex(i+3, 4).setText(rowss[i].cells['bp']!.value.toString());
      sheet.getRangeByIndex(i+3, 5).setText(rowss[i].cells['date']!.value.toString());
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


  Future<void> handleOnRowChecked(PlutoGridOnRowCheckedEvent event) async {
    String docid = event.row?.cells['id']?.value;
    await dialogdeletepurchase().showMyDialog(context,docid,event.row?.cells['name']?.value,event.row?.cells['qty']?.value,selectedstore,selecteddate!,event.row?.cells['type']?.value);
    setState(() {
      isdateselected=false;
    });
    rows =  await manage_purchase_method().getpurchases(selectedstore,selecteddate!);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isdateselected = true;
    });
  }

}
