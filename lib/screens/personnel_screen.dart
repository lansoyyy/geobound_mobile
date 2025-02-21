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
    const LatLng(8.482386, 124.660703),
    const LatLng(8.482260, 124.660365),
    const LatLng(8.481648, 124.660055),
    const LatLng(8.481202, 124.659958),
    const LatLng(8.480607, 124.659869),
    const LatLng(8.480215, 124.659576),
    const LatLng(8.479867, 124.659387),
    const LatLng(8.479635, 124.659260),
    const LatLng(8.479411, 124.659815),
    const LatLng(8.480161, 124.660293),
    const LatLng(8.480991, 124.660573),
    const LatLng(8.480714, 124.661805),
    const LatLng(8.480902, 124.661981),
    const LatLng(8.481415, 124.662026),
    const LatLng(8.481700, 124.661579),
    const LatLng(8.481852, 124.661223),
    const LatLng(8.482227, 124.660812),
    const LatLng(8.482386, 124.660703),
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
              LatLng(8.480675, 124.660238), // Center the map over London
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
                    const LatLng(8.482233, 124.660752),
                    const LatLng(8.482175, 124.660623),
                    const LatLng(8.481729, 124.660316),
                    const LatLng(8.481019, 124.660092),
                    const LatLng(8.480461, 124.659808),
                    const LatLng(8.480199, 124.659474),
                    const LatLng(8.479843, 124.659193),
                    const LatLng(8.479505, 124.659305),
                    const LatLng(8.479385, 124.659496),
                    const LatLng(8.479483, 124.659668),
                    const LatLng(8.479792, 124.659875),
                    const LatLng(8.480212, 124.660057),
                    const LatLng(8.481004, 124.660201),
                    const LatLng(8.481196, 124.660287),
                    const LatLng(8.481116, 124.660734),
                    const LatLng(8.480887, 124.661596),
                    const LatLng(8.480890, 124.661874),
                    const LatLng(8.480969, 124.661941),
                    const LatLng(8.481418, 124.662017),
                    const LatLng(8.481679, 124.661587),
                    const LatLng(8.481793, 124.661284),
                    const LatLng(8.482212, 124.660751),
                    const LatLng(8.482161, 124.660616),
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
