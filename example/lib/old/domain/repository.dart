import 'package:example/old/domain/entity.dart';

abstract class Repository {
  Future<Entity> getData(
    String param1,
    String param2,
    String param3,
  );
}
