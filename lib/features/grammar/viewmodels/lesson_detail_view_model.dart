import '../../../core/base/base_view_model.dart';
import '../models/lesson_model.dart';

class LessonDetailViewModel extends BaseViewModel {
  Lesson? _lesson;
  Lesson? get lesson => _lesson;

  void setLesson(Lesson lesson) {
    _lesson = lesson;
    notifyListeners();
  }

  String get markdownContent => _lesson?.content ?? '';
  String get lessonTitle => _lesson?.title ?? 'Lesson';
}
