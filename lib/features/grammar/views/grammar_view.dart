import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../components/category_list_item.dart';
import '../models/category_model.dart';
import '../viewmodels/grammar_list_view_model.dart';
import 'category_detail_view.dart';

class GrammarView extends StatelessWidget {
  const GrammarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GrammarListViewModel>(
      viewModelBuilder: () => locator<GrammarListViewModel>(),
      onModelReady: (model) => model.loadCategories(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Grammar',
              style: TextStyle(
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

  Widget _buildBody(BuildContext context, GrammarListViewModel model) {
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
              onPressed: () => model.loadCategories(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (model.categories.isEmpty) {
      return const Center(
        child: Text('No grammar categories available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => model.loadCategories(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: model.categories.length,
        itemBuilder: (context, index) {
          final category = model.categories[index];
          return _buildCategoryItem(context, category);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    return CategoryListItem(
      category: category,
      onTap: () => _navigateToCategoryDetail(context, category),
    );
  }

  void _navigateToCategoryDetail(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailView(categoryId: category.id),
      ),
    );
  }
}
