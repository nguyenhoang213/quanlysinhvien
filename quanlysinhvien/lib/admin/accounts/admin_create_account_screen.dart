import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quanlysinhvien/admin/accounts/admin_delete_account_screen.dart';
import 'package:quanlysinhvien/admin/accounts/admin_update_account_screen.dart';
import 'package:quanlysinhvien/model/student_model.dart';

class AdminCreateAccountScreen extends StatefulWidget {
  const AdminCreateAccountScreen({super.key});

  @override
  State<AdminCreateAccountScreen> createState() =>
      _AdminCreateAccountScreenState();
}

class _AdminCreateAccountScreenState extends State<AdminCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maSVController = TextEditingController();
  final TextEditingController _hoSVController = TextEditingController();
  final TextEditingController _tenSVController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _queQuanController = TextEditingController();
  final TextEditingController _anhController = TextEditingController();
  final TextEditingController _lopController = TextEditingController();
  final TextEditingController _khoaController = TextEditingController();
  final TextEditingController _nganhController = TextEditingController();
  final TextEditingController _chuyenNganhController = TextEditingController();
  DateTime? _selectedDate;
  String? _gioiTinh;
  String? _selectedRole;

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userCredential.user!.uid)
            .set({'email': _emailController.text, 'role': _selectedRole});
        if (_selectedRole == 'Student') {
          Student newSinhVien = Student(
            maSV: _maSVController.text,
            hoSV: _hoSVController.text,
            tenSV: _tenSVController.text,
            ngaySinh: _selectedDate,
            gioiTinh: _gioiTinh,
            sdt: _sdtController.text,
            email: _emailController.text,
            queQuan: _queQuanController.text,
            anh: _anhController.text,
            lop: _lopController.text,
            khoa: _khoaController.text,
            nganh: _nganhController.text,
            chuyenNganh: _chuyenNganhController.text,
          );

          await FirebaseFirestore.instance
              .collection('SinhVien')
              .add(newSinhVien.toMap());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo tài khoản thành công!')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.message}')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _deleteAccount() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminDeleteAccountScreen()));
  }

  void _updateAccount() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminUpdateAccountScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Tài Khoản'),
        actions: [
          IconButton(onPressed: _updateAccount, icon: const Icon(Icons.update)),
          IconButton(onPressed: _deleteAccount, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Vai trò'),
                  items: <String>['Admin', 'Student'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn vai trò';
                    }
                    return null;
                  },
                ),
                if (_selectedRole == 'Student') ...[
                  TextFormField(
                    controller: _maSVController,
                    decoration:
                        const InputDecoration(labelText: 'Mã Sinh Viên'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mã sinh viên';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hoSVController,
                    decoration:
                        const InputDecoration(labelText: 'Họ Sinh Viên'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ sinh viên';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tenSVController,
                    decoration:
                        const InputDecoration(labelText: 'Tên Sinh Viên'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên sinh viên';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : ''),
                    decoration: const InputDecoration(labelText: 'Ngày Sinh'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await _selectDate(context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn ngày sinh';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _gioiTinh,
                    decoration: const InputDecoration(labelText: 'Giới Tính'),
                    items: <String>['Nam', 'Nữ', 'Khác'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _gioiTinh = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn giới tính';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sdtController,
                    decoration:
                        const InputDecoration(labelText: 'Số Điện Thoại'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _queQuanController,
                    decoration: const InputDecoration(labelText: 'Quê Quán'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập quê quán';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _anhController,
                    decoration: const InputDecoration(labelText: 'Ảnh'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập URL ảnh';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lopController,
                    decoration: const InputDecoration(labelText: 'Lớp'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập lớp';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _khoaController,
                    decoration: const InputDecoration(labelText: 'Khoa'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập khoa';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nganhController,
                    decoration: const InputDecoration(labelText: 'Ngành'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập ngành';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _chuyenNganhController,
                    decoration:
                        const InputDecoration(labelText: 'Chuyên Ngành'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập chuyên ngành';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createAccount,
                  child: const Text('Tạo Tài Khoản'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
