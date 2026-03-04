class Option {
  final String value;
  final String label;

  const Option({required this.value, required this.label});

  @override
  String toString() {
    return "Option(value: $value, label: $label)";
  }
}
