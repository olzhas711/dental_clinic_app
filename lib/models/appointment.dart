class Appointment {
  final String? userId;
  final String specialistName;
  final DateTime date;
  final String time;
  final String type; // Онлайн-консультация или очный прием

  Appointment({
    this.userId,
    required this.specialistName,
    required this.date,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'specialistName': specialistName,
      'date': date.toIso8601String(),
      'time': time,
      'type': type,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'specialistName': specialistName,
      'date': date.toIso8601String(),
      'time': time,
      'type': type,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      userId: json['userId'],
      specialistName: json['specialistName'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      type: json['type'],
    );
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      userId: map['userId'],
      specialistName: map['specialistName'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      type: map['type'],
    );
  }
}
