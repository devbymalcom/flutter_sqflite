import 'dart:convert';

class ThirdEntity {
  int? id;
  String name;
  String description;
  ThirdEntity({
    this.id,
    required this.name,
    required this.description,
  });

  ThirdEntity copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return ThirdEntity(
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

  factory ThirdEntity.fromMap(Map<String, dynamic> map) {
    return ThirdEntity(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThirdEntity.fromJson(String source) =>
      ThirdEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SecondEntity(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant ThirdEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
