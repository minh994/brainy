import '../../models/api_response.dart';
import '../../models/word_model.dart';
import '../../services/http/brainy_api_client.dart';
import '../abstract/word_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final BrainyApiClient _apiClient;

  WordRepositoryImpl({
    required BrainyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<ApiResponse<List<Word>>> getWords() async {
    return await _apiClient.get<List<Word>>(
      '/words',
      (json) {
        if (json is List) {
          return json.map((data) => Word.fromJson(data)).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<Word>> getWordById(String id) async {
    return await _apiClient.get<Word>(
      '/words/$id',
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<Word>> addWord(Word word) async {
    return await _apiClient.post<Word>(
      '/words',
      word.toJson(),
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<Word>> updateWord(Word word) async {
    return await _apiClient.put<Word>(
      '/words/${word.id}',
      word.toJson(),
      (json) => Word.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteWord(String id) async {
    return await _apiClient.delete<void>(
      '/words/$id',
      (_) {},
    );
  }

  @override
  Future<ApiResponse<List<Word>>> getFavoriteWords() async {
    return await _apiClient.get<List<Word>>(
      '/words/favorites',
      (json) {
        if (json is List) {
          return json.map((data) => Word.fromJson(data)).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<List<Word>>> getWordsByProficiency(int level) async {
    return await _apiClient.get<List<Word>>(
      '/words/proficiency/$level',
      (json) {
        if (json is List) {
          return json.map((data) => Word.fromJson(data)).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<List<Word>>> searchWords(String query) async {
    return await _apiClient.get<List<Word>>(
      '/words/search?q=$query',
      (json) {
        if (json is List) {
          return json.map((data) => Word.fromJson(data)).toList();
        }
        return [];
      },
      requiresAuth: true,
    );
  }

  @override
  Future<ApiResponse<List<Word>>> getWordsPaginated(
      {int page = 1, int limit = 10}) async {
    return await _apiClient.get<List<Word>>(
      '/words/paginated?page=$page&limit=$limit',
      (json) {
        if (json is Map && json.containsKey('items') && json['items'] is List) {
          return (json['items'] as List)
              .map((item) => Word.fromJson(item))
              .toList();
        }
        if (json is List) {
          return json.map((item) => Word.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<List<Word>>> getWordsByStatus(
      {required String status, int page = 1, int limit = 10}) async {
    final apiResponse = await _apiClient.get<Map<String, dynamic>>(
      '/learn/status?status=$status&page=$page&limit=$limit',
      (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
    );

    if (!apiResponse.success || apiResponse.data == null) {
      return ApiResponse.error(
        code: apiResponse.code,
        message: apiResponse.message,
      );
    }

    try {
      final responseData = apiResponse.data!;

      // Extract learn data
      if (responseData.containsKey('learn') && responseData['learn'] is Map) {
        final learnData = responseData['learn'] as Map<String, dynamic>;
        final total = learnData['total'] as int? ?? 0;
        final items = learnData['items'] as List? ?? [];

        final words = items.map((item) => Word.fromJson(item)).toList();

        return ApiResponse.success(
          data: words,
          totalCount: total,
          message: apiResponse.message,
          code: apiResponse.code,
        );
      }

      // Default fallback
      return ApiResponse.success(
        data: <Word>[],
        totalCount: 0,
        message: apiResponse.message,
        code: apiResponse.code,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Error parsing response: $e',
      );
    }
  }

  @override
  Future<ApiResponse<void>> updateWordStatus({
    required String wordId,
    required String status,
  }) async {
    final body = {
      'word_id': wordId,
      'status': status,
    };

    return await _apiClient.post<void>(
      '/learn',
      body,
      (_) {}, // No data conversion needed for void return type
    );
  }
}
