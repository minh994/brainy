import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'lesson_model.dart';

class Category {
  final String id;
  final String title;
  final String description;
  final String status;
  final int orderIndex;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Lesson>? lessons;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.orderIndex,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.lessons,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Lesson>? parsedLessons;

    if (json.containsKey('lessons') && json['lessons'] != null) {
      parsedLessons = (json['lessons'] as List)
          .map((lessonJson) => Lesson.fromJson(lessonJson))
          .toList();
    }

    return Category(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'inactive',
      orderIndex: json['order_index'] ?? 0,
      progress: json['progress'] ?? 0,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      lessons: parsedLessons,
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'order_index': orderIndex,
      'progress': progress,
      'created_at': formatter.format(createdAt),
      'updated_at': formatter.format(updatedAt),
      if (lessons != null)
        'lessons': lessons!.map((lesson) => lesson.toJson()).toList(),
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
  String toString() => 'Category(id: $id, title: $title)';
}
