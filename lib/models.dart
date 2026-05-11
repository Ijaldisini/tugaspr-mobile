class UserModel {
  final int id;
  final String name;
  final String username;

  UserModel({
    required this.id, 
    required this.name, 
    required this.username
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({
    required this.token, 
    required this.user
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class ProductModel {
  final int? id;
  final String name;
  final num price; 
  final String description;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    num parsedPrice = 0;
    if (json['price'] != null) {
      if (json['price'] is String) {
        parsedPrice = num.tryParse(json['price']) ?? 0;
      } else if (json['price'] is num) {
        parsedPrice = json['price'];
      }
    }

    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      price: parsedPrice,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}