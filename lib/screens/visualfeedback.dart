/* 
    The MIT License
    Copyright February 1, 2022 Shawn Gilroy/Louisiana State University
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:covcopcomp_math_fact/models/record_ccc_mfacts.dart';
import 'package:flutter/material.dart';

import '../models/chartrow.dart';
import '../models/student.dart';
import '../shared/constants.dart';

class VisualFeedback extends StatelessWidget {
  final List<RecordMathFacts> currentPerformances;
  final Student currentStudent;

  const VisualFeedback({this.currentPerformances, this.currentStudent, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map out list
    List<ChartRow> chartRows = currentPerformances.map((perfs) {
      final DateTime dateStart = DateTime.parse(perfs.dateTimeStart);
      final isShowingAccuracy = currentStudent.metric == Metrics().Accuracy;

      final accuracy = (double.parse(perfs.nCorrectInitial.toString()) /
              double.parse(perfs.setSize)) *
          100;
      final minutes = double.parse(perfs.sessionDuration.toString()) / 60.0;
      final fluency = (double.parse(perfs.correctDigits.toString()) / minutes);

      final y = (isShowingAccuracy == true) ? accuracy : fluency;

      return ChartRow(dateStart, y);
    }).toList();

    chartRows.sort((a, b) {
      var aDate = a.timeStamp;
      var bDate = b.timeStamp;
      return -aDate.compareTo(bDate);
    });

    List<Series<ChartRow, DateTime>> seriesList = [
      charts.Series<ChartRow, DateTime>(
        id: currentStudent.metric,
        domainFn: (ChartRow row, _) => row.timeStamp,
        measureFn: (ChartRow row, _) => row.y,
        data: chartRows,
      )
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
      color: Colors.white,
      child: charts.TimeSeriesChart(seriesList,
          animate: true,
          primaryMeasureAxis: const charts.NumericAxisSpec(),
          domainAxis: const charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                      format: 'd', transitionFormat: 'MM/dd/yyyy')))),
    );
  }
}
