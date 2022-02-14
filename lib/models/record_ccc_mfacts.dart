class RecordMathFacts {
  final String id;
  final String name;
  final String setSize;
  final String target;
  final String dateTimeStart;
  final String dateTimeEnd;
  final int errCount;
  final int nRetries;
  final int nCorrectInitial;

  RecordMathFacts(
      {this.id,
      this.name,
      this.setSize,
      this.target,
      this.dateTimeStart,
      this.dateTimeEnd,
      this.errCount,
      this.nRetries,
      this.nCorrectInitial});
}
