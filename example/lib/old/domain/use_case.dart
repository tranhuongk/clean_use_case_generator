import 'package:example/old/domain/entity.dart';
import 'package:example/old/domain/repository.dart';

class UseCase {
  final Repository repository;
  UseCase(this.repository);

  Future<Entity> call(UseCaseParams params) async {
    return repository.getData(
      params.param1,
      params.param2,
      params.param3,
    );
  }
}

class UseCaseParams {
  final String param1;
  final String param2;
  final String param3;

  UseCaseParams({
    required this.param1,
    required this.param2,
    required this.param3,
  });
}
