class BranchModels {
  final String name;
  final String id;
  final String city_id;

  const BranchModels(
      {required this.name, required this.id, required this.city_id});

  static List<BranchModels> fetchBranch() {
    return [
      BranchModels(name: 'Store Jakarta timur', id: '1', city_id: '1'),
      BranchModels(name: 'Store Jakarta Pusat', id: '2', city_id: '1'),
      BranchModels(name: 'Store Bandung Barat', id: '3', city_id: '2'),
      BranchModels(name: 'Store Kuala Lumpur 1', id: '4', city_id: '3')
    ];
  }
}
