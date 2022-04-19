import 'package:cloud_firestore/cloud_firestore.dart';

class dbpaths{
  static final userpath = FirebaseFirestore.instance.collection('Users');
  static final storepath = FirebaseFirestore.instance.collection('Store');
  static final productspath = FirebaseFirestore.instance.collection('Products');
  static final purchasepath = FirebaseFirestore.instance.collection('Purchases');
  static final inventorypath = FirebaseFirestore.instance.collection('Inventory');
  static final salespath = FirebaseFirestore.instance.collection('Sales');
  static final otpverifiers = FirebaseFirestore.instance.collection('OtpVerifiers');
  static final expences = FirebaseFirestore.instance.collection('Expences');
}