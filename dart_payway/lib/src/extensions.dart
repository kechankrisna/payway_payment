extension ExtensionOnMap on Map<String,dynamic> {

  String get(String name, {String? fallback}) {
    final value = maybeGet(name, fallback: fallback);
    assert(value != null, 'A non-null fallback is required for missing entries');
    return value!;
  }

  String? maybeGet(String name, {String? fallback}) => this[name] ?? fallback;

}