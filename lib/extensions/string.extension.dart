extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toCapitalize() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension EnumParser on String {
  T toEnum<T>(List<T> values) {
    return values.firstWhere((e) => e.toString().toLowerCase().split(".").last == toLowerCase(),
        orElse: () => null as T);
  }
}
