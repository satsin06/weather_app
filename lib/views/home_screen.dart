import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/controller/weather_services.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/shared/constants/string.dart';
import 'package:weather_app/views/sign_in_page.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    await _auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const SignInPage(
                  title: "Weather App",
                )),
        (route) => false));
  }

  TextEditingController cityController = TextEditingController();

  // Get device location

  Location location = Location();

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Location services are still not enabled; handle accordingly
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Location permission not granted; handle accordingly
        return;
      }
    }

    _locationData = await location.getLocation();
    double latitude = _locationData.latitude!;
    double longitude = _locationData.longitude!;

    // Now you have the latitude and longitude; proceed with reverse geocoding to get the city name
  }

  String cityName = "Pune";

  @override
  Widget build(BuildContext context) {
    // final weatherData = WeatherService().getWeatherData('Pune');
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weather App"),
          actions: [
            IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextFormField(
                  controller:
                      cityController, // You can manage the controller as needed
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // onChanged: (value) {
                  //   // You can update the city name in your request here
                  //   setState(() {
                  //     cityName = value;
                  //   });
                  // },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    cityController.text.isEmpty
                        ? cityController.text = "Pune"
                        : cityController.text;
                    setState(() {
                      cityName = cityController.text;
                      cityController.clear();
                    });
                  }),
            ),
            FutureBuilder<Weather>(
              future: WeatherService().getWeatherData(cityName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Display a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  final error = snapshot.error.toString();
                  if (error.contains(
                      'Bad API Request: Invalid location parameter value')) {
                    return Column(
                      children: [
                        const Text(
                            'Invalid city name. Please try a different city name.'),
                        ElevatedButton(
                          onPressed: () {
                            // You can add logic here to reset the input field or take other actions.
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    );
                  } else {
                    return Text('Error: $error');
                  }
                } else if (!snapshot.hasData) {
                  return const Text('No data available');
                } else {
                  final weatherData = snapshot.data!;

                  return Column(
                    children: [
                      Text(
                        '${weatherData.currentConditions!.temp}°C',
                        style: const TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weatherData.resolvedAddress.toString(),
                        style: const TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.overline),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: deviceWidth! * 0.8,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '${weatherData.description}',
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Data and time

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       '${weatherData.currentConditions!.datetime}',
                      //       style: const TextStyle(
                      //           fontSize: 18.0, fontWeight: FontWeight.w400),
                      //     ),
                      //     const VerticalDivider(),
                      //     Text(
                      //       weatherData.days![0].datetime.toString(),
                      //       style: const TextStyle(
                      //           fontSize: 18.0, fontWeight: FontWeight.w400),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Min Temp.: ${weatherData.days![0].tempmin}",
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.w400)),
                          Text("Max Temp.: ${weatherData.days![0].tempmax}",
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      // const Divider(
                      //   thickness: 2,
                      //   color: Colors.black,
                      // ),
                      Container(child: Text("7 Days Forecast")),
                      Container(
                        height: deviceHeight! * 0.4,
                        width: deviceWidth! * 0.8,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.days![index + 1];
                              return ListTile(
                                title: Text(data.datetime.toString()),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Min Temp.: ${data.tempmin}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400)),
                                    Text("Max Temp.: ${data.tempmax}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  );
                }
              },
            ),
          ],
        ));
  }
}
