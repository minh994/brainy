enum WordStatus {
  all('all', 'All'),
  learning('learning', 'Learning'),
  learned('learned', 'Learned'),
  skip('skip', 'Skipped');

  final String value;
  final String label;

  const WordStatus(this.value, this.label);

  @override
  String toString() => value;
}
