import 'package:flutter/foundation.dart';

class Lesson {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String content;
  final String cloudinaryFileId;
  final String status;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl;

  Lesson({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.content,
    required this.cloudinaryFileId,
    required this.status,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      cloudinaryFileId: json['cloudinary_file_id'] ?? '',
      status: json['status'] ?? 'inactive',
      orderIndex: json['order_index'] ?? 0,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'content': content,
      'cloudinary_file_id': cloudinaryFileId,
      'status': status,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  static DateTime _parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now();
    }

    try {
      return DateTime.parse(dateStr.replaceAll(' ', 'T'));
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return DateTime.now();
    }
  }

  @override
  String toString() => 'Lesson(id: $id, title: $title)';
}
