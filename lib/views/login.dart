import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randomno/views/plugin.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/login_details_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool isLoading = false;
  final AuthService authService = AuthService();
  final LocationService locationService = LocationService();
  final LoginDetailsService loginDetailsService = LoginDetailsService();

  Future<void> loginWithOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ip = await locationService.fetchIpAddress();
      final location = await locationService.fetchLocation();

      String locationName = "Unknown Location";
      if (location != null) {
        locationName = await locationService.getAddressFromCoordinates(
          location.latitude,
          location.longitude,
        );
      }

      if (otpController.text == "1234") {
        Get.snackbar(
          "Static OTP Login",
          "Logged in using static OTP.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        String randomNumber = Random().nextInt(1000000).toString();
        String qrData = "Random: $randomNumber";

        Get.off(() => Plugin(
              phone: mobileController.text,
              ipAddress: ip ?? "Unknown",
              location: locationName,
              qrData: qrData,
              randomNumber: randomNumber,
            ));
      } else {
        await authService.verifyPhoneAndLogin(otpController.text);

        String randomNumber = Random().nextInt(1000000).toString();
        String qrData = "Random: $randomNumber";

        Get.off(() => Plugin(
              phone: mobileController.text,
              ipAddress: ip ?? "Unknown",
              location: locationName,
              qrData: qrData,
              randomNumber: randomNumber,
            ));
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF25274D),
      body: SingleChildScrollView(
        child: Stack(
          children: [
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
                      SizedBox(height: Get.height / 6),
                      const Text(
                        'Phone number',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF25274D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await authService
                                  .sendPhoneOtp(mobileController.text);
                              Get.snackbar(
                                "OTP Sent",
                                "OTP has been sent to ${mobileController.text}",
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
                          },
                          child: const Text(
                            "Get OTP",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'OTP',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter OTP",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF25274D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: loginWithOtp,
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
                                  'LOGIN',
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
                      "LOGIN",
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
