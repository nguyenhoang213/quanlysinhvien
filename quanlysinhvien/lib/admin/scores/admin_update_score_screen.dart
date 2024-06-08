import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUpdateScoreScreen extends StatefulWidget {
  const AdminUpdateScoreScreen({super.key});

  @override
  State<AdminUpdateScoreScreen> createState() => _AdminUpdateScoreScreenState();
}

class _AdminUpdateScoreScreenState extends State<AdminUpdateScoreScreen> {
  String? _selectedMaSV;
  String? _selectedSubject;
  int? _selectedHeSo;
  final _diemController = TextEditingController();
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

  void _updateScores() async {
    try {
      String maSV = _selectedMaSV!;
      String monHoc = _selectedSubject!;
      int heSo = _selectedHeSo!;
      double diem = double.parse(_diemController.text);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Diem")
          .where("maSV", isEqualTo: maSV)
          .where("monHoc", isEqualTo: monHoc)
          .where("heSo", isEqualTo: heSo)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({"diem": diem});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật điểm thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể cập nhật điểm')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật điểm'),
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
                TextFormField(
                  controller: _diemController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập điểm';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Vui lòng nhập giá trị số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateScores,
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
