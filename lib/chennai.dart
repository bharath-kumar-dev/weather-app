// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;


// class First extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => FirstState();
// }

// class FirstState extends State<First> {
  
//   Future fetchdata() async {
//     final receivedData = await http.get(
//       Uri.parse(
//         'https://api.tomorrow.io/v4/weather/forecast?location=chennai&apikey=tBIfg0WuqDjNrhZyAQymg3xrb4IkxUDk',
//       ),
//     );
//     if (receivedData.statusCode == 200) {
//       return json.decode(receivedData.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Forecast Weather response',
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: FutureBuilder(
//         future: fetchdata(),
//         builder: (context, Snapshot) {
//           if (Snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (Snapshot.hasError) {
//             return Text('Error:${Snapshot.error}');
//           } else {
//             Map a = Snapshot.data as Map;
//             List b = a['timelines']['minutely'] as List;
//             return Card(
//               child: ListView.builder(
//                 itemCount: b.length,
//                 itemBuilder: (context, i) {
//                   return ListTile(
//                     title: Text('Time:${b[i]['time']}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return WeatherData(c: b[i]);
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class WeatherData extends StatelessWidget {
//   final Map c;
//   WeatherData({required this.c});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.center,
//         children: [Container(padding: EdgeInsets.all(5),
//           color: Colors.grey,
//           child: Text('CHENNAI WEATHER', style: TextStyle(
//                   foreground: Paint()..color = Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 23,
//                   // color: Colors.black12,
//                 ),),
//         ),SizedBox(height: 20,),
//           Card(
//           color: Colors.orange,
//             child: Text(
//               'Humidity: ${c['values']['humidity']}',
//               style: TextStyle(
//                 foreground: Paint()..color = Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 23,
//                 // color: Colors.black12,
//               ),
//             ),
//           ),Card(
//           color: Colors.red,
//             child: Text(
//               'Temperature: ${c['values']['temperature']}',
//               style: TextStyle(
//                 foreground: Paint()..color = Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 23,
//                 // color: Colors.black12,
//               ),
//             ),
//           ),Card(
//           color: Colors.green,
//             child: Text(
//               'Wind speed: ${c['values']['windSpeed']}',
//               style: TextStyle(
//                 foreground: Paint()..color = Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 23,
//                 // color: Colors.black12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }