import '../entities/order.entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> create(OrderEntity order);
}
