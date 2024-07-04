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
      name: "product 0",
      description: "açıklama",
      createDate: DateTime(2024, 7, 02),
      count: 10,
      unit: 1),
  Product(
      name: "ürün 1",
      description: "açıklama",
      createDate: DateTime(2024, 7, 02),
      count: 10,
      unit: 1),
  Product(
      name: "denem 1",
      description: "açıklama",
      createDate: DateTime(2024, 7, 04),
      count: 10,
      unit: 1),
  Product(
      name: "denmee 3",
      description: "açıklama",
      createDate: DateTime(2024, 7, 03),
      count: 10,
      unit: 1),
  Product(
      name: "denmee 3",
      description: "açıklama",
      createDate: DateTime(2024, 6, 03),
      count: 10,
      unit: 1),
];
