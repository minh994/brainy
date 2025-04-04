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
  final String? createdAt;
  final String? updatedAt;
  final List<Example> examples;

  Sense({
    required this.id,
    required this.wordId,
    required this.definition,
    this.createdAt,
    this.updatedAt,
    required this.examples,
  });

  factory Sense.fromJson(Map<String, dynamic> json) {
    List<Example> examples = [];
    if (json['examples'] != null) {
      examples =
          (json['examples'] as List).map((e) => Example.fromJson(e)).toList();
    }

    return Sense(
      id: json['id'] ?? '',
      wordId: json['word_id'] ?? '',
      definition: json['definition'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      examples: examples,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word_id': wordId,
      'definition': definition,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'examples': examples.map((e) => e.toJson()).toList(),
    };
  }
}

class Word {
  final String id;
  final String? lessonId;
  final String word;
  final String pos;
  final String phonetic;
  final String phoneticText;
  final String phoneticAm;
  final String phoneticAmText;
  final String? audioId;
  final String? imageId;
  final String? createdAt;
  final String? updatedAt;
  final String? audioUrl;
  final String? imageUrl;
  final String? lessonTitle;
  final List<Sense> senses;

  Word({
    required this.id,
    this.lessonId,
    required this.word,
    required this.pos,
    required this.phonetic,
    required this.phoneticText,
    required this.phoneticAm,
    required this.phoneticAmText,
    this.audioId,
    this.imageId,
    this.createdAt,
    this.updatedAt,
    this.audioUrl,
    this.imageUrl,
    this.lessonTitle,
    required this.senses,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    List<Sense> senses = [];
    if (json['senses'] != null) {
      senses = (json['senses'] as List).map((e) => Sense.fromJson(e)).toList();
    }

    return Word(
      id: json['id'] ?? '',
      lessonId: json['lesson_id'],
      word: json['word'] ?? '',
      pos: json['pos'] ?? '',
      phonetic: json['phonetic'] ?? '',
      phoneticText: json['phonetic_text'] ?? '',
      phoneticAm: json['phonetic_am'] ?? '',
      phoneticAmText: json['phonetic_am_text'] ?? '',
      audioId: json['audio_id'],
      imageId: json['image_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      audioUrl: json['audio_url'],
      imageUrl: json['image_url'],
      lessonTitle: json['lesson_title'],
      senses: senses,
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
      'senses': senses.map((e) => e.toJson()).toList(),
    };
  }
}

class WordCreateRequest {
  final String word;
  final String pos;
  final String phonetic;
  final String phoneticText;
  final String phoneticAm;
  final String phoneticAmText;
  final List<SenseCreateRequest> senses;

  WordCreateRequest({
    required this.word,
    required this.pos,
    required this.phonetic,
    required this.phoneticText,
    required this.phoneticAm,
    required this.phoneticAmText,
    required this.senses,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'pos': pos,
      'phonetic': phonetic,
      'phonetic_text': phoneticText,
      'phonetic_am': phoneticAm,
      'phonetic_am_text': phoneticAmText,
      'senses': senses.map((e) => e.toJson()).toList(),
    };
  }
}

class SenseCreateRequest {
  final String definition;
  final List<ExampleCreateRequest> examples;

  SenseCreateRequest({
    required this.definition,
    required this.examples,
  });

  Map<String, dynamic> toJson() {
    return {
      'definition': definition,
      'examples': examples.map((e) => e.toJson()).toList(),
    };
  }
}

class ExampleCreateRequest {
  final String cf;
  final String x;

  ExampleCreateRequest({
    required this.cf,
    required this.x,
  });

  Map<String, dynamic> toJson() {
    return {
      'cf': cf,
      'x': x,
    };
  }
}

class Progress {
  final String id;
  final String userId;
  final String wordId;
  final String status;
  final String lastReview;
  final String nextReview;
  final int reviewCount;
  final String word;
  final String phonetic;
  final String phoneticText;

  Progress({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.status,
    required this.lastReview,
    required this.nextReview,
    required this.reviewCount,
    required this.word,
    required this.phonetic,
    required this.phoneticText,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      wordId: json['word_id'] ?? '',
      status: json['status'] ?? '',
      lastReview: json['last_review'] ?? '',
      nextReview: json['next_review'] ?? '',
      reviewCount: json['review_count'] ?? 0,
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      phoneticText: json['phonetic_text'] ?? '',
    );
  }
}

class Note {
  final String id;
  final String userId;
  final String wordId;
  final String note;
  final String? createdAt;
  final String? updatedAt;
  final String word;
  final String phonetic;
  final String phoneticText;

  Note({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.note,
    this.createdAt,
    this.updatedAt,
    required this.word,
    required this.phonetic,
    required this.phoneticText,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      wordId: json['word_id'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      phoneticText: json['phonetic_text'] ?? '',
    );
  }
}
