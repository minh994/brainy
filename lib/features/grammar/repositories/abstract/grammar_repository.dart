import '../../../../core/models/api_response.dart';
import '../../models/category_model.dart';

abstract class GrammarRepository {
  /// Fetch all grammar categories without lessons
  Future<ApiResponse<List<Category>>> getCategories();

  /// Fetch a specific category with its lessons
  Future<ApiResponse<Category>> getCategoryWithLessons(String categoryId);
}
