import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Widgets/Header.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Methods/manage_purchase_method.dart';
import '../../Methods/manage_store.dart';
import '../../Widgets/dialog_make_purchase.dart';
import '../Stores/manage_stores.dart';
class Manage_Purchase_Store extends StatefulWidget {
  const Manage_Purchase_Store({Key? key}) : super(key: key);

  @override
  _Manage_Purchase_StoreState createState() => _Manage_Purchase_StoreState();
}

class _Manage_Purchase_StoreState extends State<Manage_Purchase_Store> {
  ScrollController _scrollController = ScrollController();
  String selectedstore = '';
  DateTime? selecteddate = DateTime.now();
  bool isdateselected = true;
  List<PlutoRow> rows =[];

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedstore= prefs.getString('storeid')!;
    rows =  await manage_purchase_method().getpurchases(prefs.getString('storeid')!,DateTime.now());
    setState(() {});
  }

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
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Purchases',style: TextStyle(fontSize: 25,color: Colors.white),),
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
        type: PlutoColumnType.number(),
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
        ),
      ),
    ):Center(child: Text('No Record Found',style: TextStyle(color: Colors.white),),);
  }
}
