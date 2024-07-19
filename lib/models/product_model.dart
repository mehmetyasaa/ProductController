class Product {
  final String id;
  final String name;
  final String description;
  final String createDate;
  final int count;
  final String unit;
  final bool? status;
  final String? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.createDate,
    required this.count,
    required this.unit,
    this.status,
    this.image,
  });

  get price => null;
}
