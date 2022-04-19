import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Methods/manage_sale_method.dart';
import '../../Widgets/Header.dart';
import '../../Widgets/dialog_delete_sale.dart';
import '../../Widgets/dialog_make_sale.dart';
import '../../Widgets/dialog_submit_sale.dart';
class Manage_Sales_Store extends StatefulWidget {
  const Manage_Sales_Store({Key? key}) : super(key: key);

  @override
  _Manage_Sales_StoreState createState() => _Manage_Sales_StoreState();
}

class _Manage_Sales_StoreState extends State<Manage_Sales_Store> {
  ScrollController _scrollController = ScrollController();
  String selectedstore = '';
  DateTime? selecteddate = DateTime.now();
  List<PlutoRow> rows =[];
  bool isdateselected = true;
  late PlutoGridStateManager stateManager;
  TextEditingController countcontroller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedstore= prefs.getString('storeid')!;
    rows =  await manage_sale_method().getsales(selectedstore,DateTime.now());
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton.extended(
            onPressed: () async {
              await dialog_submit_sale().showMyDialog(context,selectedstore,selecteddate!);
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
            label: Text('Submit All Sales'),
            icon: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              await dialog_make_sale().showMyDialog(context,selectedstore,selecteddate!);
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
            label: Text('Make New Sale'),
            icon: Icon(Icons.add),
            tooltip: 'Ctrl+Q',
          ),

        ],
      ),
      body: KeyBoardShortcuts(
        globalShortcuts: true,
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyQ},
        onKeysPressed: () async {
          selectedstore!=''?await dialog_make_sale().showMyDialog(context,selectedstore,selecteddate!):print('no store detected');
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
                //selectable card
                Selectdate(selectedstore,context),
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
    return Container(
      width: screensize.width,
      margin: EdgeInsets.only(left: 8,top: 30,bottom: 20),
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
              rows =  await manage_sale_method().getsales(selectedstore,date!);
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
        readOnly: true,
        title: 'SaleId',
        field: 'saleid',
        type: PlutoColumnType.text(),
        enableRowChecked: true,
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
      // PlutoColumn(
      //   readOnly: true,
      //   title: 'Total Buying Price',
      //   field: 'total_bp',
      //   type: PlutoColumnType.text(),
      // ),
      //
      // /// Time Column definition
      // PlutoColumn(
      //   readOnly: true,
      //   title: 'Total Profit',
      //   field: 'total_profit',
      //   type: PlutoColumnType.text(),
      // ),
      //
      // PlutoColumn(
      //   readOnly: true,
      //   title: 'Total Sale Amount',
      //   field: 'total_sale_amount',
      //   type: PlutoColumnType.text(),
      // ),
      PlutoColumn(
        readOnly: true,
        title: 'Submitted ?',
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
          Expanded(
            child: PlutoGrid(
              columns: columns,
              rows: rows,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                // stateManager = event.stateManager;
              },
              onChanged: (PlutoGridOnChangedEvent event) {
                print(event.row);
              },
              onRowChecked: handleOnRowChecked,
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
    ):Center(child: Text('No Record Found',style: TextStyle(color: Colors.white),),);
  }


  Future<void> handleOnRowChecked(PlutoGridOnRowCheckedEvent event) async {
    bool res =  await manage_sale_method().checkifsaleisapproved(event.row?.cells['saleid']?.value);
    print(res);
    if(res == false){
      String docid = await manage_sale_method().getsaledocid(event.row?.cells['saleid']?.value,context);
      await dialogdeletesale().showMyDialog(context,docid,event.row?.cells['saleid']?.value);
      setState(() {
        isdateselected=false;
      });
      rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        isdateselected = true;
      });
    }
    if(res == true){
      await dialogsalewarning(context);
      setState(() {
        isdateselected=false;
      });
      rows =  await manage_sale_method().getsales(selectedstore,selecteddate!);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        isdateselected = true;
      });
    }
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
                Text('This Sale is already submitted,You cannot edit it once submitted')
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

}
