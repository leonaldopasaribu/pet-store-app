import 'dart:io';

import '../../core/network/api_client.dart';
import '../../domain/entities/order.entity.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient apiClient;

  OrderRepositoryImpl({required this.apiClient});

  @override
  Future<OrderEntity> create(OrderEntity order) async {
    try {
      final orderModel = OrderModel(
        id: order.id,
        petId: order.petId,
        quantity: order.quantity,
        shipDate: order.shipDate,
        status: order.status,
        complete: order.complete,
      );

      final response = await apiClient.post(
        '/store/order',
        data: orderModel.toJson(),
      );

      if (response.statusCode == HttpStatus.ok) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }
}
