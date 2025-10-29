import 'dart:io';

import '../../core/network/api_client.dart';
import '../../domain/entities/pet.entity.dart';
import '../../domain/repositories/pet_repository.dart';
import 'pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final ApiClient apiClient;

  PetRepositoryImpl({required this.apiClient});

  @override
  Future<List<PetEntity>> fetchAll({String? status}) async {
    try {
      final response = await apiClient.get(
        '/pet/findByStatus',
        queryParameters: {'status': status ?? 'available'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> petList = response.data;
        return petList.map((json) => PetModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      throw Exception('Failed to fetch pets: ${e.toString()}');
    }
  }

  @override
  Future<PetEntity> fetchOne(int id) async {
    try {
      final response = await apiClient.get('/pet/$id');

      if (response.statusCode == HttpStatus.ok) {
        return PetModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load pet details');
      }
    } catch (e) {
      throw Exception('Failed to fetch pet details: ${e.toString()}');
    }
  }
}
