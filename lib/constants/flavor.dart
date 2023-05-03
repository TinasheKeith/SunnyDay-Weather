/// An enumeration of the different app flavors.
///
/// The flavors determine which environment the app is built for,
/// such as development, staging, or production.
enum Flavor {
  /// Development flavor, used for development.
  dev,

  /// Staging flavor, used for testing purposes.
  staging,

  /// Production flavor to be used in the wild.
  prod
}
