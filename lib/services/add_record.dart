import 'package:cloud_firestore/cloud_firestore.dart';

Future addRecord(userId, type, time) async {
  final docUser = FirebaseFirestore.instance.collection('Records').doc(
      '$userId${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}$time');

  final json = {
    'id': docUser.id,
    'isVerified': false,
    'dateTime': DateTime.now(),
    'type': type,
    'userId': userId,
    'time': time,
  };

  await docUser.set(json);
}
