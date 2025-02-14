import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';
import 'add_vehicle.dart';

class VehicleListPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  Color getVehicleColor(Vehicle vehicle) {
    int currentYear = DateTime.now().year;
    int age = currentYear - vehicle.year;

    if (vehicle.mileage >= 15) {
      return (age <= 5) ? Colors.green : Colors.amber;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle List')),
      body: StreamBuilder<List<Vehicle>>(
        stream: firestoreService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          }

          List<Vehicle> vehicles = snapshot.data!;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              Vehicle vehicle = vehicles[index];
              return Card(
                color: getVehicleColor(vehicle),
                child: ListTile(
                  title: Text(vehicle.name),
                  subtitle: Text('Year: ${vehicle.year}, Mileage: ${vehicle.mileage} km/l'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehiclePage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Vehicle',
      ),
    );
  }
}
