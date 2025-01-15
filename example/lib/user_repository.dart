import 'package:use_case/use_case.dart';

@usecase
abstract class UserRepository {
  Future<String> getData(
    String param1,
    int param2, [
    String? param3,
    String param4 = "String",
    int? param5 = 100,
    List<int>? param6 = const [1, 2, 3],
    Entity? param7 = const Entity("name", 1),
  ]);
  Future<String> getData2(
    String param1, {
    String? param2,
    required String? param3,
  });
  Future<String> getData3();
}

class Entity {
  final String name;
  final int age;

  const Entity(this.name, this.age);
}
