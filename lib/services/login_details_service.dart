import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LoginDetailsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<void> saveLoginDetails(String phone, String? ip, [Position? location]) async {
    try {
       DateTime utcNow = DateTime.now().toUtc();

       DateTime istTime = utcNow.add(const Duration(hours: 5, minutes: 30));

       final loginDetails = {
        "phone": phone,
        "ip_address": ip ?? "Unknown", 
        "location": location != null
            ? {"latitude": location.latitude, "longitude": location.longitude}
            : "Unknown",
        "timestamp": istTime.toIso8601String(), 
      };

       await _firestore.collection('login_data').add(loginDetails);
      print('Login details saved successfully with IST timestamp: $istTime');
    } catch (e) {
      print('Error saving login details: $e');
    }
  }
}
