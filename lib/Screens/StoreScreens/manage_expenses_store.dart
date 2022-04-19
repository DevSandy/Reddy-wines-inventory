import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Methods/manage_expense_method.dart';
import 'package:reddywines/Widgets/dialog_make_expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reddywines/Utils/rdcolors.dart';

import '../../Widgets/Header.dart';

class Manage_Expenses_Store extends StatefulWidget {
  const Manage_Expenses_Store({Key? key}) : super(key: key);

  @override
  _Manage_Expenses_StoreState createState() => _Manage_Expenses_StoreState();
}

class _Manage_Expenses_StoreState extends State<Manage_Expenses_Store> {
  ScrollController _scrollController = ScrollController();
  String selectedstore = '';
  DateTime? selecteddate = DateTime.now();
  List<PlutoRow> rows =[];
  bool isdateselected = true;
  late PlutoGridStateManager stateManager;


  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedstore= prefs.getString('storeid')!;
    rows =  await manage_expense_method().getexpenses(selectedstore,DateTime.now());
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
              await dialog_make_expense().showMyDialog(context,selectedstore,selecteddate!);
              rows =  await manage_expense_method().getexpenses(selectedstore,selecteddate!);
              setState(() {
                isdateselected=false;
              });
              await Future.delayed(Duration(milliseconds: 500));
              setState(() {
                isdateselected =true;
              });
            },
            backgroundColor: rdcolors.secondarycolor,
            label: Text('Make New Expense'),
            icon: Icon(Icons.add),
            tooltip: 'Ctrl+D',
          ),

        ],
      ),
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
              //selectable card
              Selectdate(selectedstore,context),
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
      margin: EdgeInsets.only(left: 8,top: 30,bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Sales',style: TextStyle(fontSize: 25,color: Colors.white),),
          CalendarTimeline(
            initialDate: selecteddate!,
            firstDate: DateTime(2020, 1, 01),
            lastDate: DateTime.now(),
            onDateSelected: (date) async {
              setState(() {
                isdateselected=false;
              });
              rows =  await manage_expense_method().getexpenses(selectedstore,date!);
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
        title: 'ExpenseId',
        field: 'expenseid',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Title',
        field: 'title',
        type: PlutoColumnType.text(),
      ),
      /// Number Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Comment',
        field: 'comment',
        type: PlutoColumnType.text(),
      ),
      /// Select Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Amount',
        field: 'amount',
        type: PlutoColumnType.text(),
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
