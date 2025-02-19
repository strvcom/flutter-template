import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_app_bar.dart';
import 'package:flutter_app/common/component/custom_progress_indicator.dart';
import 'package:flutter_app/common/composition/placeholder/empty_placeholder_widget.dart';
import 'package:flutter_app/common/composition/placeholder/error_placeholder_widget.dart';
import 'package:flutter_app/common/data/model/exception/custom_exception.dart';
import 'package:flutter_app/common/extension/dynamic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueExtension<T> on AsyncValue<T> {
  Widget mapState<R>({
    required Refreshable provider,
    bool Function(T data)? isEmpty,
    Widget Function(T? error)? error,
    Widget Function(T? loading)? loading,
    Widget Function(T data)? empty,
    required Widget Function(T data) data,
  }) {
    return map(
      // Title: Loading State
      loading: (loadingParam) =>
          loading?.call(loadingParam.value) ??
          const Scaffold(
            appBar: CustomAppBar(),
            body: _ProgressIndicatorWidget(),
          ),

      // Title: Error State
      error: (errorParam) =>
          error?.call(errorParam.value) ??
          ((errorParam.isRefreshing)
              ? const Scaffold(
                  appBar: CustomAppBar(),
                  body: _ProgressIndicatorWidget(),
                )
              : Scaffold(
                  appBar: const CustomAppBar(),
                  body: SafeArea(
                    child: _ErrorPlaceholderWidget(provider, errorParam.error),
                  ),
                )),

      data: (dataParam) => (isEmpty?.let((it) => it(dataParam.value)) ?? false)
          // Title: Empty State
          ? (empty?.call(dataParam.value) ??
              Scaffold(
                appBar: const CustomAppBar(),
                body: SafeArea(
                  child: _EmptyPlaceholderWidget(provider),
                ),
              ))
          // Title: Data State
          : data(dataParam.value),
    );
  }

  Widget mapContentState<R>({
    required Refreshable provider,
    bool Function(T data)? isEmpty,
    Widget Function(T? error)? error,
    Widget Function(T? loading)? loading,
    Widget Function(T data)? empty,
    required Widget Function(T data) data,
  }) {
    return map(
      // Title: Loading State
      loading: (loadingParam) => loading?.call(loadingParam.value) ?? const _ProgressIndicatorWidget(),

      // Title: Error State
      error: (errorParam) =>
          error?.call(errorParam.value) ??
          ((errorParam.isRefreshing) ? const _ProgressIndicatorWidget() : _ErrorPlaceholderWidget(provider, errorParam.error)),

      data: (dataParam) => (isEmpty?.let((it) => it(dataParam.value)) ?? false)
          // Title: Empty State
          ? (empty?.call(dataParam.value) ?? _EmptyPlaceholderWidget(provider))
          // Title: Data State
          : data(dataParam.value),
    );
  }
}

class _ProgressIndicatorWidget extends StatelessWidget {
  const _ProgressIndicatorWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomProgressIndicator(),
    );
  }
}

class _EmptyPlaceholderWidget extends StatelessWidget {
  const _EmptyPlaceholderWidget(
    this.provider,
  );

  final Refreshable provider;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => EmptyPlaceholderWidget(
        onRetry: () => ref.refresh(provider),
      ),
    );
  }
}

class _ErrorPlaceholderWidget extends StatelessWidget {
  const _ErrorPlaceholderWidget(
    this.provider,
    this.error,
  );

  final Refreshable provider;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ErrorPlaceholderWidget(
        onRetry: () => ref.refresh(provider),
        exception: CustomException.fromErrorObject(error: error),
      ),
    );
  }
}
