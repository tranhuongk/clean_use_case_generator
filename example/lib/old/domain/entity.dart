class Entity {
  final String id;
  final String name;

  Entity(this.id, this.name);

  @override
  String toString() {
    return [id, name].join(' ');
  }

  String display() {
    return 'Entity: $name';
  }

  String displayId() {
    return 'Entity ID: $id';
  }
}
