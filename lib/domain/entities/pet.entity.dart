class PetEntity {
  final int id;
  final String name;
  final List<String> photoUrls;
  final String status;
  final List<PetTag>? tags;
  final PetCategory? category;

  PetEntity({
    required this.id,
    required this.name,
    required this.photoUrls,
    required this.status,
    this.tags,
    this.category,
  });
}

class PetTag {
  final int id;
  final String name;

  PetTag({required this.id, required this.name});
}

class PetCategory {
  final int id;
  final String name;

  PetCategory({required this.id, required this.name});
}
