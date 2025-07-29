class HistoryItem {
  final int id;
  final int userId;
  final String study;
  final String extracurricular;
  final String sleep;
  final String social;
  final String physical;
  final String gpa;
  final String result;
  final String createdAt;

  HistoryItem({
    required this.id,
    required this.userId,
    required this.study,
    required this.extracurricular,
    required this.sleep,
    required this.social,
    required this.physical,
    required this.gpa,
    required this.result,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      userId: json['user_id'],
      study: json['study'].toString(),
      extracurricular: json['extracurricular'].toString(),
      sleep: json['sleep'].toString(),
      social: json['social'].toString(),
      physical: json['physical'].toString(),
      gpa: json['gpa'].toString(),
      result: json['result'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
