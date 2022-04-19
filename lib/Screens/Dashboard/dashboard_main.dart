import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Screens/Products/manage_products.dart';
import 'package:reddywines/Screens/Purchase/manage_purchase.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_navigation/side_navigation.dart';

import '../../Methods/auth.dart';
import '../Auth/login_screen.dart';
import '../Expenses/manage_expenses.dart';
import '../Inventory/manage_inventory.dart';
import '../Sales/manage_sales.dart';
import '../Settings/settings.dart';
import '../Staff/manage_staff.dart';
import '../StoreScreens/manage_expenses_store.dart';
import '../StoreScreens/manage_inventory_store.dart';
import '../StoreScreens/manage_purchase_store.dart';
import '../StoreScreens/manage_sales_store.dart';
import '../Stores/manage_stores.dart';
import 'Dashboard.dart';
import 'dashboard_inner.dart';
class Dashboard_Main extends StatefulWidget {
  const Dashboard_Main({Key? key}) : super(key: key);
  static const String route = '/Dashboard';

  @override
  _Dashboard_MainState createState() => _Dashboard_MainState();
}

class _Dashboard_MainState extends State<Dashboard_Main> {

  int selectedIndex = 0;
  bool isloaded = false;
  List views = [];
  List<SideNavigationBarItem> navbarlist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  final AuthMethod authmethod= AuthMethod();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: isloaded?Row(
        children: [
          ScreenTypeLayout(
            mobile:SideNavigationBar(
              expandable: true,
              initiallyExpanded: false,
              header: SideNavigationBarHeader(subtitle: Text('Inventory',style: TextStyle(color: Colors.white)), title: Text('Reddy Wines',style: TextStyle(color: Colors.white),), image: Image.asset('assets/images/logo.png',height: 50,width: 50,)),
              footer: SideNavigationBarFooter(label: Text("Copyright © 2022 Reddy Wines",style: TextStyle(color: Colors.white,fontSize: 11),),),
              selectedIndex: selectedIndex,
              theme: const SideNavigationBarTheme(
                showFooterDivider: true,
                showHeaderDivider: true,
                itemTheme: ItemTheme(
                    selectedItemColor: rdcolors.secondarycolor,
                    unselectedItemColor: Colors.white
                ),
                backgroundColor: rdcolors.primarycolor,
                showMainDivider: true,
                togglerTheme: TogglerTheme(
                    expandIconColor:Colors.white,
                    shrinkIconColor: Colors.white
                ),
              ),
              items: navbarlist,
              onTap: (index) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(prefs.getString('role')=='admin'){
                  if(index==10){
                    Future<bool> res = authmethod.logout();
                    res.then((value) {
                      if(value==true){
                        Navigator.of(context).pushNamed(Login.route);
                      }
                    });
                  }else{
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                }
                if(prefs.getString('role')=='Manager'||prefs.getString('role')=='Sales Manager'){
                  if(index==5){
                    Future<bool> res = authmethod.logout();
                    res.then((value) {
                      if(value==true){
                        Navigator.of(context).pushNamed(Login.route);
                      }
                    });
                  }else{
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                }
              },
            ),
            desktop: SideNavigationBar(
              expandable: true,
              initiallyExpanded: true,
              header: SideNavigationBarHeader(subtitle: Text('Inventory',style: TextStyle(color: Colors.white)), title: Text('Reddy Wines',style: TextStyle(color: Colors.white),), image: Image.asset('assets/images/logo.png',height: 50,width: 50,)),
              footer: SideNavigationBarFooter(label: Text("Copyright © 2022 Reddy Wines",style: TextStyle(color: Colors.white,fontSize: 11),),),
              selectedIndex: selectedIndex,
              theme: const SideNavigationBarTheme(
                showFooterDivider: true,
                showHeaderDivider: true,
                itemTheme: ItemTheme(
                    selectedItemColor: rdcolors.secondarycolor,
                    unselectedItemColor: Colors.white
                ),
                backgroundColor: rdcolors.primarycolor,
                showMainDivider: true,
                togglerTheme: TogglerTheme(
                    expandIconColor:Colors.white,
                    shrinkIconColor: Colors.white
                ),
              ),
              items: navbarlist,
              onTap: (index) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(prefs.getString('role')=='admin'){
                  if(index==10){
                    Future<bool> res = authmethod.logout();
                    res.then((value) {
                      if(value==true){
                        Navigator.of(context).pushNamed(Login.route);
                      }
                    });
                  }else{
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                }
                if(prefs.getString('role')=='Manager'||prefs.getString('role')=='Sales Manager'){
                  if(index==5){
                    Future<bool> res = authmethod.logout();
                    res.then((value) {
                      if(value==true){
                        Navigator.of(context).pushNamed(Login.route);
                      }
                    });
                  }else{
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                }
              },
            ),
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ):const Center(
        child: CircularProgressIndicator(),
      )
    );
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('role')=='admin'){
      views = [
        Dashboard(),
        Dashboard_inner(),
        Manage_Purchase(),
        Manage_Inventory(),
        Manage_Sales(),
        Manage_Stores(),
        Manage_Staff(),
        Manage_Products(),
        Manage_Expenses(),
        Settings(),
      ];
      navbarlist=[
        SideNavigationBarItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
        ),
        SideNavigationBarItem(
          icon: Icons.bar_chart_rounded,
          label: 'Reports',
        ),
        SideNavigationBarItem(
          icon: Icons.production_quantity_limits,
          label: 'Manage Purchase',
        ),
        SideNavigationBarItem(
          icon: Icons.inventory,
          label: 'Manage Inventory',
        ),
        SideNavigationBarItem(
          icon: Icons.point_of_sale,
          label: 'Manage Sales',
        ),
        SideNavigationBarItem(
          icon: Icons.shopping_bag_rounded,
          label: 'Manage Stores',
        ),
        SideNavigationBarItem(
          icon: Icons.supervised_user_circle,
          label: 'Manage Users',
        ),
        SideNavigationBarItem(
          icon: Icons.stacked_bar_chart_outlined,
          label: 'Manage Products',
        ),
        SideNavigationBarItem(
          icon: Icons.bar_chart_rounded,
          label: 'Expenses',
        ),
        SideNavigationBarItem(
          icon: Icons.settings,
          label: 'Settings',
        ),
        SideNavigationBarItem(
          icon: Icons.logout,
          label: 'Logout',
        ),
      ];
      setState(() {
        isloaded =true;
      });
    }
    if(prefs.getString('role')=='Manager'){

      views = [
        Dashboard_inner(),
        Manage_Purchase(),
        Manage_Inventory(),
        Manage_Sales(),
        Manage_Expenses(),
      ];

      navbarlist=[
        SideNavigationBarItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
        ),
        SideNavigationBarItem(
          icon: Icons.production_quantity_limits,
          label: 'Manage Purchase',
        ),
        SideNavigationBarItem(
          icon: Icons.inventory,
          label: 'Manage Inventory',
        ),
        SideNavigationBarItem(
          icon: Icons.point_of_sale,
          label: 'Manage Sales',
        ),
        SideNavigationBarItem(
          icon: Icons.bar_chart_rounded,
          label: 'Expenses',
        ),
        SideNavigationBarItem(
          icon: Icons.logout,
          label: 'Logout',
        ),
      ];

      setState(() {
        isloaded =true;
      });
    }



    if(prefs.getString('role')=='Sales Manager'){

      views = [
        Manage_Sales_Store(),
        // Dashboard_inner(),
        Manage_Purchase_Store(),
        Manage_Inventory_Store(),
        Manage_Sales_Store(),
        Manage_Expenses_Store(),
      ];

      navbarlist=[
        SideNavigationBarItem(
          icon: Icons.point_of_sale,
          label: 'Manage Sales',
        ),
        // SideNavigationBarItem(
        //   icon: Icons.dashboard,
        //   label: 'Dashboard',
        // ),
        SideNavigationBarItem(
          icon: Icons.production_quantity_limits,
          label: 'Manage Purchase',
        ),
        SideNavigationBarItem(
          icon: Icons.inventory,
          label: 'Manage Inventory',
        ),
        SideNavigationBarItem(
          icon: Icons.point_of_sale,
          label: 'Manage Sales',
        ),
        SideNavigationBarItem(
          icon: Icons.bar_chart_rounded,
          label: 'Expenses',
        ),
        SideNavigationBarItem(
          icon: Icons.logout,
          label: 'Logout',
        ),
      ];
      setState(() {
        isloaded =true;
      });
    }

    }
}
