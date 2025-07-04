import 'package:flutter/material.dart';

// import 'package:weather_api_get/different_location.dart';
// import 'package:weather_api_get/main.dart';
import 'package:weather_api_get/different_location.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(preferredSize:  Size.fromHeight(75),
      //   child: AppBar(title: Text('WEATHER API',style: TextStyle(fontSize: 50,fontStyle: FontStyle.italic),),centerTitle: true,backgroundColor: const Color.fromARGB(121, 0, 0, 0),)),
      body: Stack(
        // child: Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   color: Colors.grey,
        // child:
        children: [
          Positioned.fill(
            child: Image.asset('assests/images/Entry.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                // foregroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
               
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Weather();
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center, 
                  children: [Icon(Icons.live_tv),SizedBox(width: 25,)
                    ,Text(
                      'Live weather updates',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          // TextButton(

          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return First();
          //         },
          //       ),
          //     );
          //   },
          //   child: Text('Reference',style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
          // ),
          //
        ],
      ),
    );
    // );
  }
}

