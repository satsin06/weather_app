import 'package:flutter/material.dart';
import 'package:weather_app/shared/constants/string.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpSent = false; // Track whether OTP has been sent

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
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number with country code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              if (otpSent)
                TextFormField(
                  controller: otpController,
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
                      // OTP verification is successful
                      // You can add your logic here to verify the OTP
                      // If OTP is correct, you can proceed with further actions.
                      // If OTP is incorrect, show an error message.
                    }
                  } else {
                    // Send OTP logic here (e.g., send OTP to the entered phone number)
                    if (_globalKey.currentState!.validate()) {
                      // OTP has been sent successfully
                      setState(() {
                        otpSent = true;
                      });
                    }
                  }
                },
                child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
