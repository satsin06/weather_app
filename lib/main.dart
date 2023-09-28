import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/firebase_options.dart';
import 'package:weather_app/shared/constants/string.dart';
import 'package:weather_app/views/home_screen.dart';

import 'views/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: FutureBuilder<bool>(
        future: checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == false) {
            showNoInternetToast();
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Please check your internet connection!!"),
                      TextButton(
                          onPressed: () => exit(0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Close App"),
                              )))
                    ],
                  ),
                ),
              ),
            ); // Replace with your error UI if needed
          } else {
            return const MyApp();
          }
        },
      ),
    ),
  );
}

void showNoInternetToast() {
  Fluttertoast.showToast(
    msg: 'No internet connection',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
  );
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? const HomePage()
            : const SignInPage(title: 'Weather App'));
  }
}
