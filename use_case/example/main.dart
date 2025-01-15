import 'package:use_case/use_case.dart';

@useCase
abstract class Repository {
  String getData(int param);
}
