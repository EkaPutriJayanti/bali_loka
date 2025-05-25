// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bali_loka/screens/home_screen.dart';
// import 'package:bali_loka/service/firebase_auth.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String? _error;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//     try {
//       await registerUser(
//         _nameController.text.trim(),
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//         _phoneController.text.trim(),
//       );
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );
//     } catch (e) {
//       setState(() {
//         _error = e is Exception ? e.toString() : 'Sign up failed';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Back Button
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//                 // Logo
//                 Image.asset('assets/icons/Logo.png', height: 140),
//                 const SizedBox(height: 20),
//                 const SizedBox(height: 40),
//                 // Name Field
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     hintText: 'Name',
//                     hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Colors.grey,
//                         width: 0.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFF4A72B0),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Phone Number Field
//                 TextField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     hintText: 'Phone Number',
//                     hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Colors.grey,
//                         width: 0.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFF4A72B0),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Email Field
//                 TextField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Colors.grey,
//                         width: 0.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFF4A72B0),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Password Field
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Colors.grey,
//                         width: 0.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFF4A72B0),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 if (_error != null) ...[
//                   Text(_error!, style: const TextStyle(color: Colors.red)),
//                   const SizedBox(height: 8),
//                 ],
//                 // Sign Up Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _handleSignUp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4A72B0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child:
//                         _isLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                             : Text(
//                               'Sign Up',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Login Link
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     Text(
//                 //       'Already have an account? ',
//                 //       style: GoogleFonts.poppins(color: Colors.grey),
//                 //     ),
//                 //     GestureDetector(
//                 //       onTap: () => Navigator.pop(context),
//                 //       child: Text(
//                 //         'Sign in',
//                 //         style: GoogleFonts.poppins(
//                 //           color: const Color(0xFF4A72B0),
//                 //           fontWeight: FontWeight.w600,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bali_loka/screens/home_screen.dart';
import 'package:bali_loka/service/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;

  // Error states
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _nameError = null;
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
      _error = null;
    });

    // Name validation
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Nama tidak boleh kosong';
      });
      return;
    }

    // Phone validation
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _phoneError = 'Nomor telepon tidak boleh kosong';
      });
      return;
    } else if (!RegExp(
      r'^[0-9]{10,13}$',
    ).hasMatch(_phoneController.text.trim())) {
      setState(() {
        _phoneError = 'Format nomor telepon tidak valid';
      });
      return;
    }

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      setState(() {
      _emailError = 'Email tidak boleh kosong';
      });
      return;
    } else if (!RegExp(
      r'^[\w\.\-@]+@([\w\-]+\.)+[\w\-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      setState(() {
      _emailError = 'Format email tidak valid';
      });
      return;
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password tidak boleh kosong';
      });
      return;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password minimal 6 karakter';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await registerUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _phoneController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Logo
                Image.asset('assets/icons/Logo.png', height: 140),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                // Name Field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _nameError != null ? Colors.red : Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _nameError != null
                                ? Colors.red
                                : const Color(0xFF4A72B0),
                        width: 1,
                      ),
                    ),
                    errorText: _nameError,
                  ),
                ),
                const SizedBox(height: 16),
                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _phoneError != null ? Colors.red : Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _phoneError != null
                                ? Colors.red
                                : const Color(0xFF4A72B0),
                        width: 1,
                      ),
                    ),
                    errorText: _phoneError,
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _emailError != null ? Colors.red : Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _emailError != null
                                ? Colors.red
                                : const Color(0xFF4A72B0),
                        width: 1,
                      ),
                    ),
                    errorText: _emailError,
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _passwordError != null ? Colors.red : Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _passwordError != null
                                ? Colors.red
                                : const Color(0xFF4A72B0),
                        width: 1,
                      ),
                    ),
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(right: 12),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A72B0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
