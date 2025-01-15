class Model {
  final String id;
  final String name;

  Model(this.id, this.name);

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(json['name'], json['age']);
  }
}
