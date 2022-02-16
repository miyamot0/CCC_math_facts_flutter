class MathFactData {
  MathFactData(
      {this.additionSets,
      this.subtractionSets,
      this.multiplicationSets,
      this.divisionSets,
      this.addition,
      this.subtraction,
      this.multiplication,
      this.division});

  final int additionSets;
  final int subtractionSets;
  final int multiplicationSets;
  final int divisionSets;
  final List<List<String>> addition;
  final List<List<String>> subtraction;
  final List<List<String>> multiplication;
  final List<List<String>> division;

  factory MathFactData.fromJson(Map<String, dynamic> data) {
    final additionSets = data['AdditionSets'] as int;
    final List<List<String>> addn = List.from(data['Addition']).map((model) {
      return List<String>.from(model);
    }).toList();

    final subtractionSets = data['SubtractionSets'] as int;
    final List<List<String>> subn = List.from(data['Subtraction']).map((model) {
      return List<String>.from(model);
    }).toList();

    final multiplicationSets = data['MultiplicationSets'] as int;
    final List<List<String>> mltpn =
        List.from(data['Multiplication']).map((model) {
      return List<String>.from(model);
    }).toList();

    final divisionSets = data['DivisionSets'] as int;
    final List<List<String>> dvsn = List.from(data['Division']).map((model) {
      return List<String>.from(model);
    }).toList();

    return MathFactData(
        additionSets: additionSets,
        addition: addn,
        subtractionSets: subtractionSets,
        subtraction: subn,
        multiplicationSets: multiplicationSets,
        multiplication: mltpn,
        divisionSets: divisionSets,
        division: dvsn);
  }
}
