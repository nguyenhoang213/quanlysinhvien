import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quanlysinhvien/model/student_model.dart';

class StudentInfoScreen extends StatefulWidget {
  final String? email;
  const StudentInfoScreen({super.key, this.email});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  String? _email;
  Student? sinhVien;
  TextStyle h1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    fetchStudentInfo();
  }

  Future<void> fetchStudentInfo() async {
    final db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot =
        await db.collection("SinhVien").where('email', isEqualTo: _email).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        sinhVien =
            Student.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("THÔNG TIN SINH VIÊN",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: sinhVien != null
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 216, 216, 216)),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                          width: MediaQuery.of(context).size.width * 4 / 5,
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage("${sinhVien!.anh}"),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Text("${sinhVien!.hoSV} ${sinhVien!.tenSV}",
                                  style: h1),
                              RichText(
                                text: TextSpan(
                                    text: "Mã Sinh Viên: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.maSV}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(child: Text("Thông tin chung", style: h1)),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 216, 216, 216)),
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Lớp: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.lop}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Ngành: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.nganh}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Chuyên ngành: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.chuyenNganh}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Khoa: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.khoa}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(child: Text("Thông tin cá nhân", style: h1)),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 216, 216, 216)),
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Ngày sinh: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.ngaySinh}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Giới tính: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.gioiTinh}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Số điện thoại: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.sdt}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: RichText(
                                text: TextSpan(
                                    text: "Email: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "${sinhVien!.email}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 3,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
      resizeToAvoidBottomInset: false,
    );
  }
}
