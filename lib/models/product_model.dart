import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl; // image_url field from Firestore
  final double price; // Assuming price is a number in Firestore
  final int quantity; // Assuming quantity is an integer in Firestore
  final DateTime createdAt; // Timestamp field
  final DateTime updatedAt; // Timestamp field

  Products({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Products from Firestore DocumentSnapshot
  factory Products.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Products(
      id: doc.id,
      name: data["name"] ?? "",
      category: data["category"] ?? "",
      description: data["description"] ?? "",
      imageUrl: data["image_url"] ?? "", // image_url field from Firestore
      price:
          data["price"]?.toDouble() ??
          0.0, // Assuming price is stored as a number
      quantity: data["quantity"] ?? 0, // Default to 0 if quantity is missing
      createdAt:
          (data["created_at"] as Timestamp)
              .toDate(), // Firestore Timestamp to DateTime
      updatedAt:
          (data["updated_at"] as Timestamp)
              .toDate(), // Firestore Timestamp to DateTime
    );
  }
}
