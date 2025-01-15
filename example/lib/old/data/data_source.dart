import 'package:example/old/data/model.dart';

abstract class DataSource {
  Future<Model> getData(String param1, String param2, String param3);
}

class DataSourceImpl implements DataSource {
  @override
  Future<Model> getData(String param1, String param2, String param3) {
    return Future.value(Model.fromJson({
      'name': 'John Doe',
      'age': 30,
    }));
  }
}
