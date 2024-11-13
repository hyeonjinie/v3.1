class GarakItem {
  final String name;
  final List<String> varieties;

  const GarakItem({required this.name, required this.varieties});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GarakItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          varieties == other.varieties;

  @override
  int get hashCode => name.hashCode ^ varieties.hashCode;
}
