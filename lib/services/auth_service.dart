import 'package:firebase_auth/firebase_auth.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Future<void> sendPhoneOtp(String phoneNumber) async {
  if (phoneNumber.isEmpty || phoneNumber.length < 10) {
    throw Exception("Please enter a valid phone number.");
  }

  await _auth.verifyPhoneNumber(
    phoneNumber: '+91$phoneNumber',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      print("Auto-verification completed.");
    },
    verificationFailed: (FirebaseAuthException e) {
      String error = "Verification Failed";
      if (e.code == 'invalid-phone-number') {
        error = "Invalid phone number format.";
      }
      throw Exception(error);
    },
    codeSent: (String verificationId, int? resendToken) {
      _verificationId = verificationId;
      print("Code sent to $phoneNumber");
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      _verificationId = verificationId;
      print("Auto retrieval timeout");
    },
  );
}

  Future<void> verifyPhoneAndLogin(String otp) async {
    if (_verificationId == null) throw Exception("Verification ID is null");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    await _auth.signInWithCredential(credential);
  }
}
