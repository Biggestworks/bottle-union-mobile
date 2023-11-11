class CityModels {
  final String name;
  final String country_id;
  final String id;

  const CityModels(
      {required this.name, required this.country_id, required this.id});

  static List<CityModels> fetchListCity() {
    return [
      CityModels(name: 'Jakarta', country_id: '1', id: '1'),
      CityModels(name: 'Bandung', country_id: '1', id: '2'),
      CityModels(name: 'Kuala Lumpur', country_id: '2', id: '3'),
    ];
  }
}
