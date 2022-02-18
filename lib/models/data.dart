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
