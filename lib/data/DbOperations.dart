
abstract class DbOperations<T> {

  Future<int> create(T object);

  Future<List<T>> read();
  Future<List<T>> read2();

  Future<List<T>> show(int counter);
  Future<List<T>> show2();

  // Future<bool> update(T object);

  Future<bool> delete(int id);
}