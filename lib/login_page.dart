import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'main.dart'; // to navigate back to NotesHomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authBox = Hive.box('authBox');
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  bool isSignUp = false;

  void toggleMode() {
    setState(() {
      isSignUp = !isSignUp;
      emailCtrl.clear();
      passCtrl.clear();
    });
  }

  void login() {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email & password")),
      );
      return;
    }

    // Check if user exists
    String? storedPass = authBox.get(email);
    if (storedPass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found. Please sign up.")),
      );
      return;
    }

    if (storedPass != pass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect password")),
      );
      return;
    }

    authBox.put('loggedIn', true);
    authBox.put('currentUser', email);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NotesHomePage()),
    );
  }

  void signUp() {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email & password")),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email")),
      );
      return;
    }

    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    // Check if user already exists
    if (authBox.get(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User already exists. Please login.")),
      );
      return;
    }

    authBox.put(email, pass);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sign up successful! Please login.")),
    );
    toggleMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  isSignUp ? "Sign Up" : "Login",
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                const SizedBox(height: 30),

                // EMAIL
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.tealAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: isSignUp ? signUp : login,
                  child: Text(
                    isSignUp ? "Sign Up" : "Login",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: toggleMode,
                  child: Text(
                    isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up",
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
