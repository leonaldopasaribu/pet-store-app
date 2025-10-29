import '../../domain/entities/pet.entity.dart';

class PetModel extends PetEntity {
  PetModel({
    required int id,
    required String name,
    required List<String> photoUrls,
    required String status,
    List<PetTagModel>? tags,
    PetCategoryModel? category,
  }) : super(
         id: id,
         name: name,
         photoUrls: photoUrls,
         status: status,
         tags: tags,
         category: category,
       );

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      photoUrls: json['photoUrls'] != null
          ? List<String>.from(json['photoUrls'])
          : [],
      status: json['status'] ?? 'unknown',
      tags: json['tags'] != null
          ? List<PetTagModel>.from(
              json['tags'].map((tag) => PetTagModel.fromJson(tag)),
            )
          : null,
      category: json['category'] != null
          ? PetCategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrls': photoUrls,
      'status': status,
      'tags': tags?.map((tag) => (tag as PetTagModel).toJson()).toList(),
      'category': category != null
          ? (category as PetCategoryModel).toJson()
          : null,
    };
  }
}

class PetTagModel extends PetTag {
  PetTagModel({required super.id, required super.name});

  factory PetTagModel.fromJson(Map<String, dynamic> json) {
    return PetTagModel(id: json['id'] ?? 0, name: json['name'] ?? 'Unknown');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class PetCategoryModel extends PetCategory {
  PetCategoryModel({required super.id, required super.name});

  factory PetCategoryModel.fromJson(Map<String, dynamic> json) {
    return PetCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
