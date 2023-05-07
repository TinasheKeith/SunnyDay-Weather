class SavedLocation {
  const SavedLocation({
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      placeName: json['placeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'placeName': placeName,
    };
  }

  final double latitude;
  final double longitude;
  final String placeName;
}
