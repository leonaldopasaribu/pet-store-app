import '../entities/pet.entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> fetchAll({String? status});
  Future<PetEntity> fetchOne(int id);
}
