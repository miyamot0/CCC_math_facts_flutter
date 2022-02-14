class RecordMathFacts {
  final String tid;
  final String id;
  final String setSize;
  final String target;
  final String dateTimeStart;
  final String dateTimeEnd;
  final int errCount;
  final int nRetries;
  final int nCorrectInitial;
  final int delaySec;
  final int sessionDuration;

  RecordMathFacts(
      {this.tid,
      this.id,
      this.setSize,
      this.target,
      this.dateTimeStart,
      this.dateTimeEnd,
      this.errCount,
      this.nRetries,
      this.nCorrectInitial,
      this.delaySec,
      this.sessionDuration});
}
