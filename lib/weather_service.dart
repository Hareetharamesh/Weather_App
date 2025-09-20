import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '978e96db64b9210c22f3e5889f57e44b'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = '$baseUrl?q=$city,in&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

