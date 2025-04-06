import 'package:flutter/material.dart';

class Example {
  final String id;
  final String senseId;
  final String cf;
  final String x;
  final String? createdAt;
  final String? updatedAt;

  Example({
    required this.id,
    required this.senseId,
    required this.cf,
    required this.x,
    this.createdAt,
    this.updatedAt,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json['id'] ?? '',
      senseId: json['sense_id'] ?? '',
      cf: json['cf'] ?? '',
      x: json['x'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sense_id': senseId,
      'cf': cf,
      'x': x,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Sense {
  final String id;
  final String wordId;
  final String definition;
  final List<Example> examples;
  final String? createdAt;
  final String? updatedAt;

  Sense({
    required this.id,
    required this.wordId,
    required this.definition,
    required this.examples,
    this.createdAt,
    this.updatedAt,
  });

  factory Sense.fromJson(Map<String, dynamic> json) {
    List<Example> examples = [];
    if (json['examples'] != null) {
      examples = (json['examples'] as List)
          .map((example) => Example.fromJson(example))
          .toList();
    }

    return Sense(
      id: json['id'] ?? '',
      wordId: json['word_id'] ?? '',
      definition: json['definition'] ?? '',
      examples: examples,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word_id': wordId,
      'definition': definition,
      'examples': examples.map((example) => example.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Word {
  final String id;
  final String? lessonId;
  final String word;
  final String pos;
  final String? phonetic;
  final String? phoneticText;
  final String? phoneticAm;
  final String? phoneticAmText;
  final String? audioId;
  final String? imageId;
  final String? createdAt;
  final String? updatedAt;
  final String? audioUrl;
  final String? imageUrl;
  final String? lessonTitle;
  final List<Sense> senses;
  final bool isFavorite;
  final DateTime? lastReviewed;
  final int proficiencyLevel;

  Word({
    required this.id,
    this.lessonId,
    required this.word,
    required this.pos,
    this.phonetic,
    this.phoneticText,
    this.phoneticAm,
    this.phoneticAmText,
    this.audioId,
    this.imageId,
    this.createdAt,
    this.updatedAt,
    this.audioUrl,
    this.imageUrl,
    this.lessonTitle,
    required this.senses,
    this.isFavorite = false,
    this.lastReviewed,
    this.proficiencyLevel = 0,
  });

  // Color mapping for parts of speech
  final Map<String, Color> _posColors = {
    // Full words
    'noun': Colors.purple,
    'verb': Colors.blue,
    'adjective': Colors.green,
    'adverb': Colors.amber,
    'preposition': Colors.orange,
    'conjunction': Colors.red,
    'pronoun': Colors.teal,
    'determiner': Colors.brown,
    'interjection': Colors.deepPurple,

    // Abbreviations for backward compatibility
    'n': Colors.purple,
    'v': Colors.blue,
    'adj': Colors.green,
    'adv': Colors.amber,
    'prep': Colors.orange,
    'conj': Colors.red,
    'pron': Colors.teal,
    'det': Colors.brown,
    'interj': Colors.deepPurple,
  };

  // Get color for part of speech
  Color getPosColor() {
    // First try direct match with the lowercase pos
    final normalizedPos = pos.toLowerCase().trim();
    if (_posColors.containsKey(normalizedPos)) {
      return _posColors[normalizedPos]!;
    }

    // Then try matching only the first part (e.g., "noun (plural)" → "noun")
    final firstPart = normalizedPos.split(' ').first.split('.').first;
    if (_posColors.containsKey(firstPart)) {
      return _posColors[firstPart]!;
    }

    // Default color if no match
    return Colors.grey;
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    List<Sense> senses = [];
    if (json['senses'] != null) {
      senses = (json['senses'] as List)
          .map((sense) => Sense.fromJson(sense))
          .toList();
    }

    return Word(
      id: json['id'] ?? '',
      lessonId: json['lesson_id'],
      word: json['word'] ?? '',
      pos: json['pos'] ?? '',
      phonetic: json['phonetic'],
      phoneticText: json['phonetic_text'],
      phoneticAm: json['phonetic_am'],
      phoneticAmText: json['phonetic_am_text'],
      audioId: json['audio_id'],
      imageId: json['image_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      audioUrl: json['audio_url'],
      imageUrl: json['image_url'],
      lessonTitle: json['lesson_title'],
      senses: senses,
      isFavorite: json['is_favorite'] ?? false,
      lastReviewed: json['last_reviewed'] != null
          ? DateTime.parse(json['last_reviewed'])
          : null,
      proficiencyLevel: json['proficiency_level'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'word': word,
      'pos': pos,
      'phonetic': phonetic,
      'phonetic_text': phoneticText,
      'phonetic_am': phoneticAm,
      'phonetic_am_text': phoneticAmText,
      'audio_id': audioId,
      'image_id': imageId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'audio_url': audioUrl,
      'image_url': imageUrl,
      'lesson_title': lessonTitle,
      'senses': senses.map((sense) => sense.toJson()).toList(),
      'is_favorite': isFavorite,
      'last_reviewed': lastReviewed?.toIso8601String(),
      'proficiency_level': proficiencyLevel,
    };
  }

  Word copyWith({
    String? id,
    String? lessonId,
    String? word,
    String? pos,
    String? phonetic,
    String? phoneticText,
    String? phoneticAm,
    String? phoneticAmText,
    String? audioId,
    String? imageId,
    String? createdAt,
    String? updatedAt,
    String? audioUrl,
    String? imageUrl,
    String? lessonTitle,
    List<Sense>? senses,
    bool? isFavorite,
    DateTime? lastReviewed,
    int? proficiencyLevel,
  }) {
    return Word(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      word: word ?? this.word,
      pos: pos ?? this.pos,
      phonetic: phonetic ?? this.phonetic,
      phoneticText: phoneticText ?? this.phoneticText,
      phoneticAm: phoneticAm ?? this.phoneticAm,
      phoneticAmText: phoneticAmText ?? this.phoneticAmText,
      audioId: audioId ?? this.audioId,
      imageId: imageId ?? this.imageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      senses: senses ?? this.senses,
      isFavorite: isFavorite ?? this.isFavorite,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
    );
  }
}
