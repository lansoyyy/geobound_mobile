import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geobound_mobile/screens/personnel_screen.dart';
import 'package:geobound_mobile/utils/colors.dart';
import 'package:geobound_mobile/widgets/button_widget.dart';
import 'package:geobound_mobile/widgets/text_widget.dart';
import 'package:geobound_mobile/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  bool inLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'Personnel Account',
              fontSize: 18,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              height: 45,
              color: Colors.white,
              borderColor: Colors.white,
              label: 'Personnel ID',
              controller: _controller,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              color: Colors.amber,
              width: 150,
              radius: 10,
              label: 'Login',
              onPressed: () async {
                final personnelId = _controller.text.trim();
                if (personnelId.isNotEmpty) {
                  // Do something with the personnel ID
                  print("Personnel ID entered: $personnelId");

                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(personnelId)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      print('Document exists on the database');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => PersonnelScreen(
                                id: personnelId,
                              )));
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid ID!"),
                        ),
                      );
                    }
                  });
                } else {
                  // Show an error or a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid Personnel ID"),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _controller = TextEditingController();
}
