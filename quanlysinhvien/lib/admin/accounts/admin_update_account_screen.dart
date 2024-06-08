import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quanlysinhvien/model/student_model.dart';

class AdminUpdateAccountScreen extends StatefulWidget {
  const AdminUpdateAccountScreen({super.key});

  @override
  State<AdminUpdateAccountScreen> createState() =>
      _AdminUpdateAccountScreenState();
}

class _AdminUpdateAccountScreenState extends State<AdminUpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
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
  Student? sinhvien;
  bool isLoading = false;

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

  Future<void> _getThongTin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('SinhVien')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        sinhvien = Student.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);

        setState(() {
          _maSVController.text = sinhvien!.maSV ?? '';
          _hoSVController.text = sinhvien!.hoSV ?? '';
          _tenSVController.text = sinhvien!.tenSV ?? '';
          _selectedDate = sinhvien!.ngaySinh;
          _gioiTinh = sinhvien!.gioiTinh;
          _sdtController.text = sinhvien!.sdt ?? '';
          _queQuanController.text = sinhvien!.queQuan ?? '';
          _anhController.text = sinhvien!.anh ?? '';
          _lopController.text = sinhvien!.lop ?? '';
          _khoaController.text = sinhvien!.khoa ?? '';
          _nganhController.text = sinhvien!.nganh ?? '';
          _chuyenNganhController.text = sinhvien!.chuyenNganh ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy tài khoản')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final updatedData = {
          'maSV': _maSVController.text,
          'hoSV': _hoSVController.text,
          'tenSV': _tenSVController.text,
          'ngaySinh': _selectedDate?.millisecondsSinceEpoch,
          'gioiTinh': _gioiTinh,
          'sdt': _sdtController.text,
          'email': _emailController.text,
          'queQuan': _queQuanController.text,
          'anh': _anhController.text,
          'lop': _lopController.text,
          'khoa': _khoaController.text,
          'nganh': _nganhController.text,
          'chuyenNganh': _chuyenNganhController.text,
        };

        final querySnapshot = await FirebaseFirestore.instance
            .collection('SinhVien')
            .where('email', isEqualTo: sinhvien!.email)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.update(updatedData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thành công')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin thất bại: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật Tài Khoản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email tài khoản cần cập nhật',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email tài khoản cần cập nhật';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _getThongTin,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Tìm kiếm Tài Khoản'),
                ),
                if (sinhvien != null) ...[
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
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : '',
                    ),
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
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateAccount,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Cập nhật Thông Tin"),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
