import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/vehicle.dart';

class FirestoreService {
  final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

  Stream<List<Vehicle>> getVehicles() {
    return vehiclesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await vehiclesCollection.add(vehicle.toMap());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await vehiclesCollection.doc(vehicleId).delete();
  }
}
