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

// Calculate total digits
int calculateDigitsTotal(String entry) {
  String operator = '';

  if (entry.contains('+')) {
    operator = '+';
  } else if (entry.contains('-')) {
    operator = '-';
  } else if (entry.contains('x')) {
    operator = 'x';
  } else if (entry.contains('/')) {
    operator = '/';
  }

  String prefixTotal = entry.split('=')[0];
  String prefixFirst = prefixTotal.split(operator)[0];
  String prefixSecond = prefixTotal.split(operator)[1];
  String suffixTotal = entry.split('=')[1];

  int digits = 0;

  digits += prefixFirst.trim().length;
  digits += prefixSecond.trim().length;
  digits += suffixTotal.trim().length;

  return digits;
}

// Calculate total digits
int calculateDigitsCorrect(String entry, String comparison, String trueOperator) {
  String operator = '';

  if (entry.contains('+')) {
    operator = '+';
  } else if (entry.contains('-')) {
    operator = '-';
  } else if (entry.contains('x')) {
    operator = 'x';
  } else if (entry.contains('/')) {
    operator = '/';
  }

  int digitsCorrect = 0;

  if (entry.isEmpty) return digitsCorrect;

  String entryPrefixInitial = entry.split('=')[0];
  String dsplyprefixInitial = comparison.split('=')[0];

  String entryPrefixFirst = entryPrefixInitial.split(operator)[0];
  String dsplyPrefixFirst = dsplyprefixInitial.split(trueOperator)[0];

  if (entryPrefixFirst != null && entryPrefixFirst.isNotEmpty) {
    // Initial prefix
    for (int i = 0; i < dsplyPrefixFirst.length; i++) {
      if ((entryPrefixFirst.length - 1) >= i) {
        if (entryPrefixFirst[i] == dsplyPrefixFirst[i]) {
          digitsCorrect++;
        }
      }
    }
  }

  if (entry.contains(trueOperator)) {
    String entryPrefixSecond = entryPrefixInitial.split(operator)[1];
    String dsplyPrefixSecond = dsplyprefixInitial.split(trueOperator)[1];

    if (entryPrefixSecond != null && entryPrefixSecond.isNotEmpty) {
      // Secondary prefix
      for (int i = 0; i < dsplyPrefixSecond.length; i++) {
        if ((entryPrefixSecond.length - 1) >= i) {
          if (entryPrefixSecond[i] == dsplyPrefixSecond[i]) {
            digitsCorrect++;
          }
        }
      }
    }
  }

  if (entry.contains('=')) {
    String entryPrefixTerminal = entry.split('=')[1];
    String dsplyprefixTerminal = comparison.split('=')[1];

    if (entryPrefixTerminal != null && entryPrefixTerminal.isNotEmpty) {
      // suffix
      for (int i = 0; i < dsplyprefixTerminal.length; i++) {
        if ((entryPrefixTerminal.length - 1) >= i) {
          if (entryPrefixTerminal[i] == dsplyprefixTerminal[i]) {
            digitsCorrect++;
          }
        }
      }
    }
  }

  return digitsCorrect;
}
