import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';  
import 'package:randomno/views/login.dart';
import '../services/firebase_service.dart';

class LastLogin extends StatefulWidget {
  const LastLogin({super.key});

  @override
  State<LastLogin> createState() => _LastLoginState();
}

class _LastLoginState extends State<LastLogin> {
  bool isLoading = true;
  List<Map<String, dynamic>> loginData = [];  

  final FirebaseService firebaseService = FirebaseService();

   Future<void> fetchLoginData() async {
    try {
      setState(() {
        isLoading = true;
      });
       List<Map<String, dynamic>> data = await firebaseService.getLoginData();

      setState(() {
        loginData = data;  
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        "Error",
        "Failed to load login data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLoginData();  
  }

  void logout() {
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF25274D),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Colors.white, onPressed: () => Get.back()),
                  InkWell(
                    onTap: () {
                      logout();
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Container(
                height: Get.height,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: loginData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                      "Login Time: ${loginData[index]['time']}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("IP: ${loginData[index]['ip']}"),
                                      Text(
                                          "Location: ${loginData[index]['location']}"),
                                      if (loginData[index]['qrData'] != null)
                                        QrImageView(
                                          data: loginData[index]['qrData'] ??
                                              'No QR data',
                                          size: 100.0,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
