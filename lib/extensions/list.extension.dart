import 'dart:developer' as dev show log;

extension Log on Object {
  void log() {
    dev.log(toString());
  }
}

extension Splice<T> on List<T> {
  Iterable<T> splice(int start, int count, [List<T>? insert]) {
    final result = [...getRange(start, start + count)];
    replaceRange(start, start + count, insert ?? []);
    return result;
  }
}
