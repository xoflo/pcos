
/// This is used in replacement of using Comparable directly because of migration to Dart 3 from 2.x
/// Otherwise we will get The class 'Comparable' can't be extended outside of its library because it's an interface class.dartinvalid_use_of_type_outside_library
/// With Dart SDK 2.x.x. it was okay to use any class as mixin. 
/// But with Dart 3 this is no longer allowed as stated in the documentation: https://dart.dev/resources/dart-3-migration#mixin
/// 
/// How to replace existing extends Comparable in codes:
/// just change 'extends Comparable' to 'with Compare' and import this file.
mixin Compare<T> implements Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator >=(T other) => compareTo(other) >= 0;
  bool operator <(T other) => compareTo(other) < 0;
  bool operator >(T other) => compareTo(other) > 0;
}