String formatPrice(num v) =>
    v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);

String formatQar(num v) => 'QAR ${formatPrice(v)}';

String modeLabel(String mode) {
  switch (mode.toLowerCase()) {
    case 'inperson':
      return 'In person';
    case 'online':
      return 'Online';
    case 'both':
      return 'Online & In person';
    default:
      return mode;
  }
}