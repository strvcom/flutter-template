typedef LetCallback<T, R> = R Function(T it);

extension DynamicExtension<T> on T {
  R? let<R>(LetCallback<T, R> it) {
    return this != null ? it(this) : null;
  }
}
