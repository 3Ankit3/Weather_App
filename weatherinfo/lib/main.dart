import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}
// Define a stateless widget representing the entire app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //This line removes the "Debug" banner that appears on the top right corner of the app while in debug mode. It's helpful when presenting or publishing the app.
      title: 'Weather App', //Sets the title of the app.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

// Define a stateful widget representing the main weather screen
class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

// Define the state for the WeatherScreen widget
class _WeatherScreenState extends State<WeatherScreen> {
  // Declare necessary variables to manage weather data and user input
  String apiKey = '11948d87abc56439353810457bae2b31'; // Replace with your OpenWeatherMap API key
  String city = 'London'; // Default city for weather information display
  String weatherInfo = ''; // Variable to hold weather information fetched from the API
  TextEditingController cityController = TextEditingController(); // Controller for the city input TextField

  // Function to determine the background image based on weather description
  String getBackgroundImage(String weatherDescription) {

    if (weatherDescription.toLowerCase().contains('clear')) {
      return 'assets/clear.jpg';
    } else if (weatherDescription.toLowerCase().contains('rain')) {
      return 'assets/rain.jpeg';
    } else if (weatherDescription.toLowerCase().contains('cloud')) {
      return 'assets/cloudy.jpeg';
    } else if (weatherDescription.toLowerCase().contains('fog')) {
      return 'assets/fog.jpeg';
    }
    return 'assets/sky.jpeg';
  }

  // Function to fetch weather data from the OpenWeatherMap API
  Future<void> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        // Update weatherInfo with fetched temperature and description
        weatherInfo = 'Temperature: ${jsonResponse['main']['temp']}°C\n'
            'Description: ${jsonResponse['weather'][0]['description']}';
      });
    } else {
      setState(() {
        // Display error message if the city does not exist
        weatherInfo = 'City does not exist';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch weather data for the default city when the widget is initialized
    fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Display a background image based on weather conditions
          Image.asset(
            getBackgroundImage(weatherInfo),
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5), // Add SizedBox to lift the container up
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: cityController,
                          decoration: InputDecoration(

                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              city = cityController.text;
                              fetchWeather(city);
                            });
                          },
                          child: Text('Search Weather'),
                        ),
                        SizedBox(height: 20),
                        weatherInfo.isEmpty
                            ? CircularProgressIndicator()
                            : Text(
                          weatherInfo,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}