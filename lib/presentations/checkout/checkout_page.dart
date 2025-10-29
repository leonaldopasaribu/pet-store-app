import 'package:flutter/material.dart';
import '../../domain/entities/pet.entity.dart';
import '../../domain/entities/order.entity.dart';
import '../../data/order/order_model.dart';
import '../../data/order/order_repository_impl.dart';
import '../../core/network/api_client.dart';

class CheckoutPage extends StatefulWidget {
  final PetEntity pet;
  final int quantity;

  const CheckoutPage({super.key, required this.pet, required this.quantity});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final OrderRepositoryImpl _repository = OrderRepositoryImpl(
    apiClient: ApiClient(),
  );

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _error = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isLoading ? _buildLoadingView() : _buildCheckoutForm(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Processing your order...'),
        ],
      ),
    );
  }

  Widget _buildCheckoutForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderSummary(),
          const SizedBox(height: 16),
          if (_error.isNotEmpty) _buildErrorMessage(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Pet:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.pet.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Quantity:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '${widget.quantity}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _error,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitOrder,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(_isLoading ? 'Processing...' : 'Place Order'),
          ),
        ),
      ),
    );
  }

  void _submitOrder() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final OrderModel newOrder = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch,
        petId: widget.pet.id,
        quantity: widget.quantity,
        shipDate: DateTime.now().toIso8601String(),
        status: 'placed',
        complete: false,
      );

      final OrderEntity createdOrder = await _repository.create(newOrder);

      if (!mounted) return;

      _showOrderConfirmationDialog(createdOrder.id);
    } catch (e) {
      setState(() {
        _error = 'Failed to place order: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showOrderConfirmationDialog(int orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Placed Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order #$orderId has been placed.'),
              const SizedBox(height: 16),
              const Text(
                'Thank you for your purchase!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Back to Shop'),
            ),
          ],
        );
      },
    );
  }
}
