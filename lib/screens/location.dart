import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';



class Location extends StatefulWidget {
  static String routeName = '/loc';

  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String locationMessage = 'Current Location of the user';

Future<Position> _currentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
  
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  Position position = await Geolocator.getCurrentPosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0]; 


    setState(() {
      locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}/n '
      'Address: ${place.street}, ${place.postalCode}, ${place.country}';
    });
  return await Geolocator.getCurrentPosition();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
             const Text('Location'),
          ]
      ),
      ),
      body:  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(locationMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:() {
              _currentLocation();
            }, 
            child: const Text('Get current Location'))
      
        ]
      ),)

    );
  }
}