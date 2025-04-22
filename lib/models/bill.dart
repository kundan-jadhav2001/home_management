class Bill {
  int id;
  String name;
  DateTime dueDate;
  double amount;
  String status;
  String type;

  Bill({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.amount,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'status': status,
      'type': type,
    };
  }

}