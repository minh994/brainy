import '../../models/api_response.dart';
import '../../services/http/brainy_api_client.dart';
import '../../../features/grammar/models/category_model.dart';
import '../abstract/grammar_repository.dart';

class GrammarRepositoryImpl implements GrammarRepository {
  final BrainyApiClient _apiClient;

  GrammarRepositoryImpl({
    required BrainyApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<ApiResponse<List<Category>>> getCategories() async {
    return await _apiClient.get<List<Category>>(
      '/categories?with_lessons=false',
      (json) {
        if (json is Map &&
            json.containsKey('categories') &&
            json['categories'] is List) {
          return (json['categories'] as List)
              .map((category) => Category.fromJson(category))
              .toList();
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<Category>> getCategoryWithLessons(
      String categoryId) async {
    return await _apiClient.get<Category>(
      '/categories/$categoryId?with_lessons=true',
      (json) {
        if (json is Map &&
            json.containsKey('category') &&
            json['category'] is Map) {
          return Category.fromJson(json['category']);
        }
        return Category(
          id: '',
          title: '',
          description: '',
          status: 'inactive',
          orderIndex: 0,
          progress: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      },
    );
  }
}
