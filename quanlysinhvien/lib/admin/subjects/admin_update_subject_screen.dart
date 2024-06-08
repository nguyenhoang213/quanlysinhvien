import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quanlysinhvien/model/subject_model.dart';

class AdminUpdateSubjectScreen extends StatefulWidget {
  const AdminUpdateSubjectScreen({super.key});

  @override
  State<AdminUpdateSubjectScreen> createState() =>
      _AdminUpdateSubjectScreenState();
}

class _AdminUpdateSubjectScreenState extends State<AdminUpdateSubjectScreen> {
  String? _selectedMaMH;
  final TextEditingController _tinChiController = TextEditingController();
  final TextEditingController _tenMHController = TextEditingController();
  List<String> _maMHList = [];
  Subject? _selectedSubject;
  bool isGet = false;

  @override
  void initState() {
    super.initState();
    fetchMaMH();
  }

  Future<void> fetchMaMH() async {
    QuerySnapshot maMHQuery =
        await FirebaseFirestore.instance.collection("MonHoc").get();
    setState(() {
      _maMHList = maMHQuery.docs.map((doc) => doc['maMH'] as String).toList();
    });
  }

  Future<void> getMH() async {
    QuerySnapshot maMHQuery = await FirebaseFirestore.instance
        .collection("MonHoc")
        .where("maMH", isEqualTo: _selectedMaMH)
        .get();
    _selectedSubject =
        Subject.fromMap(maMHQuery.docs.first.data() as Map<String, dynamic>);
    if (_selectedSubject!.toMap().isNotEmpty) {
      setState(() {
        isGet = true;
        _tinChiController.text = _selectedSubject!.tinChi.toString();
        _tenMHController.text = _selectedSubject!.tenMH.toString();
      });
    }
  }

  Future<void> _updateSubject() async {
    try {
      final updatedData = {
        'maMH': _selectedMaMH,
        'tenMH': _tenMHController.text,
        'tinChi': int.parse(_tinChiController.text),
      };

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('MonHoc')
          .where('maMH', isEqualTo: _selectedSubject!.maMH)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update(updatedData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thông tin thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật môn học'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMaMH,
                decoration: const InputDecoration(labelText: 'Mã Môn Học'),
                items: _maMHList.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  getMH();
                  setState(() {
                    _selectedMaMH = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn mã môn học';
                  }
                  return null;
                },
              ),
              if (isGet) ...[
                TextFormField(
                  controller: _tenMHController,
                  decoration: const InputDecoration(labelText: 'Tên Môn Học'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên môn học';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tinChiController,
                  decoration: const InputDecoration(labelText: 'Số tín chỉ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tín chỉ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateSubject,
                  child: const Text('Cập nhật'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
