import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';  
import 'package:randomno/views/last_login.dart';
import 'package:randomno/views/login.dart';
import '../services/location_service.dart';
import '../services/firebase_service.dart';

class Plugin extends StatefulWidget {
  final String phone;
  final String ipAddress;
  final String location;
  final String qrData;
  final String randomNumber;

  const Plugin({
    super.key,
    required this.phone,
    required this.ipAddress,
    required this.location,
    required this.qrData,
    required this.randomNumber,
  });

  @override
  State<Plugin> createState() => _PluginState();
}

class _PluginState extends State<Plugin> {
  bool isLoading = false;

  final LocationService locationService = LocationService();
  final FirebaseService firebaseService = FirebaseService();

  late String lastLoginTime;

  @override
  void initState() {
    super.initState();
    setLastLoginTime();  
  }

  void setLastLoginTime() {
     final DateTime now = DateTime.now();
    final DateTime istTime =
        now.toUtc().add(const Duration(hours: 5, minutes: 30));
    lastLoginTime = DateFormat("hh:mm a, dd MMM yyyy").format(istTime);
  }

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await firebaseService.saveLoginData(
        ip: widget.ipAddress,
        location: widget.location,
        qrData: widget.qrData,
        randomNumber: widget.randomNumber,
      );

      Get.snackbar(
        "Success",
        "Data saved successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              padding: const EdgeInsets.only(top: 60, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      logout();
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
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
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height / 8),
                      widget.qrData.isNotEmpty
                          ? Center(
                              child: QrImageView(
                                data: widget.qrData,
                                size: 150,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Generated Number ${widget.randomNumber}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 5),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const LastLogin());
                          },
                          child: Container(
                            height: 70,
                            width: Get.width * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Center(
                              child: Text(
                                "Last login Today: $lastLoginTime ",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: saveData,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 15),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 128,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: Get.height / 20,
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                    child: Text(
                      "PLUGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
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
