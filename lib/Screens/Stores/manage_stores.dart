import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_store.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:reddywines/Widgets/Header.dart';
import 'package:reddywines/Widgets/dialog_delete_store.dart';

import '../../Widgets/dialog_add_store.dart';
import '../../Widgets/dialog_edit_store.dart';

class Manage_Stores extends StatefulWidget {
  const Manage_Stores({Key? key}) : super(key: key);

  @override
  _Manage_StoresState createState() => _Manage_StoresState();
}

class _Manage_StoresState extends State<Manage_Stores> {
  final ScrollController _scrollController = ScrollController();

  List<Store> users = [];
  List<Store> usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  final dialog_add_store dialog1 = dialog_add_store();
  @override
  void initState() {
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
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
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
                            "All Stores",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: rdcolors.secondarycolor,
                                elevation: 10,
                              ),
                              onPressed: () async {
                                await dialog1.showMyDialog(context);
                                init();
                              },
                              child: const Text('Add Store'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //table goes here
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
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
                              usersFiltered = users
                                  .where((user) =>
                                      user.address.contains(_searchResult) ||
                                      user.name.contains(_searchResult) ||
                                      user.id.contains(_searchResult))
                                  .toList();
                            });
                          }),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            _searchResult = '';
                            usersFiltered = users;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(
                          width: 2.0,
                          color: rdcolors.secondarycolor,
                        ),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Store-ID',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Store Name',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Address',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Manage',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        rows: List.generate(
                          usersFiltered.length,
                          (index) => DataRow(
                            cells: <DataCell>[
                              DataCell(Center(child: Text(usersFiltered[index].id,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].name,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].address,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      primary: rdcolors.secondarycolor
                                  ),
                                  onPressed: () async {
                                    await dialog_edit_store().showMyDialog(context,usersFiltered[index]);
                                    await init();
                                  },
                                  child: const Text('Manage'),
                                ),
                              )),
                              DataCell(Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      primary: rdcolors.secondarycolor
                                  ),
                                  onPressed: () async {
                                    await dialog_delete_store().showMyDialog(context,usersFiltered[index].Key,usersFiltered[index].name);
                                    await init();
                                  },
                                  child: const Text('Delete'),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    users = await managestore().getstores();
    usersFiltered = users;
    setState(() {});
  }
}

class Store {
  String id;
  String name;
  String address;
  String Key;

  Store({required this.id, required this.name, required this.address,required this.Key});
}
