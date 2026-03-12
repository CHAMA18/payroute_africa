import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { send, receive, exchange, withdrawal }

enum TransactionStatus { completed, pending, processing, failed }

class TransactionModel {
  final String id;
  final String userId;
  final String recipientName;
  final String recipientId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String sourceRail;
  final String destinationRail;
  final double? feeSaved;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.recipientId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.sourceRail,
    required this.destinationRail,
    this.feeSaved,
    required this.createdAt,
    required this.updatedAt,
  });

  String get initials {
    final parts = recipientName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return recipientName.isNotEmpty ? recipientName[0].toUpperCase() : '?';
  }

  String get formattedAmount {
    final symbol = currency == 'NGN' ? '₦' : '\$';
    return '$symbol${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  String get formattedTime {
    final hour = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour;
    final period = createdAt.hour >= 12 ? 'PM' : 'AM';
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get typeLabel {
    switch (type) {
      case TransactionType.send:
        return 'Send';
      case TransactionType.receive:
        return 'Receive';
      case TransactionType.exchange:
        return 'Exchange';
      case TransactionType.withdrawal:
        return 'Withdraw';
    }
  }

  String get statusLabel {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      recipientName: json['recipientName'] ?? '',
      recipientId: json['recipientId'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.send,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'NGN',
      sourceRail: json['sourceRail'] ?? '',
      destinationRail: json['destinationRail'] ?? '',
      feeSaved: json['feeSaved']?.toDouble(),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'recipientId': recipientId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'sourceRail': sourceRail,
      'destinationRail': destinationRail,
      'feeSaved': feeSaved,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? recipientName,
    String? recipientId,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    String? currency,
    String? sourceRail,
    String? destinationRail,
    double? feeSaved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipientName: recipientName ?? this.recipientName,
      recipientId: recipientId ?? this.recipientId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      sourceRail: sourceRail ?? this.sourceRail,
      destinationRail: destinationRail ?? this.destinationRail,
      feeSaved: feeSaved ?? this.feeSaved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
