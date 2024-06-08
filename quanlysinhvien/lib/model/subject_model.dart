// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Subject {
  String? maMH;
  int? tinChi;
  String? tenMH;
  Subject({
    this.maMH,
    this.tinChi,
    this.tenMH,
  });

  Subject copyWith({
    String? maMH,
    int? tinChi,
    String? tenMH,
  }) {
    return Subject(
      maMH: maMH ?? this.maMH,
      tinChi: tinChi ?? this.tinChi,
      tenMH: tenMH ?? this.tenMH,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maMH': maMH,
      'tinChi': tinChi,
      'tenMH': tenMH,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      maMH: map['maMH'] != null ? map['maMH'] as String : null,
      tinChi: map['tinChi'] != null ? map['tinChi'] as int : null,
      tenMH: map['tenMH'] != null ? map['tenMH'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Subject(maMH: $maMH, tinChi: $tinChi, tenMH: $tenMH)';

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;

    return other.maMH == maMH && other.tinChi == tinChi && other.tenMH == tenMH;
  }

  @override
  int get hashCode => maMH.hashCode ^ tinChi.hashCode ^ tenMH.hashCode;
}
