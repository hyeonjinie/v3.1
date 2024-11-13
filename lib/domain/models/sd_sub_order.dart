class SubOrder {
  final int quantity;
  final int amount;
  final dynamic deliveryDate; // Can be Timestamp or String
  final dynamic completedDate; // Can be Timestamp or String
  final String address;
  final String status;
  final String assignedAdmin;

  SubOrder({
    required this.quantity,
    required this.amount,
    required this.deliveryDate,
    required this.completedDate,
    required this.address,
    required this.status,
    required this.assignedAdmin,
  });

  factory SubOrder.fromMap(Map<String, dynamic> map) {
    return SubOrder(
      quantity: map['quantity'] ?? 0,
      amount: map['amount'] ?? 0,
      deliveryDate: map['deliveryDate'],
      completedDate: map['completedDate'],
      address: map['address'] ?? '',
      status: map['status'] ?? '',
      assignedAdmin: map['assignedAdmin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'amount': amount,
      'deliveryDate': deliveryDate,
      'completedDate': completedDate,
      'address': address,
      'status': status,
      'assignedAdmin': assignedAdmin,
    };
  }
}
