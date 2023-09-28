import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherService {
  String apiKey = "7JWQMV9WC5JJBUQF22L83ERCB";
  Future<Weather> getWeatherData(String cityName) async {
    final url =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityName?unitGroup=metric&key=$apiKey&contentType=json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final welcome = Weather.fromJson(jsonMap);
      return welcome;
    } else {
    final errorMessage = response.body;
    print(errorMessage);
    throw Exception(errorMessage);
    }
  }
}
