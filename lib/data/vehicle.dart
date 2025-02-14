class Vehicle {
  final String id;
  final String name;
  final int year;
  final double mileage;

  Vehicle({required this.id, required this.name, required this.year, required this.mileage});

  factory Vehicle.fromMap(Map<String, dynamic> data, String documentId) {
    return Vehicle(
      id: documentId,
      name: data['name'],
      year: data['year'],
      mileage: data['mileage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'year': year,
      'mileage': mileage,
    };
  }
}
