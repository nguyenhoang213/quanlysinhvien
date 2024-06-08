import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quanlysinhvien/admin/admin_screen.dart';
import 'package:quanlysinhvien/student/student_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  String? _role;
  String _errorMessage = '';
  bool passwordHidden = true;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        QuerySnapshot roleQuery = await fb
            .collection("User")
            .where('email', isEqualTo: _emailController.text)
            .get();
        if (roleQuery.docs.isNotEmpty) {
          setState(() {
            Map<String, dynamic> data =
                roleQuery.docs.first.data() as Map<String, dynamic>;
            _role = data['role'];
          });
        }
        // Đăng nhập thành công
        if (_role == "Student") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentScreen(
                      email: _emailController.text,
                    )),
          );
        } else if (_role == "Admin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  void _forgot_password() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 60.0,
              child: Image.asset('assets/images/Sample_User_Icon.png'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: passwordHidden
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordHidden = !passwordHidden;
                      });
                    },
                  )),
              obscureText: passwordHidden,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: _forgot_password,
                  child: const Text("Quên mật khẩu")),
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Đăng nhập"),
            ),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
