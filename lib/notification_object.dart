class NotificationObject {
  final int id;
  final String title;
  final String description;
  final DateTime dateTime;
  String? tag;
  bool isSent;

  NotificationObject({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.tag,
    this.isSent = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'isSent': isSent,
      };

  void markAsSent() {
    isSent = true;
  }

  factory NotificationObject.fromJson(Map<String, dynamic> json) {
    return NotificationObject(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      tag: json['tag'],
      isSent: json['isSent'],
    );
  }
}
