extension ListExtension<T> on List<T> {
  List<T> replace(T oldEntity, T newEntity) {
    final newList = <T>[...this];
    final index = indexOf(oldEntity);
    if (index != -1) {
      newList
        ..remove(oldEntity)
        ..insert(index, newEntity);
    }
    return newList;
  }
}
