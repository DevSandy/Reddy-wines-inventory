import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:reddywines/Methods/manage_product.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:reddywines/Widgets/Header.dart';

import '../../Methods/manage_store.dart';
import '../../Widgets/dialog_delete_product.dart';
import '../Stores/manage_stores.dart';

class Manage_Products extends StatefulWidget {
  const Manage_Products({Key? key}) : super(key: key);

  @override
  _Manage_ProductsState createState() => _Manage_ProductsState();
}

class _Manage_ProductsState extends State<Manage_Products> {
  ScrollController _scrollController = new ScrollController();


  List<ProductModel> products = [];
  List<ProductModel> productsFiltered = [];

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  String _searchResult = '';


  String _searchResult2 = '';
  List<Store> storesFiltered = [];
  List<Store> stores = [];



  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  int? tag;
  String selectedstore = '';

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
                  margin: EdgeInsets.only(top:8),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller2,
                          decoration: const InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult2 = value;
                              storesFiltered = stores
                                  .where((storef) =>
                              storef.name.contains(_searchResult2) ||
                                  storef.id.contains(_searchResult2) ||
                                  storef.address.contains(_searchResult2)
                              )
                                  .toList();
                            });
                          }),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            _searchResult2 = '';
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
                            selectedstore ='';
                          });
                          products = await manage_product().getproducts(storesFiltered[val].id);
                          productsFiltered = products;
                          await Future.delayed(Duration(milliseconds: 500));
                          setState(() {
                            tag = val;
                            selectedstore = storesFiltered[val].id;
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
                selectedstore!=''?Column(
                  children: [
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
                                Text("All Products",style: TextStyle(color: Colors.white,fontSize: 18),),
                                Spacer(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        primary: rdcolors.secondarycolor
                                    ),
                                    onPressed: () async {
                                      await showMyDialog(context);
                                      products = await manage_product().getproducts(selectedstore);
                                      productsFiltered = products;
                                      await init();
                                      // await init();
                                    },
                                    child: Text('Add Product')
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
                                    _searchResult = value.toUpperCase();
                                    productsFiltered = products
                                        .where((products) =>
                                    products.name.contains(_searchResult) ||
                                        products.qtyincase.contains(_searchResult) ||
                                        products.category.contains(_searchResult))
                                        .toList();
                                  });
                                }),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  _searchResult = '';
                                  productsFiltered = products;
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
                                    'Name',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Qty in case',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Selling Price',
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
                                productsFiltered.length,
                                    (index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Center(child: Text(productsFiltered[index].name,style: TextStyle(color: Colors.white),))),
                                    DataCell(Center(child: Text(productsFiltered[index].qtyincase,style: TextStyle(color: Colors.white),))),
                                    DataCell(Center(child: Text(productsFiltered[index].sellingprice.toString(),style: TextStyle(color: Colors.white),))),
                                    DataCell(Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary: rdcolors.secondarycolor
                                        ),
                                        onPressed: () async {
                                          print(productsFiltered[index].key);
                                          await showMyDialog2(context,productsFiltered[index]);
                                          products = await manage_product().getproducts(selectedstore);
                                          productsFiltered = products;
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
                                          await dialog_delete_product().showMyDialog(context, productsFiltered[index]);
                                          products = await manage_product().getproducts(selectedstore);
                                          productsFiltered = products;
                                          await init();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ):Container()
              ],
            ),
          ),
        )
    );
  }

  showMyDialog(BuildContext context) {
    String selectedcategory = 'Choose Category';
    TextEditingController pname = TextEditingController();
    TextEditingController pqtyincase = TextEditingController();
    TextEditingController psellingprice = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add new product'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('Fill in the form below.'),
                    TextField(
                      controller: pname,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Product Name',
                          hintText: 'Enter Product Name'
                      ),
                    ),
                    TextField(
                      controller: pqtyincase,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Qty/Case',
                          hintText: 'Enter qty per case'
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: psellingprice,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Selling Price(per bottle)',
                          hintText: 'Enter selling price'
                      ),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedcategory,
                      items: <String>[
                        'Choose Category',
                        'BRANDY',
                        'WHISKEY',
                        'RUM',
                        'GIN',
                        'WINE',
                        'VODKA',
                        'BEER'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedcategory = value!;
                          print(value);
                        });
                      },
                    ),
                  ],
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
                  child: const Text('Submit'),
                  onPressed: () async {
                    bool res = await manage_product().addproduct(pname.text,pqtyincase.text,psellingprice.text,selectedcategory,selectedstore);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }




  showMyDialog2(BuildContext context, ProductModel productsFiltered) {
    String selectedcategory = productsFiltered.category;
    TextEditingController pname = TextEditingController();
    TextEditingController pqtyincase = TextEditingController();
    TextEditingController psellingprice = TextEditingController();
    pname.text = productsFiltered.name;
    pqtyincase.text = productsFiltered.qtyincase;
    psellingprice.text = productsFiltered.sellingprice;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Add new product'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Text('Fill in the form below.'),
                      TextField(
                        controller: pname,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Product Name',
                            hintText: 'Enter Product Name'
                        ),
                      ),
                      TextField(
                        controller: pqtyincase,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Qty/Case',
                            hintText: 'Enter qty per case'
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: psellingprice,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Selling Price(per bottle)',
                            hintText: 'Enter selling price'
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedcategory,
                        items: <String>[
                          'Choose Category',
                          'WHISKEY',
                          'RUM',
                          'BEER',
                          'SKOTCH',
                          'SKOTCH WHISKEY',
                          'VODKA'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedcategory = value!;
                            print(value);
                          });
                        },
                      ),
                    ],
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
                    child: const Text('Submit'),
                    onPressed: () async {
                      bool res = await manage_product().updateproduct(pname.text,pqtyincase.text,psellingprice.text,selectedcategory,productsFiltered.key,selectedstore);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }



  Future<void> init() async {
    stores = await managestore().getstores();
    storesFiltered = stores;
    setState(() {});
  }
}


class ProductModel {
  String category;
  String name;
  String qtyincase;
  String sellingprice;
  String key;

  ProductModel({required this.category, required this.name, required this.qtyincase,required this.sellingprice,required this.key});
}
