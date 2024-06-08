import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDeleteSubjectScreen extends StatefulWidget {
  const AdminDeleteSubjectScreen({super.key});

  @override
  State<AdminDeleteSubjectScreen> createState() =>
      _AdminDeleteSubjectScreenState();
}

class _AdminDeleteSubjectScreenState extends State<AdminDeleteSubjectScreen> {
  String? _selectedMaMH;
  List<String> _maMHList = [];

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

  Future<void> _deleteSubject() async {
    if (_selectedMaMH == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('MonHoc')
          .where('maMH', isEqualTo: _selectedMaMH)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa môn học thành công')),
      );

      setState(() {
        _selectedMaMH = null;
        fetchMaMH(); // Refresh the list after deletion
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa môn học thất bại: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xóa môn học'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMaMH,
              decoration: const InputDecoration(labelText: 'Mã Môn Học'),
              items: _maMHList.map((String maMH) {
                return DropdownMenuItem<String>(
                  value: maMH,
                  child: Text(maMH),
                );
              }).toList(),
              onChanged: (String? newValue) {
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteSubject,
              child: const Text('Xóa môn học'),
            ),
          ],
        ),
      ),
    );
  }
}
