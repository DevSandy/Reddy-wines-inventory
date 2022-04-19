import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  String role = "";
  String firstname = "";
  String lastname = "";
  String store = "";
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(firstname+" "+lastname,style: TextStyle(fontSize: 25,color: Colors.white),),
          Text(role,style: TextStyle(fontSize: 18,color: Colors.white),),
          role!='admin'?Text(store,style: TextStyle(fontSize: 18,color: Colors.white),):Container()
        ],
      ),
    );
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role')!;
    firstname = prefs.getString('firstname')!;
    lastname = prefs.getString('lastname')!;
    store = prefs.getString('storename')!;
    setState(() {});
  }
}
