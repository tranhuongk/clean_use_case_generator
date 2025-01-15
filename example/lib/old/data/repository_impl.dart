import 'package:example/old/data/data_source.dart';
import 'package:example/old/data/model.dart';
import 'package:example/old/domain/repository.dart';

class RepositoryImpl extends Repository {
  @override
  Future<Model> getData(String param1, String param2, String param3) async {
    return DataSourceImpl().getData(param1, param2, param3);
  }
}
