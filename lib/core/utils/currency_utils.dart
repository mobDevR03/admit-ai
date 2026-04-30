class CurrencyUtils {
  static String getSymbol(String country) {
    final c = country.toLowerCase();

    const map = {
      'uk': '£',
      'united kingdom': '£',

      'switzerland': 'CHF',

      'germany': '€',
      'france': '€',
      'finland': '€',

      'usa': '\$',
      'united states': '\$',
      'canada': '\$',
      'australia': '\$',
    };

    return map[c] ?? '\$';
  }

  static String formatTuition({
    required String country,
    required int tuition,
  }) {
    final symbol = getSymbol(country);
    return '$symbol$tuition/year';
  }
}