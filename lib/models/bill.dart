class Bill {
  int id;
  String name;
  DateTime dueDate;
  double amount;
  String status;
  String type;
  String? reminder;

  Bill({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.amount,
    required this.type,
    required this.status,
    required this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'status': status,
      'type': type,
      'reminder': reminder,
    };
  }

}