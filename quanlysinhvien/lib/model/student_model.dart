// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  String? maSV;
  String? hoSV;
  String? tenSV;
  DateTime? ngaySinh;
  String? gioiTinh;
  String? sdt;
  String? email;
  String? queQuan;
  String? anh;
  String? lop;
  String? khoa;
  String? nganh;
  String? chuyenNganh;
  Student({
    this.maSV,
    this.hoSV,
    this.tenSV,
    this.ngaySinh,
    this.gioiTinh,
    this.sdt,
    this.email,
    this.queQuan,
    this.anh,
    this.lop,
    this.khoa,
    this.nganh,
    this.chuyenNganh,
  });

  Student copyWith({
    String? maSV,
    String? hoSV,
    String? tenSV,
    DateTime? ngaySinh,
    String? gioiTinh,
    String? sdt,
    String? email,
    String? queQuan,
    String? anh,
    String? lop,
    String? khoa,
    String? nganh,
    String? chuyenNganh,
  }) {
    return Student(
      maSV: maSV ?? this.maSV,
      hoSV: hoSV ?? this.hoSV,
      tenSV: tenSV ?? this.tenSV,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      gioiTinh: gioiTinh ?? this.gioiTinh,
      sdt: sdt ?? this.sdt,
      email: email ?? this.email,
      queQuan: queQuan ?? this.queQuan,
      anh: anh ?? this.anh,
      lop: lop ?? this.lop,
      khoa: khoa ?? this.khoa,
      nganh: nganh ?? this.nganh,
      chuyenNganh: chuyenNganh ?? this.chuyenNganh,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maSV': maSV,
      'hoSV': hoSV,
      'tenSV': tenSV,
      'ngaySinh': ngaySinh?.millisecondsSinceEpoch,
      'gioiTinh': gioiTinh,
      'sdt': sdt,
      'email': email,
      'queQuan': queQuan,
      'anh': anh,
      'lop': lop,
      'khoa': khoa,
      'nganh': nganh,
      'chuyenNganh': chuyenNganh,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      maSV: map['maSV'] != null ? map['maSV'] as String : null,
      hoSV: map['hoSV'] != null ? map['hoSV'] as String : null,
      tenSV: map['tenSV'] != null ? map['tenSV'] as String : null,
      ngaySinh: map['ngaySinh'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ngaySinh'] as int)
          : null,
      gioiTinh: map['gioiTinh'] != null ? map['gioiTinh'] as String : null,
      sdt: map['sdt'] != null ? map['sdt'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      queQuan: map['queQuan'] != null ? map['queQuan'] as String : null,
      anh: map['anh'] != null ? map['anh'] as String : null,
      lop: map['lop'] != null ? map['lop'] as String : null,
      khoa: map['khoa'] != null ? map['khoa'] as String : null,
      nganh: map['nganh'] != null ? map['nganh'] as String : null,
      chuyenNganh:
          map['chuyenNganh'] != null ? map['chuyenNganh'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(maSV: $maSV, hoSV: $hoSV, tenSV: $tenSV, ngaySinh: $ngaySinh, gioiTinh: $gioiTinh, sdt: $sdt, email: $email, queQuan: $queQuan, anh: $anh, lop: $lop, khoa: $khoa, nganh: $nganh, chuyenNganh: $chuyenNganh)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.maSV == maSV &&
        other.hoSV == hoSV &&
        other.tenSV == tenSV &&
        other.ngaySinh == ngaySinh &&
        other.gioiTinh == gioiTinh &&
        other.sdt == sdt &&
        other.email == email &&
        other.queQuan == queQuan &&
        other.anh == anh &&
        other.lop == lop &&
        other.khoa == khoa &&
        other.nganh == nganh &&
        other.chuyenNganh == chuyenNganh;
  }

  @override
  int get hashCode {
    return maSV.hashCode ^
        hoSV.hashCode ^
        tenSV.hashCode ^
        ngaySinh.hashCode ^
        gioiTinh.hashCode ^
        sdt.hashCode ^
        email.hashCode ^
        queQuan.hashCode ^
        anh.hashCode ^
        lop.hashCode ^
        khoa.hashCode ^
        nganh.hashCode ^
        chuyenNganh.hashCode;
  }
}
