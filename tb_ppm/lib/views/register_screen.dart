import 'package:flutter/material.dart';
import 'package:mindnews/views/login_screen.dart';
import 'package:mindnews/utils/helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cPrimary, // Hijau Madrasah
      body: Column(
        children: [
          // Strip putih atas
          Container(height: 20, color: Colors.white),

          // Body hijau
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Logo
                    Image.asset(
                      'assets/mindlogo.png',
                      width: 200,
                    ),
                    const SizedBox(height: 20),

                    // Judul dan subjudul
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Segera Bergabung dengan Para Cendikiawan",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Buat Sudut Pandangmu Menjadi Lebih Baik",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const Text( 
                      "Wujudkan Harapan yang Terpendam dalam Ungkapan Kalimat",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Nama Depan
                    _buildInputField("Nama Depan"),
                    const SizedBox(height: 12),

                    // Form Nama Belakang
                    _buildInputField("Nama Belakang"),
                    const SizedBox(height: 12),

                    // Form Email
                    _buildInputField("Email"),
                    const SizedBox(height: 12),

                    // Form Password
                    _buildInputField("Password", isPassword: true),
                    const SizedBox(height: 12),

                    // Form Konfirmasi Password
                    _buildInputField("Konformasi Password", isPassword: true),
                    const SizedBox(height: 24),

                    // Tombol Daftar
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sudah punya akun
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah Punya Akun? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Strip putih bawah
          Container(height: 20, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA1BF5D),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: isPassword ? isObscure : false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
