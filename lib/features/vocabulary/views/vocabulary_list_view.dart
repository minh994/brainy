import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../viewmodels/vocabulary_list_view_model.dart';

class VocabularyListView extends StatelessWidget {
  const VocabularyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<VocabularyListViewModel>(
      viewModelBuilder: () => locator<VocabularyListViewModel>(),
      onModelReady: (model) => model.fetchVocabularyList(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Vocabulary'),
        ),
        body: model.isBusy
            ? const Center(child: CircularProgressIndicator())
            : model.hasError
                ? Center(child: Text(model.errorMessage ?? 'Unknown error'))
                : const Center(
                    child: Text('Vocabulary list will be displayed here')),
      ),
    );
  }
}
