import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quanlysinhvien/admin/scores/admin_delete_score_screen.dart';
import 'package:quanlysinhvien/admin/scores/admin_update_score_screen.dart';

class AdminInputScoreScreen extends StatefulWidget {
  const AdminInputScoreScreen({super.key});

  @override
  State<AdminInputScoreScreen> createState() => _AdminInputScoreScreenState();
}

class _AdminInputScoreScreenState extends State<AdminInputScoreScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMaSV;
  final TextEditingController _scoreController = TextEditingController();
  String? _selectedSubject;
  int? _selectedHeSo;
  List<String> _maSVList = [];
  List<String> _subjects = [];
  final List<int> _heSo = [1, 2, 3];

  @override
  void initState() {
    super.initState();
    fetchMaSV();
    fetchSubject();
  }

  void _updateScore() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminUpdateScoreScreen()));
  }

  void _deleteScore() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminDeleteScoreScreen()));
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
    QuerySnapshot TenMonQuery = await db.collection("MonHoc").get();
    setState(() {
      _subjects =
          TenMonQuery.docs.map((doc) => doc['tenMH'] as String).toList();
    });
  }

  Future<void> submitScore(
      String maSV, String subject, int heSo, double score) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Diem").add({
      'maSV': maSV,
      'monHoc': subject,
      'heSo': heSo,
      'diem': score,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Điểm'),
        actions: [
          IconButton(onPressed: _updateScore, icon: const Icon(Icons.update)),
          IconButton(onPressed: _deleteScore, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMaSV,
                decoration: const InputDecoration(
                  labelText: 'Mã Sinh Viên',
                ),
                items: _maSVList.map((String maSV) {
                  return DropdownMenuItem<String>(
                    value: maSV,
                    child: Text(maSV),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMaSV = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn sinh viên';
                  }
                  return null;
                },
              ),
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
                controller: _scoreController,
                decoration: const InputDecoration(
                  labelText: 'Điểm',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập điểm';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập một số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String maSV = _selectedMaSV!;
                    String subject = _selectedSubject!;
                    int heSo = _selectedHeSo!;
                    double score = double.parse(_scoreController.text);

                    await submitScore(maSV, subject, heSo, score);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Điểm đã được nhập cho $maSV')),
                    );

                    _formKey.currentState!.reset();
                    setState(() {
                      _selectedMaSV = null;
                      _selectedSubject = null;
                    });
                  }
                },
                child: const Text('Nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
