import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationApplicationModel {
  final String id;
  final String userId;
  final String entityType;
  final String? incorporationDocumentUrl;
  final String authorizedRepName;
  final DateTime authorizedRepDob;
  final String authorizedRepPosition;
  final String authorizedRepIdType;
  final List<BeneficialOwner> beneficialOwners;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationApplicationModel({
    required this.id,
    required this.userId,
    required this.entityType,
    this.incorporationDocumentUrl,
    required this.authorizedRepName,
    required this.authorizedRepDob,
    required this.authorizedRepPosition,
    required this.authorizedRepIdType,
    required this.beneficialOwners,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'entity_type': entityType,
    'incorporation_document_url': incorporationDocumentUrl,
    'authorized_rep_name': authorizedRepName,
    'authorized_rep_dob': Timestamp.fromDate(authorizedRepDob),
    'authorized_rep_position': authorizedRepPosition,
    'authorized_rep_id_type': authorizedRepIdType,
    'beneficial_owners': beneficialOwners.map((o) => o.toJson()).toList(),
    'status': status,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': Timestamp.fromDate(updatedAt),
  };

  factory OrganizationApplicationModel.fromJson(Map<String, dynamic> json) => OrganizationApplicationModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    entityType: json['entity_type'] as String,
    incorporationDocumentUrl: json['incorporation_document_url'] as String?,
    authorizedRepName: json['authorized_rep_name'] as String,
    authorizedRepDob: (json['authorized_rep_dob'] as Timestamp).toDate(),
    authorizedRepPosition: json['authorized_rep_position'] as String,
    authorizedRepIdType: json['authorized_rep_id_type'] as String,
    beneficialOwners: (json['beneficial_owners'] as List)
        .map((o) => BeneficialOwner.fromJson(o as Map<String, dynamic>))
        .toList(),
    status: json['status'] as String,
    createdAt: (json['created_at'] as Timestamp).toDate(),
    updatedAt: (json['updated_at'] as Timestamp).toDate(),
  );

  OrganizationApplicationModel copyWith({
    String? id,
    String? userId,
    String? entityType,
    String? incorporationDocumentUrl,
    String? authorizedRepName,
    DateTime? authorizedRepDob,
    String? authorizedRepPosition,
    String? authorizedRepIdType,
    List<BeneficialOwner>? beneficialOwners,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OrganizationApplicationModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    entityType: entityType ?? this.entityType,
    incorporationDocumentUrl: incorporationDocumentUrl ?? this.incorporationDocumentUrl,
    authorizedRepName: authorizedRepName ?? this.authorizedRepName,
    authorizedRepDob: authorizedRepDob ?? this.authorizedRepDob,
    authorizedRepPosition: authorizedRepPosition ?? this.authorizedRepPosition,
    authorizedRepIdType: authorizedRepIdType ?? this.authorizedRepIdType,
    beneficialOwners: beneficialOwners ?? this.beneficialOwners,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class BeneficialOwner {
  final String fullName;
  final double ownershipPercent;
  final String nationality;

  BeneficialOwner({
    required this.fullName,
    required this.ownershipPercent,
    required this.nationality,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'ownership_percent': ownershipPercent,
    'nationality': nationality,
  };

  factory BeneficialOwner.fromJson(Map<String, dynamic> json) => BeneficialOwner(
    fullName: json['full_name'] as String,
    ownershipPercent: (json['ownership_percent'] as num).toDouble(),
    nationality: json['nationality'] as String,
  );
}
