import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quanlysinhvien/admin/subjects/admin_delete_subject_screen.dart';
import 'package:quanlysinhvien/admin/subjects/admin_update_subject_screen.dart';
import 'package:quanlysinhvien/model/subject_model.dart';

class AdminCreateSubjectScreen extends StatefulWidget {
  const AdminCreateSubjectScreen({super.key});

  @override
  State<AdminCreateSubjectScreen> createState() =>
      _AdminCreateSubjectScreenState();
}

class _AdminCreateSubjectScreenState extends State<AdminCreateSubjectScreen> {
  final TextEditingController _maMHController = TextEditingController();
  final TextEditingController _tinChiController = TextEditingController();
  final TextEditingController _tenMHController = TextEditingController();

  Future<void> _createSubject() async {
    String maMH = _maMHController.text;
    int tinChi = int.parse(_tinChiController.text);
    String tenMH = _tenMHController.text;

    Subject subject = Subject(maMH: maMH, tinChi: tinChi, tenMH: tenMH);

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("MonHoc").add(subject.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Môn học đã được tạo thành công')),
    );

    _maMHController.clear();
    _tinChiController.clear();
    _tenMHController.clear();
  }

  void _deleteSubject() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminDeleteSubjectScreen()));
  }

  void _updateSubject() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminUpdateSubjectScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Môn Học Mới'),
        actions: [
          IconButton(onPressed: _updateSubject, icon: const Icon(Icons.update)),
          IconButton(onPressed: _deleteSubject, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _maMHController,
                decoration: const InputDecoration(
                  labelText: 'Mã Môn Học',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã môn học';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tinChiController,
                decoration: const InputDecoration(
                  labelText: 'Tín Chỉ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tín chỉ';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập một số hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tenMHController,
                decoration: const InputDecoration(
                  labelText: 'Tên Môn Học',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên môn học';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createSubject,
                child: const Text('Tạo Môn Học'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
