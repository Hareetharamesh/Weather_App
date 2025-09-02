import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherApp(),
  ));
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? weatherData;
  String cityName = "Chennai";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      final data = await _weatherService.getWeather(cityName);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      showSnack("City not found!");
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              
              const SizedBox(height: 10),
              const Text("Weather App",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),

              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter city in India",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          cityName = _controller.text.trim();
                          fetchWeather();
                        });
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              weatherData == null
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: Column(
                        children: [
                          Text(cityName.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.thermostat, size: 28),
                              const SizedBox(width: 5),
                              Text(
                                "${weatherData!['main']['temp']}°C",
                                style: const TextStyle(fontSize: 32),
                              ),
                            ],
                          ),
                          Text(weatherData!['weather'][0]['description']
                              .toString()),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildInfoCard(Icons.water_drop, "Humidity",
                                  "${weatherData!['main']['humidity']}%"),
                              buildInfoCard(Icons.air, "Wind",
                                  "${weatherData!['wind']['speed']} m/s"),
                              buildInfoCard(Icons.thermostat_outlined,
                                  "Max Temp", "${weatherData!['main']['temp_max']}°C"),
                            ],
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
