import 'package:use_case/use_case.dart';

@usecase
abstract class Repository {
  String getData(int param);
}
