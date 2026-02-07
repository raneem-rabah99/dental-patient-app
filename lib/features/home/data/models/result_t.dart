import 'dart:convert';

class OrthoResult {
  final String upper;
  final String lower;
  final String finalResult;

  OrthoResult({
    required this.upper,
    required this.lower,
    required this.finalResult,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'upper': upper});
    result.addAll({'lower': lower});
    result.addAll({'finalResult': finalResult});

    return result;
  }

  factory OrthoResult.fromMap(Map<String, dynamic> map) {
    return OrthoResult(
      upper: map['upper'] ?? '',
      lower: map['lower'] ?? '',
      finalResult: map['finalResult'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrthoResult.fromJson(String source) =>
      OrthoResult.fromMap(json.decode(source));
}
