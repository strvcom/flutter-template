import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvidersLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);

    Flogger.v(
      '[PROVIDER] Provider added: ${provider.name ?? provider.runtimeType},'
      '\n[PROVIDER] Value: $value',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    Flogger.v(
      '[PROVIDER] Provider updated: ${provider.name ?? provider.runtimeType},'
      '\n[PROVIDER] Old value: $previousValue,'
      '\n[PROVIDER] New value: $newValue',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic> provider,
    ProviderContainer container,
  ) {
    super.didDisposeProvider(provider, container);

    Flogger.v('[PROVIDER] Provider disposed: ${provider.name ?? provider.runtimeType}');
  }
}
