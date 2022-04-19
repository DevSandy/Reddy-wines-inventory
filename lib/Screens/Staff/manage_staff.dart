import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:reddywines/Methods/manage_store.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:reddywines/Widgets/dialog_add_user.dart';
import 'package:reddywines/Widgets/dialog_delete_user.dart';
import 'package:reddywines/Widgets/dialog_manage_user.dart';

import '../../Methods/auth.dart';
import '../../Methods/manage_users.dart';
import '../../Widgets/Header.dart';
import '../Stores/manage_stores.dart';
class Manage_Staff extends StatefulWidget {
  const Manage_Staff({Key? key}) : super(key: key);

  @override
  _Manage_StaffState createState() => _Manage_StaffState();
}

class _Manage_StaffState extends State<Manage_Staff> {
  ScrollController _scrollController = new ScrollController();

  List<Store> storeslist = [];
  List<UserModel> users = [];
  List<UserModel> usersFiltered = [];

  TextEditingController controller = TextEditingController();
  String _searchResult = '';



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
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    width: screensize.width,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("All Users",style: TextStyle(color: Colors.white,fontSize: 18),),
                            Spacer(),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    primary: rdcolors.secondarycolor
                                ),
                                onPressed: () async {
                                  await dialog_add_user().showMyDialog(context,storeslist);
                                  await init();
                                },
                                child: Text('Add User')
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
              ),

              //table
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
                              user.firstname.contains(_searchResult) ||
                                  user.lastname.contains(_searchResult) ||
                                  user.storename.contains(_searchResult) ||
                                  user.role.contains(_searchResult))
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
                              'First Name',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Last Name',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Username',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Role',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Phone',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Store',
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
                              DataCell(Center(child: Text(usersFiltered[index].firstname,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].lastname,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].username,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].role,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].phone,style: TextStyle(color: Colors.white),))),
                              DataCell(Center(child: Text(usersFiltered[index].storename,style: TextStyle(color: Colors.white),))),
                              usersFiltered[index].role!='admin'?DataCell(Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      primary: rdcolors.secondarycolor
                                  ),
                                  onPressed: () async {
                                    await dialog_manage_user().showMyDialog(context,usersFiltered[index],storeslist);
                                    await init();
                                  },
                                  child: const Text('Manage'),
                                ),
                              )):
                                  const DataCell(Center(child: Text('Not available',style: TextStyle(color: Colors.grey),),)),

                              usersFiltered[index].role!='admin'?DataCell(Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      primary: rdcolors.secondarycolor
                                  ),
                                  onPressed: () async {
                                    await dialog_delete_user().showMyDialog(context, usersFiltered[index].key,usersFiltered[index].firstname);
                                    await init();
                                  },
                                  child: const Text('Delete'),
                                ),
                              )):
                              const DataCell(Center(child: Text('Not available',style: TextStyle(color: Colors.grey),),)),
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
    users = await manageusers().getusers();
    usersFiltered = users;
    setState(() {});
    storeslist = await managestore().getstores();
  }

}


class UserModel {
  String firstname;
  String lastname;
  String username;
  String role;
  String phone;
  Timestamp created;
  String store;
  String key;
  String storename;

  UserModel({required this.firstname, required this.lastname, required this.username,required this.role,required this.phone,required this.created,required this.store,required this.key,required this.storename});
}
