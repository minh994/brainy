import '../../models/api_response.dart';
import '../../models/word_model.dart';

abstract class WordRepository {
  /// Lấy danh sách từ vựng
  Future<ApiResponse<List<Word>>> getWords();

  /// Lấy thông tin chi tiết từ vựng theo ID
  Future<ApiResponse<Word>> getWordById(String id);

  /// Thêm từ vựng mới
  Future<ApiResponse<Word>> addWord(Word word);

  /// Cập nhật thông tin từ vựng
  Future<ApiResponse<Word>> updateWord(Word word);

  /// Xóa từ vựng
  Future<ApiResponse<void>> deleteWord(String id);

  /// Lấy danh sách từ vựng yêu thích
  Future<ApiResponse<List<Word>>> getFavoriteWords();

  /// Lấy danh sách từ vựng theo mức độ thành thạo
  Future<ApiResponse<List<Word>>> getWordsByProficiency(int level);

  /// Tìm kiếm từ vựng
  Future<ApiResponse<List<Word>>> searchWords(String query);

  /// Lấy danh sách từ vựng có phân trang
  Future<ApiResponse<List<Word>>> getWordsPaginated(
      {int page = 1, int limit = 10});
}
