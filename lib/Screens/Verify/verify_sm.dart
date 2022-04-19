import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:reddywines/Methods/manage_otp_verifiers.dart';
import 'package:reddywines/Utils/rdcolors.dart';
import 'package:http/http.dart' as http;
import '../Dashboard/dashboard_main.dart';

class VerifySM extends StatefulWidget {
  const VerifySM({Key? key}) : super(key: key);
  static const String route = '/VerifySM';

  @override
  _VerifySMState createState() => _VerifySMState();
}

class _VerifySMState extends State<VerifySM> {
  List<otpverifiers> otpverifierslist = [];
  OtpFieldController otpController = OtpFieldController();

  bool isotpsent = false;
  Random random = new Random();
  int otp = 0;
  String enteredotp ='';
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    otp = random.nextInt(9999); // from 0 upto 99 included
    print(otp);
  }
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: rdcolors.primarycolor,
      body: Container(
        margin: EdgeInsets.all(15),
        width: screensize.width,
        child: Column(
          children: [
            Text('Reddy Wines',style: TextStyle(fontSize: 25,color: Colors.white),),
            Text('Select a verifier for authorization',style: TextStyle(fontSize: 20,color: Colors.white),),
            SizedBox(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for(int i = 0;i<otpverifierslist.length;i++)
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
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
                          Text('Title : '+otpverifierslist[i].title,style: TextStyle(fontSize: 18,color: Colors.white),),
                          Text('Email : '+otpverifierslist[i].email,style: TextStyle(fontSize: 18,color: Colors.white),),
                          Text('Phone : '+otpverifierslist[i].phone,style: TextStyle(fontSize: 18,color: Colors.white),),
                          SizedBox(height: 8,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: rdcolors.secondarycolor,
                            ),
                            onPressed: () async {
                              await sendotptomail(otpverifierslist[i].email);
                              ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                                content: Text('Otp Sent successfully'),
                              ));
                              setState(() {
                                isotpsent = true;
                              });
                            },
                            child: const Text('Send OTP to mail'),
                          ),
                          SizedBox(height: 8,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: rdcolors.secondarycolor
                            ),
                            onPressed: () async {
                              await sendotptophone(otpverifierslist[i].phone);
                              ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                                content: Text('Otp Sent successfully'),
                              ));
                              setState(() {
                                isotpsent = true;
                              });
                            },
                            child: const Text('Add OTP to phone'),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            SizedBox(height: 20,),
            isotpsent?Container(
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
            ):Container()
          ],
        ),
      ),
    );
  }


  init() async {
    otpverifierslist = await manage_otp_verifiers().getallverifiers();
    setState(() {});
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

  sendotptophone(String phone) async {
    var url = Uri.parse('https://2factor.in/API/V1/88d6d6b3-8bc0-11ec-b9b5-0200cd936042/SMS/+91'+phone+'/'+otp.toString());
    var response = await http.post(url);
    return true;
  }
}
