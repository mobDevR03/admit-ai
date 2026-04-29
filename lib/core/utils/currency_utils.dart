class CurrencyUtils {
  static String getSymbol(String country) {
    final c = country.toLowerCase();

    if (['uk', 'united kingdom'].contains(c)) {
      return '£';
    }

    if (c == 'switzerland') {
      return 'CHF';
    }

    // Все остальные твои европейские страны → евро
    if (['germany', 'france', 'finland'].contains(c)) {
      return '€';
    }

    if (['usa', 'united states'].contains(c)) {
      return '\$';
    }

    return '\$';
  }

  static String formatTuition({
    required String country,
    required int tuition,
  }) {
    final symbol = getSymbol(country);
    return '$symbol$tuition/year';
  }
}