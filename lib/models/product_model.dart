class Product {
  final String name;
  final String description;
  final DateTime createDate;
  final int count;
  final int unit;

  Product(
      {required this.name,
      required this.description,
      required this.createDate,
      required this.count,
      required this.unit});
}

List<Product> productList = [
  Product(
      name: "ismim",
      description: "açıklama",
      createDate: DateTime(2024, 7, 02),
      count: 10,
      unit: 1),
  Product(
      name: "ismim",
      description: "açıklama",
      createDate: DateTime(2024, 7, 02),
      count: 10,
      unit: 1),
];
