class MathFactData {
  MathFactData({this.additionSets, this.addition});

  final int additionSets;
  final List<List<String>> addition;

  factory MathFactData.fromJson(Map<String, dynamic> data) {
    final additionSets = data['AdditionSets'] as int;

    final List<dynamic> prelist = List.from(data['Addition']);

    final List<List<String>> list = prelist.map((model) {
      return List<String>.from(model);
    }).toList();

    return MathFactData(additionSets: additionSets, addition: list);
  }
}
