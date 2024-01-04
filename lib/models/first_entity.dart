import 'dart:convert';

class FirstEntity {
  int? id;
  final String name;
  final String description;
  final int secondEntityId;
  FirstEntity({
    this.id,
    required this.name,
    required this.description,
    required this.secondEntityId,
  });

  FirstEntity copyWith({
    int? id,
    String? name,
    String? description,
    int? secondEntityId,
  }) {
    return FirstEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      secondEntityId: secondEntityId ?? this.secondEntityId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'secondEntityId': secondEntityId,
    };
  }

  factory FirstEntity.fromMap(Map<String, dynamic> map) {
    return FirstEntity(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
      secondEntityId: map['secondEntityId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FirstEntity.fromJson(String source) =>
      FirstEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FirstEntity(id: $id, name: $name, description: $description, secondEntityId: $secondEntityId)';
  }

  @override
  bool operator ==(covariant FirstEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.secondEntityId == secondEntityId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        secondEntityId.hashCode;
  }
}
