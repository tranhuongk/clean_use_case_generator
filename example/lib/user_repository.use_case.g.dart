// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: public_member_api_docs, unused_import, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, argument_type_not_assignable

// **************************************************************************
// UseCaseGenerator
// **************************************************************************

import 'package:injectable/injectable.dart';
import 'package:example/user_repository.dart';

/// `UserRepository`
///
/// ```dart
/// String param;
/// ```
@injectable
class GetDataUseCase {
  final UserRepository userRepository;

  const GetDataUseCase({
    required this.userRepository,
  });

  Future<String> call(GetDataUseCaseParams params) async {
    return userRepository.getData(
      params.param,
    );
  }
}

class GetDataUseCaseParams {
  final String param;

  const GetDataUseCaseParams({
    required this.param,
  });
}
