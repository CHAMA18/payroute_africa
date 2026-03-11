import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String accountType;
  final String? name;
  final String? role;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.accountType,
    this.name,
    this.role,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'account_type': accountType,
    'name': name,
    'role': role,
    'photo_url': photoUrl,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': Timestamp.fromDate(updatedAt),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'];
    final updatedAtValue = json['updated_at'];
    
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      accountType: json['account_type'] as String? ?? 'personal',
      name: json['name'] as String?,
      role: json['role'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: createdAtValue is Timestamp 
          ? createdAtValue.toDate() 
          : DateTime.now(),
      updatedAt: updatedAtValue is Timestamp 
          ? updatedAtValue.toDate() 
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? accountType,
    String? name,
    String? role,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    accountType: accountType ?? this.accountType,
    name: name ?? this.name,
    role: role ?? this.role,
    photoUrl: photoUrl ?? this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  
  /// Get display name from name or email
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    // Extract first part of email before @
    final emailParts = email.split('@');
    if (emailParts.isNotEmpty) {
      final username = emailParts[0];
      // Capitalize first letter
      return username.isEmpty ? 'User' : '${username[0].toUpperCase()}${username.substring(1)}';
    }
    return 'User';
  }
  
  /// Get user role or default
  String get displayRole {
    return role ?? 'User';
  }
  
  /// Get initials from name or email
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name!.substring(0, 1).toUpperCase();
    }
    return email.isNotEmpty ? email[0].toUpperCase() : 'U';
  }
}
