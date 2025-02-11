import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geobound_mobile/screens/login_screen.dart';
import 'package:geobound_mobile/services/add_record.dart';
import 'package:geobound_mobile/widgets/logout_widget.dart';
import 'package:geobound_mobile/widgets/text_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class PersonnelScreen extends StatefulWidget {
  String id;

  PersonnelScreen({super.key, required this.id});

  @override
  State<PersonnelScreen> createState() => _PersonnelScreenState();
}

class _PersonnelScreenState extends State<PersonnelScreen> {
  final List<LatLng> polygon = [
    const LatLng(8.486484, 124.657151),
    const LatLng(8.486279, 124.657089),
    const LatLng(8.485970, 124.657461),
    const LatLng(8.486062, 124.657685),
    const LatLng(8.486341, 124.657471),
    const LatLng(8.486487, 124.657163),
    const LatLng(8.486484, 124.657151),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();

    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        Geolocator.getCurrentPosition().then((position) {
          FirebaseFirestore.instance.collection('Users').doc(widget.id).update({
            'lat': position.latitude,
            'lng': position.longitude,
          });

          // Point to check
          LatLng pointToCheck = LatLng(position.latitude, position.longitude);

          // Check if the point is inside the polygon
          final bool isInside = isPointInPolygon(pointToCheck, polygon);
          final DateTime now = DateTime.now();

          // Format to get only the AM/PM part
          final String amPm = DateFormat('a').format(now);

          DateTime fivePM = DateTime(now.year, now.month, now.day, 17);

          // Print the result
          if (isInside) {
            addRecord(widget.id, now.isBefore(fivePM) ? 'In' : 'Out', amPm);
            print('The point is inside the polygon!');
          } else {
            print('The point is outside the polygon.');
          }

          setState(() {
            lat = position.latitude;
            lng = position.longitude;
          });
        }).catchError((error) {
          print('Error getting location: $error');
        });
      },
    );
  }

  double lat = 8.480675;
  double lng = 124.660238;

// Function to check if a point is inside a polygon
  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i;
    int j = polygon.length - 1; // Initialize `j` with the last index
    bool isInside = false;

    for (i = 0; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        isInside = !isInside; // Toggle the boolean flag
      }
    }

    return isInside;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextWidget(
          text: 'HOME',
          fontSize: 18,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context, const LoginScreen(), widget.id);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter:
              LatLng(8.486308, 124.657486), // Center the map over London
          initialZoom: 17,
        ),
        children: [
          TileLayer(
            // Display map tiles from any source
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
            userAgentPackageName: 'com.example.app',
            // And many more recommended properties!
          ),
          MarkerLayer(markers: [
            Marker(
              point: LatLng(lat, lng),
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: TextWidget(
                    text: 'ME',
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Bold',
                  ),
                ),
              ),
            ),
          ]),
          PolygonLayer(
            polygons: [
              Polygon(
                  points: [
                    const LatLng(8.486484, 124.657151),
                    const LatLng(8.486279, 124.657089),
                    const LatLng(8.485970, 124.657461),
                    const LatLng(8.486062, 124.657685),
                    const LatLng(8.486341, 124.657471),
                    const LatLng(8.486487, 124.657163),
                    const LatLng(8.486484, 124.657151),
                  ],
                  color: Colors.red.withOpacity(0.2),
                  borderColor: Colors.black,
                  borderStrokeWidth: 2,
                  isFilled: true),
            ],
          ),
        ],
      ),
    );
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
