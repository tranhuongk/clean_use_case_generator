class UseCase {
  const UseCase({this.ignoreMethods = const [], this.injectable = true});

  final List<String> ignoreMethods;
  final bool injectable;
}

const usecase = UseCase();
