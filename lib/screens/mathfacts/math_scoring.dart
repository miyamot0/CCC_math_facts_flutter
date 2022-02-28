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
int calculateDigitsCorrect(
    String entry, String comparison, String trueOperator) {
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
