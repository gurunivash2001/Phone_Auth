import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   String _getIndianStandardTime() {
    final now = DateTime.now();
    final istTime = now.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(istTime);
  }

   Future<void> saveLoginData({
    required String ip,
    required String location,
    required String qrData,
    required String randomNumber,
  }) async {
    try {
      await _firestore.collection('login_data').add({
        'time': _getIndianStandardTime(),  
        'ip': ip,
        'location': location,
        'qrData': qrData,
        'randomNumber': randomNumber,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getLoginData() async {
    try {
      var snapshot = await _firestore.collection('login_data').get();
      return snapshot.docs.map((doc) {
        return {
          'time': doc['time'],
          'ip': doc['ip'],
          'location': doc['location'],
          'qrData': doc['qrData'],
          'randomNumber': doc['randomNumber'],
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
