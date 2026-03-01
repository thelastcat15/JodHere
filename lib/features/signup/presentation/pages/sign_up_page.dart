import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Logo
                Center(
                  child: Column(
                    children: [
                      // Image  .asset(
                      //   'assets/images/jodhere_logo.png',
                      //   height: 100,
                      //   width: 100,
                      // ),
                      const SizedBox(height: 16),
                      const Text(
                        'JodHere',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B46C1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // DisplayName Field
                _buildTextFormField(_displayNameController, 'Display Name'),
                const SizedBox(height: 16),
                // Tel Field
                _buildTelField(_telController, 'Tel.'),
                const SizedBox(height: 16),
                // Email Field
                _buildTextFormField(_emailController, 'Email'),
                const SizedBox(height: 16),
                // Password Field
                _buildTextFormField(_passwordController, 'Password'),
                const SizedBox(height: 16),
                // Confirm Password Field
                _buildTextFormField(
                  _confirmPasswordController,
                  'Confirm Password',
                ),
                const SizedBox(height: 24),
                // Terms Agreement Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF6B46C1),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'I accept ',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'terms of the agreement',
                              style: const TextStyle(
                                color: Color(0xFF6B46C1),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle terms link tap
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Terms of agreement'),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _acceptTerms
                      ? () async {
                          if (!_formKey.currentState!.validate()) return;

                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          final confirm = _confirmPasswordController.text;
                          final displayName = _displayNameController.text.trim();
                          final tel = _telController.text.trim();

                          if (password != confirm) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Passwords do not match')),
                            );
                            return;
                          }

                          final supabase = Supabase.instance.client;

                          try {
                            final res = await supabase.auth.signUp(
                              email: email,
                              password: password,
                              data: {
                                'display_name': displayName,
                                'phone': tel,
                              },
                            );

                            if (res.session != null) {
                              Navigator.pushReplacementNamed(context, '/');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registration successful! Check your email to confirm.',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Registration failed: $e')),
                            );
                          }
                        }
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B46C1),
                      disabledBackgroundColor: const Color(0xFFD1D5DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle sign in navigation
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xFF6B46C1),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(
    TextEditingController controller,
    String label,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  TextFormField _buildTelField(
    TextEditingController controller,
    String label,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        }

        final phone = value.trim();

        if (!RegExp(r'^0[689]\d{8}$').hasMatch(phone)) {
          return 'Invalid Thai phone number';
        }

        return null;
      },
    );
  }
}
