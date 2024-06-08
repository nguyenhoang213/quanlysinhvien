import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDeleteScoreScreen extends StatefulWidget {
  const AdminDeleteScoreScreen({super.key});

  @override
  State<AdminDeleteScoreScreen> createState() => _AdminDeleteScoreScreenState();
}

class _AdminDeleteScoreScreenState extends State<AdminDeleteScoreScreen> {
  String? _selectedMaSV;
  String? _selectedSubject;
  int? _selectedHeSo;
  final List<int> _heSo = [1, 2, 3];

  List<String> _maSVList = [];
  List<String> _subjects = [];

  @override
  void initState() {
    fetchMaSV();
    super.initState();
  }

  Future<void> fetchMaSV() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot maSVQuery = await db.collection("SinhVien").get();
    setState(() {
      _maSVList = maSVQuery.docs.map((doc) => doc['maSV'] as String).toList();
    });
  }

  Future<void> fetchSubject() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot tenMonQuery = await db.collection("MonHoc").get();
    setState(() {
      _subjects =
          tenMonQuery.docs.map((doc) => doc['tenMH'] as String).toList();
    });
  }

  Future<void> _deleteScores() async {
    try {
      // Tìm tài liệu với email cụ thể trong Firestore
      var collection = FirebaseFirestore.instance.collection('Diem');
      var snapshot = await collection
          .where('maSV', isEqualTo: _selectedMaSV)
          .where('monHoc', isEqualTo: _selectedSubject)
          .where('heSo', isEqualTo: _selectedHeSo)
          .get();

      // Xóa tất cả các tài liệu tìm thấy
      for (var doc in snapshot.docs) {
        await collection.doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa dữ liệu thành công')),
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
        title: const Text("Xóa Điểm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMaSV,
              decoration: const InputDecoration(labelText: 'Mã Sinh viên'),
              items: _maSVList.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMaSV = newValue;
                  fetchSubject();
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn mã sinh viên';
                }
                return null;
              },
            ),
            if (_selectedMaSV != null) ...[
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Môn Học',
                ),
                items: _subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn môn học';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedHeSo,
                decoration: const InputDecoration(
                  labelText: 'Hệ số',
                ),
                items: _heSo.map((int heSo) {
                  return DropdownMenuItem<int>(
                    value: heSo,
                    child: Text(heSo.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedHeSo = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn hệ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteScores,
                child: const Text('Xóa'),
              ),
            ]
          ],
        )),
      ),
    );
  }
}
