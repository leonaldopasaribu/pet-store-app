import '../../domain/entities/order.entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required int id,
    required int petId,
    required int quantity,
    required String shipDate,
    required String status,
    required bool complete,
  }) : super(
         id: id,
         petId: petId,
         quantity: quantity,
         shipDate: shipDate,
         status: status,
         complete: complete,
       );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      petId: json['petId'] ?? 0,
      quantity: json['quantity'] ?? 1,
      shipDate: json['shipDate'] ?? DateTime.now().toIso8601String(),
      status: json['status'] ?? 'placed',
      complete: json['complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'quantity': quantity,
      'shipDate': shipDate,
      'status': status,
      'complete': complete,
    };
  }
}
