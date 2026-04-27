class CountryRequirements {
  final String country;
  final bool englishTestRequired;
  final List<String> englishTestOptions;
  final bool satOptional;
  final bool hskRequired;
  final List<String> hskOptions;

  const CountryRequirements({
    required this.country,
    this.englishTestRequired = false,
    this.englishTestOptions = const [],
    this.satOptional = false,
    this.hskRequired = false,
    this.hskOptions = const [],
  });
}

const List<CountryRequirements> countryRequirementsList = [
  CountryRequirements(
    country: 'USA',
    englishTestRequired: true,
    englishTestOptions: ['IELTS', 'TOEFL', 'Duolingo English Test'],
    satOptional: true,
  ),

  CountryRequirements(
    country: 'China',
    hskRequired: true,
    hskOptions: ['HSK 4', 'HSK 5', 'HSK 6'],
  ),
];

CountryRequirements? getCountryRequirements(String country) {
  try {
    return countryRequirementsList.firstWhere(
      (item) => item.country == country,
    );
  } catch (_) {
    return null;
  }
}