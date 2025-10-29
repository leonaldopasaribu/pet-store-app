import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pet.entity.dart';
import '../../data/pet/pet_repository_impl.dart';
import '../../core/network/api_client.dart';
import '../checkout/checkout_page.dart';

class PetDetailPage extends StatefulWidget {
  final int petId;

  const PetDetailPage({super.key, required this.petId});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final PetRepositoryImpl _repository = PetRepositoryImpl(
    apiClient: ApiClient(),
  );

  PetEntity? _pet;
  bool _isLoading = true;
  String _error = '';
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
  }

  Future<void> _loadPetDetails() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final pet = await _repository.fetchOne(widget.petId);
      setState(() {
        _pet = pet;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load pet details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pet?.name ?? 'Pet Details')),
      body: _buildBody(),
      bottomNavigationBar: _pet != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPetDetails,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_pet == null) {
      return const Center(child: Text('Pet not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSlider(),
          const SizedBox(height: 20),
          Text(_pet!.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildCategoryAndStatus(),
          const SizedBox(height: 16),
          _buildQuantitySelector(),
          const SizedBox(height: 24),
          if (_pet!.tags != null && _pet!.tags!.isNotEmpty) _buildTagsSection(),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    const String fallbackImageUrl =
        'https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1740';

    final List<String> images = _pet!.photoUrls.isNotEmpty
        ? _pet!.photoUrls
        : [fallbackImageUrl];

    return SizedBox(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: images.first,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl: fallbackImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),

            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.pets, size: 80, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAndStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                _pet!.category?.name ?? 'Uncategorized',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(_pet!.status),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _pet!.status.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'sold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text('Quantity:'),
        const SizedBox(width: 16),
        IconButton(
          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '$_quantity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        IconButton(
          onPressed: _quantity < 10 ? () => setState(() => _quantity++) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags:', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _pet!.tags!.map((tag) {
            return Chip(
              label: Text(tag.name),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _pet!.status.toLowerCase() == 'available'
              ? () => _proceedToCheckout()
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Proceed to Checkout'),
          ),
        ),
      ),
    );
  }

  void _proceedToCheckout() {
    if (_pet == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(pet: _pet!, quantity: _quantity),
      ),
    );
  }
}
