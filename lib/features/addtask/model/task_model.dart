class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isExpiry;
  final DateTime? expiryDate;
  final String user;

  TaskModel( {
    required this.user,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isExpiry,
    this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "isExpiry": isExpiry,
      "user": user,

      "expiryDate": expiryDate?.toIso8601String(), // send ISO string to backend
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      user:json['user']??"",
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isExpiry: json['isExpiry'] ?? false,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
    );
  }
}
