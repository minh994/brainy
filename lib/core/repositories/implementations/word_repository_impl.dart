import 'dart:convert';
import 'dart:io';

import '../../models/api_response.dart';
import '../../models/word_models.dart';
import '../../services/http/brainy_api_client.dart';
import '../abstract/word_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final BrainyApiClient apiClient;

  WordRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResponse<List<Word>>> getAllWords() async {
    return await apiClient.get<List<Word>>(
      '/words',
      (json) => (json as List).map((item) => Word.fromJson(item)).toList(),
    );
  }

  @override
  Future<ApiResponse<Word>> getWordById(String wordId) async {
    return await apiClient.get<Word>(
      '/words/$wordId',
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<Word>>> searchWords(String keyword) async {
    return await apiClient.get<List<Word>>(
      '/words/search?q=$keyword',
      (json) => (json as List).map((item) => Word.fromJson(item)).toList(),
    );
  }

  @override
  Future<ApiResponse<Word>> createWord(WordCreateRequest request) async {
    return await apiClient.post<Word>(
      '/words',
      request.toJson(),
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<Word>> updateWord(
      String wordId, Map<String, dynamic> data) async {
    return await apiClient.put<Word>(
      '/words/$wordId',
      data,
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<bool>> deleteWord(String wordId) async {
    return await apiClient.delete<bool>(
      '/words/$wordId',
      (json) => json['success'] ?? false,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> importWords(
      List<WordCreateRequest> words) async {
    final wordsList = words.map((word) => word.toJson()).toList();
    return await apiClient.post<Map<String, dynamic>>(
      '/words/import',
      {'words': wordsList},
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> importWordsFromFile(
      dynamic fileData) async {
    if (fileData is File) {
      // For a File object
      final bytes = await fileData.readAsBytes();
      final base64File = base64Encode(bytes);

      return await apiClient.post<Map<String, dynamic>>(
        '/words/import/file',
        {
          'file': base64File,
          'filename': fileData.path.split('/').last,
        },
        (json) => json as Map<String, dynamic>,
      );
    } else if (fileData is List<int>) {
      // For raw bytes
      final base64File = base64Encode(fileData);

      return await apiClient.post<Map<String, dynamic>>(
        '/words/import/file',
        {
          'file': base64File,
          'filename': 'import.csv', // Default filename
        },
        (json) => json as Map<String, dynamic>,
      );
    } else {
      return ApiResponse.error(message: 'Unsupported file format');
    }
  }
}
