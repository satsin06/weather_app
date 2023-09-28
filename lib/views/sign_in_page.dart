import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/shared/constants/string.dart';
import 'package:weather_app/views/home_screen.dart';

import '../shared/constants/constant_function.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false; // Track whether OTP has been sent
  FirebaseAuth auth = FirebaseAuth.instance;
  bool processing = false;
  String _verificationId = "";
  bool isTenDigits = true;
  bool otpError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth! * 0.05),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to the weather app\nPlease Sign In to continue:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              TextFormField(
                enabled: !processing,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number with country code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    value.length == 10
                        ? FocusScope.of(context).unfocus()
                        : null;
                    isTenDigits = true;
                    processing = false;
                  });
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    int phoneLength = phoneController.text.length;
                    phoneLength != 10
                        ? isTenDigits = false
                        : isTenDigits = true;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              if (otpSent)
                TextFormField(
                  enabled: !processing,
                  controller: otpController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    return null;
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  if (otpSent) {
                    // Perform OTP verification logic here
                    if (_globalKey.currentState!.validate()) {
                      if (processing) {
                        null;
                      } else if (otpSent) {
                        otpSent = true;
                        processing == true ? null : verifyOTP();
                        // verifyOTP();
                      } else if (phoneController.text.length != 10) {
                        setState(() {
                          isTenDigits = false;
                        });
                      }
                      // OTP verification is successful
                      // You can add your logic here to verify the OTP
                      // If OTP is correct, you can proceed with further actions.
                      // If OTP is incorrect, show an error message.
                    }
                  } else {
                    // Send OTP logic here (e.g., send OTP to the entered phone number)
                    if (_globalKey.currentState!.validate()) {
                      // OTP has been sent successfully
                      phoneSignIn(phoneNumber: phoneController.text);
                      // setState(() {

                      // });
                    }
                  }
                },
                child: processing == true ? const CircularProgressIndicator() : Text(otpSent ? 'Verify OTP' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOTP() async {
    String code = otpController.text.trim();
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    auth.signInWithCredential(credential).then(
      (value) async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Processing...')),
        // );
        afterVerification();
      },
    ).catchError((error) {
      setState(() {
        processing = false;
        otpError = true;
      });
      setSnackbar("Wrong OTP", context);
    });
  }

  void phoneSignIn({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 10),
        phoneNumber: "+91$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("Auto Reading");
          setState(() {
            processing = true;
            otpSent = true;
          });
          await auth.signInWithCredential(credential);
          // After verification do something
        },
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  afterVerification() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    setSnackbar("Error : ${exception.message}", context,
        color: Colors.red, duration: const Duration(seconds: 8));
    setState(() {
      processing = false;
    });
    if (exception.code == 'invalid-phone-number') {
      // showMessage("The phone number entered is invalid!");
      setState(() {
        otpSent = false;
        isTenDigits = false;
        processing = false;
      });
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) async {
    _verificationId = verificationId;
    if (mounted) {
      setState(() {
        _verificationId = verificationId;
      });
      setState(() {
        otpSent = true;
        processing = false;
      });
    }
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return timeout;
  }
}
