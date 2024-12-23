import 'dart:developer';
import 'dart:js' as js;

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final jsVariables = fetchJavaScriptVariables();
  runApp(MyApp(jsVariables: jsVariables));
}

/// A simple class to hold JavaScript variables
class JavaScriptVariables {
  final String? token;
  final String? msisdn;

  JavaScriptVariables({this.token, this.msisdn});
}

/// Fetch JavaScript Variables
JavaScriptVariables fetchJavaScriptVariables() {
  try {
    final token =
        js.context.hasProperty('token') ? js.context['token'] as String? : null;
    final msisdn = js.context.hasProperty('msisdn')
        ? js.context['msisdn'] as String?
        : null;

    if (token != null && msisdn != null) {
      log('WEB PAGE LOG 🔗 API URL: $msisdn');
      log('WEB PAGE LOG 🔑 Token: $token');
      debugPrint(
          '✅ JavaScript Variables Found:\n🔑 Token: $token\n🔗 API URL: $msisdn');
    } else {
      debugPrint('⚠️ JavaScript variables "token" or "msisdn" not found.');
    }

    return JavaScriptVariables(token: token, msisdn: msisdn);
  } catch (e, stackTrace) {
    log('❌ Error accessing JavaScript variables: $e', stackTrace: stackTrace);
    return JavaScriptVariables();
  }
}

/// Flutter App
class MyApp extends StatelessWidget {
  final JavaScriptVariables jsVariables;

  const MyApp({super.key, required this.jsVariables});

  @override
  Widget build(BuildContext context) {
    // You can pass jsVariables to the widget tree if needed
    return MaterialApp(
      title: 'Flutter Web with JS Variables',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(jsVariables: jsVariables),
    );
  }
}

/// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.jsVariables});

  final JavaScriptVariables jsVariables;

  void _handleLogin() {
    debugPrint('Login button pressed');
    // Implement your login logic here
  }

  void _handleForgotPassword() {
    debugPrint('Forgot Password pressed');
    // Implement your forgot password logic here
  }

  void _handleSignUp() {
    debugPrint('Sign Up pressed');
    // Implement your sign up logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Added a subtle background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FlutterLogo(size: 100),
                    const SizedBox(height: 24),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: jsVariables.token ?? 'Enter your email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: jsVariables.msisdn ?? 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: const Text('Forgot Password?'),
                    ),
                    const Divider(height: 32),
                    TextButton(
                      onPressed: _handleSignUp,
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
