import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Methods/manage_inventory_method.dart';
import '../../Methods/manage_purchase_method.dart';
import '../../Methods/manage_store.dart';
import '../../Widgets/Header.dart';
import '../Stores/manage_stores.dart';
class Manage_Inventory_Store extends StatefulWidget {
  const Manage_Inventory_Store({Key? key}) : super(key: key);

  @override
  _Manage_Inventory_StoreState createState() => _Manage_Inventory_StoreState();
}

class _Manage_Inventory_StoreState extends State<Manage_Inventory_Store> {


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
    rows =  await manage_inventory_method().getinventory(selectedstore,DateTime.now());
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
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
          Text('Inventory',style: TextStyle(fontSize: 25,color: Colors.white),),
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
        title: 'Buying Price',
        field: 'bp',
        type: PlutoColumnType.text(),
      ),
      /// Select Column definition
      // PlutoColumn(
      //   readOnly: true,
      //   title: 'Selling Price',
      //   field: 'sp',
      //   type: PlutoColumnType.number(),
      // ),

      /// Time Column definition
      PlutoColumn(
        readOnly: true,
        title: 'Quantity',
        field: 'qty',
        type: PlutoColumnType.number(),
      ),
      // PlutoColumn(
      //   readOnly: true,
      //   title: 'Margin',
      //   field: 'margin',
      //   type: PlutoColumnType.text(),
      // ),
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
    ):Center(child: Text('No Record Found'),);
  }


}
