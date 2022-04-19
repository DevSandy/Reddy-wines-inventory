import 'package:flutter/material.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:reddywines/Widgets/Header.dart';

import '../../Methods/manage_otp_verifiers.dart';
import '../../Widgets/dialog_add_otp_verifier.dart';
import '../../Widgets/dialog_delete_verifiers.dart';
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ScrollController _scrollController = new ScrollController();
  List<otpverifiers> otpverifierslist = [];
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
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
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(12),
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
                child: Row(
                  children: [
                    Text('OTP Verifiers',style: TextStyle(fontSize: 25,color: Colors.white),),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          primary: rdcolors.secondarycolor
                      ),
                      onPressed: () async {
                        await dialog_add_otp_verifier().showMyDialog(context);
                        init();
                      },
                      child: const Text('Add New'),
                    ),
                  ],
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
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: List.generate(
                      otpverifierslist.length,
                          (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(Center(child: Text(otpverifierslist[index].title,style: TextStyle(color: Colors.white),))),
                          DataCell(Center(child: Text(otpverifierslist[index].email,style: TextStyle(color: Colors.white),))),
                          DataCell(Center(child: Text(otpverifierslist[index].phone,style: TextStyle(color: Colors.white),))),
                          DataCell(Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  primary: rdcolors.secondarycolor
                              ),
                              onPressed: () async {
                                await dialogdeleteverifiers().showMyDialog(context,otpverifierslist[index].Key,otpverifierslist[index].title);
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
              )

            ],
          ),
        ),
      ),
    );
  }
  init() async {
    otpverifierslist = await manage_otp_verifiers().getallverifiers();
    setState(() {});
  }
}
