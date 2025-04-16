class Bill {
  int id;
  String name;
  DateTime dueDate;
  double amount;
  String status;

  Bill({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.amount,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'status': status,
    };
  }

}