import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import '../../Methods/manage_expense_method.dart';
import '../../Methods/manage_store.dart';
import '../../Widgets/Header.dart';
import '../../Widgets/dialog_make_expense.dart';
import '../Stores/manage_stores.dart';

class Manage_Expenses extends StatefulWidget {
  const Manage_Expenses({Key? key}) : super(key: key);

  @override
  _Manage_ExpensesState createState() => _Manage_ExpensesState();
}

class _Manage_ExpensesState extends State<Manage_Expenses> {
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


  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      floatingActionButton: selectedstore!=''?FloatingActionButton.extended(
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
        label: Text('Make Expenses'),
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
                        rows =  await manage_expense_method().getexpenses(storesFiltered[val].id,DateTime.now());
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
    double netexpense = 0;
    for(int i = 0;i<rows.length;i++){
      PlutoRow a = rows[i];
      netexpense = netexpense+int.parse(a.cells['amount']!.value);
    }


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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Container(
                margin: EdgeInsets.all(8),
                width: screensize.width/2,
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
                      Text('₹$netexpense',style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),)                    ],
                  ),
                ),
              ),
              Spacer(),
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
}
