import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../components/lesson_list_item.dart';
import '../models/lesson_model.dart';
import '../viewmodels/category_detail_view_model.dart';
import 'lesson_detail_view.dart';

class CategoryDetailView extends StatelessWidget {
  final String categoryId;

  const CategoryDetailView({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryDetailViewModel>(
      viewModelBuilder: () => locator<CategoryDetailViewModel>(),
      onModelReady: (model) => model.loadCategoryDetail(categoryId),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              model.category?.title ?? 'Category Details',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                  ),
            ),
            elevation: 0,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoryDetailViewModel model) {
    if (model.isBusy) {
      return const Center(child: BusyIndicator());
    }

    if (model.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${model.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => model.loadCategoryDetail(categoryId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (model.category == null) {
      return const Center(
        child: Text('Category not found'),
      );
    }

    if (model.lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.book,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No lessons available for this category.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lessons list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: model.lessons.length,
            itemBuilder: (context, index) {
              final lesson = model.lessons[index];
              return _buildLessonItem(context, lesson, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonItem(BuildContext context, Lesson lesson, int index) {
    return LessonListItem(
      lesson: lesson,
      index: index,
      onTap: () => _navigateToLessonDetail(context, lesson),
    );
  }

  void _navigateToLessonDetail(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailView(lesson: lesson),
      ),
    );
  }
}
