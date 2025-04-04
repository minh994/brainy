import '../../models/api_response.dart';
import '../../models/word_models.dart';

abstract class WordRepository {
  /// Get all words
  Future<ApiResponse<List<Word>>> getAllWords();

  /// Get a word by ID
  Future<ApiResponse<Word>> getWordById(String wordId);

  /// Search words by keyword
  Future<ApiResponse<List<Word>>> searchWords(String keyword);

  /// Create a new word
  Future<ApiResponse<Word>> createWord(WordCreateRequest request);

  /// Update a word
  Future<ApiResponse<Word>> updateWord(
    String wordId,
    Map<String, dynamic> data,
  );

  /// Delete a word
  Future<ApiResponse<void>> deleteWord(String wordId);

  /// Import words
  Future<ApiResponse<Map<String, dynamic>>> importWords(
    List<WordCreateRequest> words,
  );

  /// Import words from file
  Future<ApiResponse<Map<String, dynamic>>> importWordsFromFile(
    dynamic fileData,
  );
}
