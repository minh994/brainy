import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../models/lesson_model.dart';
import '../viewmodels/lesson_detail_view_model.dart';

class LessonDetailView extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailView({
    Key? key,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LessonDetailViewModel>(
      viewModelBuilder: () => locator<LessonDetailViewModel>(),
      onModelReady: (model) => model.setLesson(lesson),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              model.lessonTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            elevation: 0,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LessonDetailViewModel model) {
    return Markdown(
      data: model.markdownContent,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Roboto',
              color: Theme.of(context).colorScheme.primary,
            ),
        h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Roboto',
              color: Theme.of(context).colorScheme.primary,
            ),
        h3: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'Roboto',
            ),
        h4: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
        strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
        blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
        code: Theme.of(context).textTheme.bodySmall?.copyWith(
              backgroundColor: Colors.grey[200],
              fontSize: 12,
              fontFamily: 'Roboto',
            ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        tableHead: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Roboto',
        ),
        tableBody: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'Roboto',
        ),
        tableBorder: TableBorder.all(
          color: Colors.grey[300]!,
          width: 1,
          style: BorderStyle.solid,
        ),
        tableColumnWidth: const IntrinsicColumnWidth(),
        tableCellsPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Colors.grey[300]!,
            ),
          ),
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          _launchUrl(href);
        }
      },
      shrinkWrap: false,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }
}
