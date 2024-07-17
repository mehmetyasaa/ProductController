class Product {
  final String id;
  final String name;
  final String description;
  final String createDate; // Changed to String
  final int count;
  final String unit;
  final bool? status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.createDate,
    required this.count,
    required this.unit,
    this.status,
  });

  get price => null;
}
