import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentScoreScreen extends StatefulWidget {
  final String? email;
  const StudentScoreScreen({super.key, this.email});

  @override
  State<StudentScoreScreen> createState() => _StudentScoreScreenState();
}

class _StudentScoreScreenState extends State<StudentScoreScreen> {
  String? _email;
  String? _maSV;
  final db = FirebaseFirestore.instance;
  late Future<Map<String, Map<int, double>>> _futureScoresByMonHoc;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _futureScoresByMonHoc = fetchStudentScoresByMonHoc();
  }

  Future<Map<String, Map<int, double>>> fetchStudentScoresByMonHoc() async {
    // Fetch student's maSV using email
    QuerySnapshot maSVQuery =
        await db.collection('SinhVien').where('email', isEqualTo: _email).get();

    if (maSVQuery.docs.isNotEmpty) {
      _maSV = maSVQuery.docs.first['maSV'];
    } else {
      throw Exception('Không tìm thấy mã sinh viên cho email đã nhập.');
    }

    // Fetch scores for the student
    QuerySnapshot scoresQuery =
        await db.collection('Diem').where('maSV', isEqualTo: _maSV).get();

    Map<String, Map<int, double>> scoresByMonHoc = {};

    for (var doc in scoresQuery.docs) {
      var data = doc.data() as Map<String, dynamic>;
      var monHoc = data['monHoc'] as String;
      var heSo = data['heSo'] as int;
      var diem = data['diem'];

      // Convert diem to double if it's an int
      double diemValue;
      if (diem is int) {
        diemValue = diem.toDouble();
      } else if (diem is double) {
        diemValue = diem;
      } else {
        throw Exception('Invalid diem value');
      }

      if (!scoresByMonHoc.containsKey(monHoc)) {
        scoresByMonHoc[monHoc] = {};
      }
      scoresByMonHoc[monHoc]![heSo] = diemValue;
    }

    return scoresByMonHoc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KẾT QUẢ HỌC TẬP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Map<String, Map<int, double>>>(
        future: _futureScoresByMonHoc,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có điểm.'));
          } else {
            var scoresByMonHoc = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Môn học')),
                  DataColumn(label: Text('Điểm hệ số 1')),
                  DataColumn(label: Text('Điểm hệ số 2')),
                  DataColumn(label: Text('Điểm hệ số 3')),
                ],
                rows: scoresByMonHoc.keys.map((monHoc) {
                  var scores = scoresByMonHoc[monHoc]!;
                  return DataRow(
                    cells: [
                      DataCell(Text(monHoc)),
                      DataCell(Text(scores[1]?.toString() ?? '')),
                      DataCell(Text(scores[2]?.toString() ?? '')),
                      DataCell(Text(scores[3]?.toString() ?? '')),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
