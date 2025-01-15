library use_case_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:use_case/use_case.dart';
import 'package:use_case_generator/src/class_generator.dart';
import 'package:use_case_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for use_case
class UseCaseGenerator extends GeneratorForAnnotation<UseCase> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    // Throw if annotation is used for a none class element
    throwIf(
      element is! ClassElement,
      '${element.name} is not a class element',
      element: element,
    );

    // Throw if annotation is used for an abstract class
    throwIf(
      !(element as ClassElement).isAbstract,
      '${element.name} is not an abstract class',
      element: element,
    );

    final useCase = UseCase(
      injectable: annotation.read('injectable').boolValue,
      ignoreMethods: annotation
          .read('ignoreMethods')
          .listValue
          .where((e) => e.toStringValue() != null)
          .map((e) => e.toStringValue()!)
          .toList(),
    );
    final methods = element.methods
        .where((e) => !useCase.ignoreMethods.contains(e.name))
        .toList();

    // Throw if annotation is used for an abstract class
    if (methods.isEmpty) {
      print(
        'use_case: ${(element).name} has not methods, no usecase classes generated!',
      );
      return '';
    } else {
      // Get methods and name of repository class
      final repoClassName = toPascalCase((element).name);

      // Get list of libraries to import
      final inputLibrary = await buildStep.inputLibrary;
      final libraries = [...inputLibrary.importedLibraries, inputLibrary];

      // Return generated usecases classes
      return ClassGenerator(
        methods,
        libraries,
        repoClassName,
        useCase,
      ).generate();
    }
  }
}
