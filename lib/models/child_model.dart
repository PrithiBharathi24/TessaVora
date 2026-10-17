/// Simple data model representing the child using Tessa Vora.
/// Kept intentionally minimal for a demo: name, age and preferred
/// learning language (English or Tamil).
class ChildModel {
  String name;
  int age;
  String language;

  ChildModel({
    required this.name,
    required this.age,
    required this.language,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'age': age,
        'language': language,
      };

  factory ChildModel.fromMap(Map<String, dynamic> map) => ChildModel(
        name: map['name'] ?? 'Little Learner',
        age: map['age'] ?? 5,
        language: map['language'] ?? 'English',
      );
}
