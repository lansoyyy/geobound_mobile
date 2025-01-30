import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geobound_mobile/screens/login_screen.dart';

logout(BuildContext context, Widget navigationRoute, String id) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Logout Confirmation',
              style:
                  TextStyle(fontFamily: 'QBold', fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to Logout?',
              style: TextStyle(fontFamily: 'QRegular'),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(id)
                      .update({
                    'lat': 0,
                    'lng': 0,
                  });
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ));
}
