import 'package:use_case/use_case.dart';

@UseCase(ignoreMethods: ['getData2'])
abstract class UserRepository {
  Future<String> getData(String param);
  Future<String> getData2(String param);
}
