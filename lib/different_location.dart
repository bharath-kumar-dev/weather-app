import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeatherState();
}

class WeatherState extends State<Weather> {
  final TextEditingController _cityController = TextEditingController();
  String city = 'new york'; // Default city
  Future? _weatherFuture;
  String formatToIST(String utcString) {
    // Parse the UTC time string to DateTime
    DateTime utcDateTime = DateTime.parse(utcString).toUtc();

    // Convert to IST by adding 5 hours 30 minutes
    DateTime istDateTime = utcDateTime.add(
      const Duration(hours: 5, minutes: 30),
    );

    // Format as desired (e.g., 'dd-MM-yyyy HH:mm:ss')
    return 'Time: ${istDateTime.hour}:${istDateTime.minute.toString().padLeft(2, '0')} ';
  }

  String formattoIST(String utcString) {
    // Parse the UTC time string to DateTime
    DateTime utcDateTime = DateTime.parse(utcString).toUtc();

    // Convert to IST by adding 5 hours 30 minutes
    DateTime istDateTime = utcDateTime.add(
      const Duration(hours: 5, minutes: 30),
    );

    // Format as desired (e.g., 'dd-MM-yyyy HH:mm:ss')
    return 'Date: ${istDateTime.day}-${istDateTime.month}-${istDateTime.year}';
  }

  @override
  void initState() {
    super.initState();
    _weatherFuture = fetchdata(city);
  }

  Future fetchdata(String cityName) async {
    final receivedData = await http.get(
      Uri.parse(
        'https://api.tomorrow.io/v4/weather/forecast?location=$cityName&apikey=M9Spd7fbDWddt0sNKwGHAxWTBaoU6j78',
      ),
    );
    if (receivedData.statusCode == 200) {
      return json.decode(receivedData.body);
    } else {
      throw Exception('Failed to load data for $cityName');
    }
  }

  void _searchCity() {
    setState(() {
      city = _cityController.text.trim();
      _weatherFuture = fetchdata(city);
    });
  }

  Future<void> _getCurrentLocationWeather() async {
    try {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await Geolocator.openLocationSettings();
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.deniedForever ||
              permission == LocationPermission.denied) {
                 setState(() {
            city = 'Location permission denied by Geolocator.';
            _cityController.text =city;
          });
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          String currentCity = placemarks[0].locality!;
          setState(() {
            city = currentCity;
            _cityController.text = currentCity;
            _weatherFuture = fetchdata(currentCity);
          });
        }
      }
    } catch (e) {
      Text('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      //  PreferredSize(preferredSize: const Size.fromHeight(50),//height of the AppBar
      //  child:
      AppBar(
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assests/images/appbarimage.jpeg', fit: BoxFit.cover),
          ],
        ),
        title: Text(
          'Forecast Weather',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      //  ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assests/images/body background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Enter City Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        // foregroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _searchCity,
                      child: Text('Search'),
                    ),
                    IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: _getCurrentLocationWeather,
                      tooltip: 'Use Current Location',
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Text(
                  'current city: $city',
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                // color: Colors.grey,
              ),
              FutureBuilder(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return SizedBox();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error fetching date',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    Map a = snapshot.data as Map;
                    List b = a['timelines']['minutely'] as List;
                    String currentDate = formattoIST(b[0]['time']);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        currentDate,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }
                },
              ),

              Expanded(
                child: FutureBuilder(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      Map a = snapshot.data as Map;
                      List b = a['timelines']['minutely'] as List;
                      Text(' DATE:${formattoIST(b[0]['time'])}');

                      return Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          itemCount: b.length,
                          itemBuilder: (context, i) {
                            int index = i * 10;
                            if (index >= b.length) {
                              return SizedBox(); // avoid crash
                            }
                            // Alternate color logic
                            Color tileColor =
                                i % 2 == 0
                                    ? const Color.fromARGB(44, 238, 238, 238)
                                    : const Color.fromARGB(22, 3, 168, 244);

                            return Center(
                              child: Card(
                                color: tileColor,
                                elevation: 4,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${formatToIST(b[index]['time'])}',
                                  ),
                                  leading: CircleAvatar(
                                    child: Icon(Icons.access_time),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return WeatherData(
                                            c: b[i],
                                            cityName: city,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherData extends StatelessWidget {
  final Map c;
  final String cityName;

  WeatherData({required this.c, required this.cityName});

  @override
  Widget build(BuildContext context) {
    // double temp = c['values']['temperature']; // get temperature
    String imagePath =
        c['values']['temperature'] <= 30
            ? 'assests/images/weather.jpeg'
            : 'assests/images/sunny.jpeg';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), //height of the AppBar
        child: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assests/images/backgroundimage.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Forecast Weather',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          // title: Text(
          //   'Forecast Weather',
          //   style: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assests/images/backgroundimage.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   '${cityName.toUpperCase()} WEATHER',
                  //   style: TextStyle(fontStyle: FontStyle.italic),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(210, 0, 0, 0),
                    ),
                    padding: EdgeInsets.all(2),
                    width: 200,

                    // color: Colors.grey,
                    child: Text(
                      '\t${cityName.toUpperCase()}\n ${formatToIST(c['time'])}',
                      style: TextStyle(
                        foreground: Paint()..color = Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Container(
                        // color:const Color.fromARGB(78, 0, 0, 0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assests/images/humidity.jpeg',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Column(
                                children: [
                                  // Text(
                                  //   '${formatToIST(c['time'])}',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 24,
                                  //     fontWeight: FontWeight.bold,
                                  //     backgroundColor: Colors.black54,
                                  //   ),
                                  // ),
                                  Text(
                                    'Humidity:\n ${c['values']['humidity']}%',
                                    style: TextStyle(
                                      foreground: Paint()..color = Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        // color: ,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                imagePath,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                'Temperature:\n ${c['values']['temperature']}°C',
                                style: TextStyle(
                                  foreground: Paint()..color = Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Container(
                      //   child: Padding(
                      //     padding: EdgeInsets.all(10),
                      //     child: Text(
                      //       'Temperature: ${c['values']['temperature']}°C',
                      //       style: TextStyle(
                      //         foreground: Paint()..color = Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 23,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        // color: Colors.white,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assests/images/windspeed.png',
                                width: 118,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                'Wind Speed:\n ${c['values']['windSpeed']} km/h',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  // backgroundColor: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Card(
                      //   color: Colors.green,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(10),
                      //     child: Text(
                      //       'Wind Speed: ${c['values']['windSpeed']} km/h',
                      //       style: TextStyle(
                      //         foreground: Paint()..color = Colors.black,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 23,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formattoIST(String utcString) {
    // Parse the UTC time string to DateTime
    DateTime utcDateTime = DateTime.parse(utcString).toUtc();

    // Convert to IST by adding 5 hours 30 minutes
    DateTime istDateTime = utcDateTime.add(
      const Duration(hours: 5, minutes: 30),
    );

    // Format as desired (e.g., 'dd-MM-yyyy HH:mm:ss')
    return 'Time: ${istDateTime.hour}:${istDateTime.minute.toString()}';
  }

  formatToIST(String utcString) {
    // String formattoIST(String utcString) {
    // Parse the UTC time string to DateTime
    DateTime utcDateTime = DateTime.parse(utcString).toUtc();

    // Convert to IST by adding 5 hours 30 minutes
    DateTime istDateTime = utcDateTime.add(
      const Duration(hours: 5, minutes: 30),
    );

    // Format as desired (e.g., 'dd-MM-yyyy HH:mm:ss')
    return 'Date: ${istDateTime.day}-${istDateTime.month}-${istDateTime.year}';
  }
}
