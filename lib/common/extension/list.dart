extension ListExtension<T> on List<T> {
  List<T> replace(oldEntity, newEntity) {
    final newList = <T>[...this];
    final index = indexOf(oldEntity);
    if (index != -1) {
      newList.remove(oldEntity);
      newList.insert(index, newEntity);
    }
    return newList;
  }
}
