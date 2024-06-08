import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDeleteAccountScreen extends StatefulWidget {
  const AdminDeleteAccountScreen({super.key});

  @override
  State<AdminDeleteAccountScreen> createState() =>
      _AdminDeleteAccountScreenState();
}

class _AdminDeleteAccountScreenState extends State<AdminDeleteAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _deleteAccount(String email, String password) async {
    try {
      // Đăng nhập người dùng bằng email và mật khẩu
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Xóa tài khoản người dùng
      await userCredential.user?.delete();

      // Xóa dữ liệu từ Firestore
      await _deleteUserData(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa tài khoản và dữ liệu thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa tài khoản thất bại: $e')),
      );
    }
  }

  Future<void> _deleteUserData(String email) async {
    try {
      var collection = FirebaseFirestore.instance.collection('User');
      var snapshot = await collection.where('email', isEqualTo: email).get();

      for (var doc in snapshot.docs) {
        await collection.doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa dữ liệu thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa dữ liệu thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Xóa Tài Khoản'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email tài khoản cần xóa'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email tài khoản cần xóa';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Mật khẩu tài khoản cần xóa'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu tài khoản cần xóa';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteAccount(
                        _emailController.text, _passwordController.text),
                    child: const Text('Xóa Tài Khoản'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
