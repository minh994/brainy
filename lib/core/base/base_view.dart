import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_view_model.dart';

/// A base view that handles the lifecycle and state management of a view model.
///
/// The [BaseView] is a generic class that takes a [BaseViewModel] type parameter.
/// It creates and disposes of the view model, and provides it to the widget tree.
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  /// A function that creates the view model.
  final T Function() viewModelBuilder;

  /// A function that is called when the view model is ready.
  final void Function(T)? onModelReady;

  /// A function that is called when the view model is to be disposed.
  final void Function(T)? onModelDispose;

  /// A builder function that builds the UI using the view model.
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  /// Child widget that doesn't depend on the view model.
  final Widget? child;

  /// Creates a new [BaseView].
  const BaseView({
    Key? key,
    required this.viewModelBuilder,
    this.onModelReady,
    this.onModelDispose,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T _model;

  @override
  void initState() {
    super.initState();
    _model = widget.viewModelBuilder();

    if (widget.onModelReady != null) {
      widget.onModelReady!(_model);
    }
  }

  @override
  void dispose() {
    if (widget.onModelDispose != null) {
      widget.onModelDispose!(_model);
    }
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

// Extension to add convenience methods to check view states
extension BaseViewExtensions on BuildContext {
  T viewModel<T extends BaseViewModel>() => Provider.of<T>(this, listen: false);
  bool get isBusy => Provider.of<BaseViewModel>(this, listen: true).isBusy;
  bool get hasError => Provider.of<BaseViewModel>(this, listen: true).hasError;
  String? get errorMessage =>
      Provider.of<BaseViewModel>(this, listen: true).errorMessage;
}
