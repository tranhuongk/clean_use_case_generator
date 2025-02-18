import 'package:analyzer/dart/element/element.dart';
import 'package:use_case/use_case.dart';
import 'package:use_case_generator/src/utils.dart';

/// Generate usecase classes from repository class methods
class ClassGenerator {
  final StringBuffer _stringBuffer = StringBuffer();

  /// Methods of the repository class
  final List<MethodElement> methods;

  /// Libraries to generate import dependencies
  final List<LibraryElement> libraries;

  /// Name of the repository class
  final String repoClassName;

  /// UseCase config
  final UseCase useCase;

  /// Pass generation parameters
  ClassGenerator(
    this.methods,
    this.libraries,
    this.repoClassName,
    this.useCase,
  );

  void _write(Object obj) => _stringBuffer.write(obj);

  void _writeln([Object? obj]) => _stringBuffer.writeln(obj);

  void _newLine() => _stringBuffer.writeln();

  /// Generate output [String] with usecase classes from methods
  String generate() {
    if (useCase.injectable) {
      _writeln("import 'package:injectable/injectable.dart';");
    }
    // Generate import for each library/dependency in repository file
    for (var library in libraries) {
      final libraryName = library.source.uri;

      // Do not generate dart core and repo case imports
      if (!_isCoreDartTypeOrUseCase(libraryName)) {
        _writeln("import '$libraryName';");
      }
    }

    // Generate usecase class for each method in the repository
    for (var method in methods) {
      _generateUsecaseClassFromMethod(method);
    }

    // Return generated code
    return _stringBuffer.toString();
  }

  /// Generate main usecase class
  void _generateUsecaseClassFromMethod(MethodElement methodElement) {
    // Name of the method
    final methodName = methodElement.name;

    // Pascal case and suffix - UseCase
    final methodClassName = _methodUseCaseClassName(methodName);

    // Append suffix -Params to the name of the class method
    final repoParamsClassName = _repoParamsClassName(methodClassName);

    // Method configuration variables
    final methodParameters = methodElement.parameters;
    final genericType = _repoMethodGenericType(methodElement);
    final paramsGenericType =
        _repoParamsGenericType(methodElement, methodParameters);
    final hasMethodParameters = methodParameters.isNotEmpty;
    final methodReturnType =
        methodElement.returnType.getDisplayString(withNullability: true);
    final isMethodAsync = methodElement.returnType.isDartAsyncFuture;
    final paramsDefinitions = _repoParamsDefinition(methodParameters);
    final documentationComment = _documentationComment(paramsDefinitions);

    // 0. Documentation comment
    for (var c in documentationComment) {
      _writeln(c);
    }

    // 1. Injection
    if (useCase.injectable) _writeln('@injectable');

    // 2. Class definition
    _writeln('class $methodClassName {');

    // 3. Inject repo class as parameter
    _writeln('final $repoClassName $_repoClassNameParameter;');
    _newLine();

    // 4. Const class constructor
    _writeln('const $methodClassName(this.$_repoClassNameParameter);');

    // 5. Required repo class parameter
    // _writeln('');

    // 6. Close constructor
    // _writeln(');');
    _newLine();

    // 7. Defintion of 'call' function
    _write(methodReturnType);
    _write(' call$genericType(');
    if (hasMethodParameters) {
      _write('$repoParamsClassName$paramsGenericType params');
    }
    _write(') ');
    _writeln(isMethodAsync ? 'async {' : '{');

    // 8. 'call' function body
    _writeln('return $_repoClassNameParameter.$methodName(');
    for (var parameter in methodParameters) {
      final parameterName = parameter.name;
      _writeln([
        if (parameter.isNamed) parameterName,
        'params.$parameterName,',
      ].join(':'));
    }
    _writeln(');');

    // 8. Close 'call' function definition
    _writeln('}');

    // 9. Close usecase class
    _writeln('}');
    _newLine();

    // 10. Generate params class
    if (hasMethodParameters) {
      _generateParamsClass(
        repoParamsClassName,
        paramsDefinitions,
        methodParameters,
        paramsGenericType,
      );
    }
  }

  /// Generate params class used as usecase class parameters
  void _generateParamsClass(
    String repoParamsClassName,
    List<String> paramsDefinitions,
    List<ParameterElement> parameters,
    String genericType,
  ) {
    // 1. Class definition
    _writeln('class $repoParamsClassName$genericType {');

    // 2. Class parameters from method definition
    for (var param in paramsDefinitions) {
      _writeln(param);
    }
    _newLine();

    // 3. Class constructor
    _writeln('const $repoParamsClassName ({');

    // 4. Required parameters
    for (var parameter in parameters) {
      final parameterName = parameter.name;
      _writeln([
        if (parameter.isRequired) 'required',
        'this.$parameterName',
        if (parameter.hasDefaultValue) '= ${parameter.defaultValueCode}',
        ','
      ].join(' '));
    }

    // 5. Close constructor
    _writeln('});');

    // 6. Close params class
    _writeln('}');
  }

  /// Name of the repo source class with first lower case letter
  String get _repoClassNameParameter => toLowerCamelCase(repoClassName);

  /// Append suffix `UseCase` to pascal case method name
  String _methodUseCaseClassName(String methodName) =>
      '${toPascalCase(methodName)}UseCase';

  /// Parameters class for the usecase, given method name **already pascal case**
  String _repoParamsClassName(String methodName) => '${methodName}Params';

  /// Build list with all parameters definitions for params class
  List<String> _repoParamsDefinition(List<ParameterElement> parameters) {
    List<String> definitions = [];
    for (var parameter in parameters) {
      final parameterName = parameter.name;
      final parameterReturnType =
          parameter.type.getDisplayString(withNullability: true);
      definitions.add('final $parameterReturnType $parameterName;');
    }
    return definitions;
  }

  /// Add all generic type to params method definition
  String _repoMethodGenericType(MethodElement methodElement) =>
      methodElement.typeParameters.isEmpty
          ? ''
          : '<${methodElement.typeParameters.join(', ')}>';

  /// Add only the generic types necessary to params class definition
  String _repoParamsGenericType(
    MethodElement methodElement,
    List<ParameterElement> methodParameters,
  ) {
    // Check which generic types are actually used by for the parameters
    // Some parameters may be only used as return types, so they are not needed in the params class
    final genericParamsType = methodElement.typeParameters
        .map(
          (typeParam) => typeParam.name,
        )
        .where(
          (genericName) => methodParameters
              .map(
                (paramElement) => paramElement.type.getDisplayString(
                  withNullability: false,
                ),
              )
              .contains(genericName),
        );
    return genericParamsType.isEmpty ? '' : '<${genericParamsType.join(', ')}>';
  }

  /// Documentation comment with name of repository and parameters in input
  List<String> _documentationComment(List<String> paramsDefinitions) {
    List<String> comment = [];
    comment.add('/// `$repoClassName`');
    if (paramsDefinitions.isNotEmpty) {
      comment.add('///');
      comment.add('/// ```dart');
      for (var param in paramsDefinitions) {
        comment.add('/// ${param.replaceAll('final ', '')}');
      }
      comment.add('/// ```');
    }
    return comment;
  }

  /// Check if library import is `dart:core` of `use_case/use_case.dart`
  bool _isCoreDartTypeOrUseCase(Uri uri) =>
      uri.toString().startsWith('dart') || uri.toString().contains('use_case');
}
