import 'package:flutter/material.dart';
import 'services/weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  final WeatherService weatherService = WeatherService();
  TextEditingController cityController = TextEditingController();
  String city = "Accra";
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late AnimationController _windController;
  late Animation<double> _windRotationAnimation;
  late AnimationController _lightningController;
  late Animation<Color?> _lightningAnimation;
  late AnimationController _humidityController;
  late Animation<double> _humidityAnimation;

  @override
  void initState() {
    super.initState();
    getWeather();

    // themometer color chnage animator
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller);

    // rotating wind animator
    _windController = AnimationController(vsync: this, duration: Duration(seconds: 4))..repeat();
    _windRotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1416).animate(_windController);

    // Lightning Effect Animation
    _lightningController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Fast flash effect
    )..repeat(reverse: true);

    _lightningAnimation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.yellowAccent, // Flash effect
    ).animate(_lightningController);

    _humidityController = AnimationController(
        vsync: this, duration: Duration(seconds: 1)
    )..repeat(reverse: true);

    _humidityAnimation = Tween<double>(begin: 0, end: 10
    ).animate(_humidityController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _windController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  void getWeather() async {
    setState(() => isLoading = true);
    final data = await weatherService.getWeatherByCity(city);
    print("Weather data for $city: $data");

    setState(() {
      weatherData = data;
      isLoading = false;
      _updateTemperatureColor();
    });
  }

  void getWeatherByLocation() async {
    setState(() => isLoading = true);
    final data = await weatherService.getWeatherByLocation();
    print("Weather data by location: $data");
    setState(() {
      weatherData = data ?? {};
      isLoading = false;
      _updateTemperatureColor();
    });
  }

  void _updateTemperatureColor() {
    if (weatherData != null && weatherData!['temperature'] != null) {
      double temp = double.tryParse(weatherData!['temperature'].toString()) ?? 0;
      if (temp < 15) {
        _controller.animateTo(0.0);
      } else if (temp < 30) {
        _controller.animateTo(0.5);
      } else {
        _controller.animateTo(1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud, color: Colors.blueGrey, size: 40),
              SizedBox(width: 8),
              Text("Weather App",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Pacifico',
                      color: Colors.black)),
            ],
          ),
          backgroundColor: Colors.cyan[600],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircularProgressIndicator(),
                ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: "Enter city name",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        city = cityController.text;
                      });
                      getWeather();
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              if (!isLoading && weatherData != null)
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _weatherInfo(Icons.location_city, "City", weatherData?['city'] ?? "Unknown"),
                      AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return _weatherInfo(Icons.thermostat, "Temperature", "${weatherData?['temperature'] ?? "N/A"}°C", iconColor: _colorAnimation.value);
                        },
                      ),
                      AnimatedBuilder(
                        animation: _windRotationAnimation,
                        builder: (context, child) {
                          return _weatherInfo(
                            Icons.wind_power,
                            "Wind Speed",
                            "${weatherData?['wind_speed'] ?? "N/A"} m/s",
                            iconTransform: Transform.rotate(
                              angle: _windRotationAnimation.value,
                              child: Icon(Icons.wind_power, size: 40, color: Colors.blueGrey),
                            ),
                          );
                        },
                      ),
                    AnimatedBuilder(
                      animation: _lightningAnimation,
                      builder: (context, child) {
                        return _weatherInfo(
                          Icons.cloud,
                          "Condition",
                          weatherData?['description'] ?? "N/A",
                          iconColor: _lightningAnimation.value, // Use the animated color
                        );
                      },
                    ),
                      _weatherInfo(Icons.water_drop, "Humidity", "${weatherData?['humidity'] ?? "N/A"}%"),
                    ],
                  ),
                ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 60),
                child: ElevatedButton(
                  onPressed: getWeatherByLocation,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue.withOpacity(0.4);
                        }
                        return Colors.cyan[600];
                      },
                    ),
                  ),
                  child: Text("Get Weather of Current Location",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherInfo(IconData icon, String label, String value, {Color? iconColor, Widget? iconTransform}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconTransform ?? Icon(icon, size: 40, color: iconColor ?? Colors.blueGrey),
          SizedBox(width: 10),
          Text("$label: $value",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
