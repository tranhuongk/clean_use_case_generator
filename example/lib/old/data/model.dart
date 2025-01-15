import 'package:example/old/domain/entity.dart';

class Model extends Entity {
  Model(super.name, super.age);

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(json['name'], json['age']);
  }
}
