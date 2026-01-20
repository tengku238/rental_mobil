class Car {
  final int id;
  final String brand;
  final String model;
  final double rating;
  final String transmission;
  final String description;
  final int pricePerDay;
  final String status;
  final String? imageUrl;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.rating,
    required this.transmission,
    required this.description,
    required this.pricePerDay,
    required this.status,
    this.imageUrl,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      rating: (json['rating'] as num).toDouble(),
      transmission: json['transmission'],
      description: json['description'],
      pricePerDay: json['price_per_day'],
      status: json['status'],
      imageUrl: json['image_url'],
    );
  }
}
