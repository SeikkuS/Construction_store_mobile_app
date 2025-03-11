import 'dart:convert';

List<Products> productsFromJson(String str) =>
    List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

class Products {
  final String id;
  final String name;
  final List<dynamic> sizes;
  final String price;
  final String category;
  final String image;
  final List<String> imageList;
  final String description;
  final String title;
  final String oldPrice;

  Products({
    required this.id,
    required this.name,
    required this.sizes,
    required this.price,
    required this.category,
    required this.image,
    required this.imageList,
    required this.description,
    required this.title,
    required this.oldPrice,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    name: json["name"],
    sizes: json["sizes"],
    price: json["price"],
    category: json["category"],
    image: json["image"],
    imageList:
        json["imageList"] != null
            ? List<String>.from(
              json["imageList"],
            ) // Convert JSON list to List<String>
            : [json["image"]],
    description: json["description"],
    title: json["title"],
    oldPrice: json["oldPrice"],
  );
}
