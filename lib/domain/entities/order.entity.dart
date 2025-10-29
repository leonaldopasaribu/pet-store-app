class OrderEntity {
  final int id;
  final int petId;
  final int quantity;
  final String shipDate;
  final String status;
  final bool complete;

  OrderEntity({
    required this.id,
    required this.petId,
    required this.quantity,
    required this.shipDate,
    required this.status,
    required this.complete,
  });
}
