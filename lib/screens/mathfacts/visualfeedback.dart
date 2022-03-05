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

import 'package:covcopcomp_math_fact/models/chartrow.dart';
import 'package:covcopcomp_math_fact/models/record_ccc_mfacts.dart';
import 'package:covcopcomp_math_fact/models/student.dart';
import 'package:covcopcomp_math_fact/shared/constants.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class VisualFeedback extends StatelessWidget {
  final List<RecordMathFacts> currentPerformances;
  final Student currentStudent;

  const VisualFeedback({this.currentPerformances, this.currentStudent, Key key}) : super(key: key);

  static _containerPadding() {
    return const EdgeInsets.all(10);
  }

  List<charts.ChartBehavior<DateTime>> _getChartFeatures() {
    return [
      charts.RangeAnnotation([
        charts.LineAnnotationSegment(currentStudent.aim, charts.RangeAnnotationAxisType.measure,
            endLabel: '${currentStudent.name}\'s Current Aim Level',
            labelAnchor: charts.AnnotationLabelAnchor.start,
            labelStyleSpec: const charts.TextStyleSpec(fontSize: 18),
            color: charts.MaterialPalette.red.shadeDefault),
      ], defaultLabelPosition: charts.AnnotationLabelPosition.inside),
      charts.ChartTitle('Name: ${currentStudent.name}',
          titleStyleSpec: const charts.TextStyleSpec(fontSize: 18),
          subTitle: 'Current Skill target: ${currentStudent.target}',
          subTitleStyleSpec: const charts.TextStyleSpec(fontSize: 16),
          behaviorPosition: charts.BehaviorPosition.top,
          titleOutsideJustification: charts.OutsideJustification.startDrawArea,
          innerPadding: 20),
      charts.ChartTitle('Date',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
      charts.ChartTitle('Current Skill target: ${currentStudent.metric}',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Map out list
    List<ChartRow> chartRows = currentPerformances.map((perfs) {
      final DateTime dateStart = DateTime.parse(perfs.dateTimeStart);
      final isShowingAccuracy = currentStudent.metric == Metrics.Accuracy;
      final minutes = double.parse(perfs.sessionDuration.toString()) / 60.0;

      final accuracy = (double.parse(perfs.nCorrectInitial.toString()) / double.parse(perfs.setSize)) * 100;
      final fluency = (double.parse(perfs.correctDigits.toString()) / minutes);

      final y = (isShowingAccuracy == true) ? accuracy : fluency;

      return ChartRow(dateStart, y);
    }).toList();

    chartRows.sort((a, b) {
      var aDate = a.timeStamp;
      var bDate = b.timeStamp;
      return -aDate.compareTo(bDate);
    });

    var seriesList = [
      charts.Series<ChartRow, DateTime>(
        id: currentStudent.metric,
        domainFn: (ChartRow row, _) => row.timeStamp,
        measureFn: (ChartRow row, _) => row.y,
        data: chartRows,
      ),
    ];

    return Scaffold(
        appBar: AppBar(title: const Text('Visual Feedback')),
        body: Container(
          padding: _containerPadding(),
          color: Colors.white,
          child: charts.TimeSeriesChart(
            seriesList,
            animate: true,
            behaviors: _getChartFeatures(),
            defaultRenderer: charts.LineRendererConfig(includePoints: true),
            domainAxis: const charts.DateTimeAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(labelStyle: charts.TextStyleSpec(fontSize: 20)),
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'MM/dd/yyyy'))),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(labelStyle: charts.TextStyleSpec(fontSize: 20)),
            ),
          ),
        ));
  }
}
