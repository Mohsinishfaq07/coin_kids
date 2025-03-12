extension NumberFormatting on num {
  String toMoneyFormat({bool showSymbol = true}) {
    // Convert to double and round to 2 decimal places
    final double value = double.parse(this.toStringAsFixed(2));

    // Split into whole and decimal parts
    final parts = value.toString().split('.');
    var whole = parts[0];
    var decimal = parts.length > 1 ? parts[1] : '00';

    // Add leading zeros to ensure 2 digits minimum for whole numbers
    whole = whole.padLeft(2, '0');

    // Ensure decimal part has exactly 2 digits
    if (decimal.length < 2) {
      decimal = decimal.padRight(2, '0');
    } else if (decimal.length > 2) {
      decimal = decimal.substring(0, 2);
    }

    if (showSymbol)
      return '€$whole.$decimal';
    else
      return '$whole.$decimal';
  }
}
