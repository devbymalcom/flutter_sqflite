import 'dart:convert';

class SecondEntity {
  int? id;
  String name;
  String description;
  SecondEntity({
    this.id,
    required this.name,
    required this.description,
  });

  SecondEntity copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return SecondEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory SecondEntity.fromMap(Map<String, dynamic> map) {
    return SecondEntity(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondEntity.fromJson(String source) =>
      SecondEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SecondEntity(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant SecondEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
