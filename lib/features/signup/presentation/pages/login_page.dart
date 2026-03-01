import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                const SizedBox(height: 60),
                // Logo
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Color(0xFF6B46C1),
                      ),
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
                const SizedBox(height: 50),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Handle forgot password
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot Password?')),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF6B46C1), fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final email = _emailController.text.trim();
                          final password = _passwordController.text;

                          final supabase = Supabase.instance.client;

                          // เก็บ reference ก่อน await
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);

                          try {
                            final res = await supabase.auth.signInWithPassword(
                              email: email,
                              password: password,
                            );

                            if (!context.mounted) return;

                            if (res.user != null) {
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Logged in!')),
                              );
                              navigator.pushReplacementNamed('/');
                              return;
                            }

                            messenger.showSnackBar(
                              const SnackBar(content: Text('Login failed')),
                            );
                          } catch (e) {
                            if (!context.mounted) return;

                            messenger.showSnackBar(
                              SnackBar(content: Text('Login error: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B46C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 24),
                // Google Sign-in Button (uses Supabase OAuth)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);

                      try {
                        final supabase = Supabase.instance.client;
                        final redirectUrl = kIsWeb
                            ? 'http://localhost:3000/login-callback'
                            : 'jodhere://login-callback';

                        await supabase.auth.signInWithOAuth(
                          OAuthProvider.google,
                          redirectTo: redirectUrl,
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        messenger.showSnackBar(
                          SnackBar(content: Text('Google sign-in error: $e')),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF6B46C1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(
                      Icons.login,
                      color: Color(0xFF6B46C1),
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: Color(0xFF6B46C1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No account yet? ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle register navigation
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFF6B46C1),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
