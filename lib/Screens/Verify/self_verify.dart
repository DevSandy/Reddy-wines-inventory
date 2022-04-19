import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Auth/login_screen.dart';
import '../Dashboard/dashboard_main.dart';
class Selfverify extends StatefulWidget {
  const Selfverify({Key? key}) : super(key: key);
  static const String route = '/Selfverify';

  @override
  _SelfverifyState createState() => _SelfverifyState();
}

class _SelfverifyState extends State<Selfverify> {
  OtpFieldController otpController = OtpFieldController();
  Random random = new Random();
  int otp = 0;
  String enteredotp ='';
  String phone = '';
  String username = '';
  @override
  void initState() {
    // TODO: implement initState
    otp = random.nextInt(9999)+1000;
    print(otp);
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('OTP Sent To : '+phone,style: TextStyle(fontSize: 22,color: Colors.white),),
            Container(
              width: screensize.width,
              child: Center(
                child: Column(
                  children: [
                    const Text('Please enter the otp below',style: TextStyle(color: Colors.white,fontSize: 22),),
                    SizedBox(height: 20,),
                    OTPTextField(
                        controller: otpController,
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 55,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        otpFieldStyle: OtpFieldStyle(borderColor: Colors.white,disabledBorderColor: Colors.white,enabledBorderColor: Colors.white),
                        style: TextStyle(fontSize: 17,color: Colors.white),
                        onChanged: (pin) {
                          enteredotp = pin;
                          print("Changed: " + pin);
                        },
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                        }),
                    SizedBox(height: 40,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          minimumSize: screensize/7,
                          primary: rdcolors.secondarycolor
                      ),
                      onPressed: () async {
                        print(enteredotp);
                        if(enteredotp==otp.toString()){
                          Navigator.of(context).pushNamed(Dashboard_Main.route);
                        }
                        if(enteredotp!=otp.toString()){
                          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                            content: Text('Invalid Otp'),
                          ));
                        }
                      },
                      child: const Text('Submit'),
                    ),


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone')!;
      username = prefs.getString('username')!;
    });
    dialogotpchoice(phone,username);
    // await sendotptophone(phone);
  }
  sendotptophone(String phone) async {
    print('started');
    print(phone);
    print(otp);
    var url = Uri.parse('https://2factor.in/API/V1/88d6d6b3-8bc0-11ec-b9b5-0200cd936042/SMS/+91'+phone+'/'+otp.toString());
    var response = await http.post(url);
    print(response.statusCode);
    return true;
  }

  sendotptomail(String email) async {
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
            {
              'service_id':'service_7eqv3fu',
              'template_id':'template_muzq4po',
              'user_id':'user_XOU3KA9YtFdNNkvhAmFrz',
              'template_params': {
                'user_message': otp.toString(),
                'email_to':email
              }
            }
        )
    );

  }

  dialogotpchoice(String phone, String username) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Where whould you like to recive otp ?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Phone $phone'),
                  Text('Email $username'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(Login.route);
                },
              ),
              TextButton(
                child: const Text('Email'),
                onPressed: () async {
                  await sendotptomail(username);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Phone'),
                onPressed: () async {
                  await sendotptophone(phone);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

}
