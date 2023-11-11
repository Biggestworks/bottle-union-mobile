class CountryModels {
  final String name;
  final String id;

  const CountryModels({required this.id, required this.name});

  static List<CountryModels> listCountry() {
    return [
      CountryModels(id: '1', name: 'Indonesia'),
      CountryModels(id: '2', name: 'Malaysia'),
    ];
  }
}
