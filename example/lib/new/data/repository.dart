import 'package:example/new/data/model.dart';
import 'package:use_case/use_case.dart';
import 'data_source.dart';

@usecase
abstract class Repository {
  Future<Model> getData(String param1, String param2, String param3);
}

class RepositoryImpl extends Repository {
  @override
  Future<Model> getData(String param1, String param2, String param3) async {
    return DataSourceImpl().getData(param1, param2, param3);
  }
}
