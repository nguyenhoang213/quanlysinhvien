// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Score {
  String? maSV;
  String? monHoc;
  int? heSo;
  double? diem;
  Score({
    this.maSV,
    this.monHoc,
    this.heSo,
    this.diem,
  });

  Score copyWith({
    String? maSV,
    String? monHoc,
    int? heSo,
    double? diem,
  }) {
    return Score(
      maSV: maSV ?? this.maSV,
      monHoc: monHoc ?? this.monHoc,
      heSo: heSo ?? this.heSo,
      diem: diem ?? this.diem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maSV': maSV,
      'monHoc': monHoc,
      'heSo': heSo,
      'diem': diem,
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      maSV: map['maSV'] != null ? map['maSV'] as String : null,
      monHoc: map['monHoc'] != null ? map['monHoc'] as String : null,
      heSo: map['heSo'] != null ? map['heSo'] as int : null,
      diem: map['diem'] != null ? map['diem'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) =>
      Score.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Score(maSV: $maSV, monHoc: $monHoc, heSo: $heSo, diem: $diem)';
  }

  @override
  bool operator ==(covariant Score other) {
    if (identical(this, other)) return true;

    return other.maSV == maSV &&
        other.monHoc == monHoc &&
        other.heSo == heSo &&
        other.diem == diem;
  }

  @override
  int get hashCode {
    return maSV.hashCode ^ monHoc.hashCode ^ heSo.hashCode ^ diem.hashCode;
  }
}
