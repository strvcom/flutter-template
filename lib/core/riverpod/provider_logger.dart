import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class ProvidersLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    super.didAddProvider(context, value);

    Flogger.v(
      '[PROVIDER] Provider added: ${context.provider.name ?? context.provider.runtimeType},'
      '\n[PROVIDER] Value: $value',
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    super.didUpdateProvider(context, previousValue, newValue);

    Flogger.v(
      '[PROVIDER] Provider updated: ${context.provider.name ?? context.provider.runtimeType},'
      '\n[PROVIDER] Old value: $previousValue,'
      '\n[PROVIDER] New value: $newValue',
    );
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    super.didDisposeProvider(context);

    Flogger.v('[PROVIDER] Provider disposed: ${context.provider.name ?? context.provider.runtimeType}');
  }
}
