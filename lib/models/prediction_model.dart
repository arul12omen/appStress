class PredictionInput {
  final double study;
  final double extracurricular;
  final double sleep;
  final double social;
  final double physical;
  final double gpa;
  final int userId;

  PredictionInput({
    required this.study,
    required this.extracurricular,
    required this.sleep,
    required this.social,
    required this.physical,
    required this.gpa,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'study': study,
      'extracurricular': extracurricular,
      'sleep': sleep,
      'social': social,
      'physical': physical,
      'gpa': gpa,
      'user_id': userId,
    };
  }
}

class PredictionResult {
  final String prediction;

  PredictionResult({required this.prediction});

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(prediction: json['prediction']);
  }
}
