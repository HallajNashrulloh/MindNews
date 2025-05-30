import 'package:flutter/material.dart';
// import 'package:tb_ppm/views/loading_screen.dart';
import 'package:tb_ppm/views/login_screen.dart';
import 'package:tb_ppm/utils/helper.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cPrimary, // Hijau Madrasah
      body: Column(
        children: [
          // Strip putih atas
          Container(
            height: 20,
            color: Colors.white,
          ),
          // Background hijau dengan logo di tengah
          Expanded(
            child: Container(
              child: Center(
                child: Image.asset(
                  'assets/mindlogo.png',
                  width: 200, // Sesuaikan ukuran dengan kebutuhan
                ),
              ),
            ),
          ),
          // Strip putih bawah
          Container(
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
