import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/vehicle.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

  Stream<List<Vehicle>> getVehicles() {
    return vehiclesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> editVehicle(String vehicleId, Vehicle updatedVehicle) async {
    await vehiclesCollection.doc(vehicleId).update(updatedVehicle.toMap());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _db.collection('vehicles').doc(vehicle.id).update({
        'name': vehicle.name,
        'year': vehicle.year,
        'mileage': vehicle.mileage,
      });
    } catch (e) {
      print("Error updating vehicle: $e");
      throw e;
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await vehiclesCollection.add(vehicle.toMap());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await vehiclesCollection.doc(vehicleId).delete();
  }
}
