class Product {
  final String id;
  final String name;
  final String description;
  final int count;
  final String createDate;
  final String unit;
  final String? image; // Optional image field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.count,
    required this.createDate,
    required this.unit,
    this.image, // Initialize image as optional
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      count: json['count'],
      createDate: json['createDate'],
      unit: json['unit'],
      image: json['image'], // Parse image from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'count': count,
      'createDate': createDate,
      'unit': unit,
      'image': image, // Include image in JSON
    };
  }
}
