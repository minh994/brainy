class Word {
  final String text;
  final String pronunciation;
  final List<String> definitions;
  final List<String> examples;

  Word({
    required this.text,
    required this.pronunciation,
    required this.definitions,
    required this.examples,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      definitions: List<String>.from(json['definitions'] ?? []),
      examples: List<String>.from(json['examples'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'pronunciation': pronunciation,
      'definitions': definitions,
      'examples': examples,
    };
  }
}
