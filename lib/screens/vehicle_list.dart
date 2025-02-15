import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';
import 'add_vehicle.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class VehicleListPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  Color getVehicleColor(Vehicle vehicle) {
    int currentYear = DateTime.now().year;
    int age = currentYear - vehicle.year;
    if (vehicle.mileage >= 15) {
      return age <= 5
          ? Colors.green.withOpacity(0.2)
          : Colors.amber.withOpacity(0.2);
    }
    return Colors.red.withOpacity(0.2);
  }

  IconData getVehicleIcon(Vehicle vehicle) {
    if (vehicle.mileage >= 15) {
      return Icons.eco;
    } else if (vehicle.mileage >= 10) {
      return Icons.battery_charging_full;
    }
    return Icons.local_gas_station;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Vehicles',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<Vehicle>>(
        stream: firestoreService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading data'),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No vehicles found'),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first vehicle',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          List<Vehicle> vehicles = snapshot.data!;
          return AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = vehicles[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: getVehicleColor(vehicle),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            leading: Hero(
                              tag: 'vehicle-${vehicle.name}',
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  getVehicleIcon(vehicle),
                                  size: 30,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            title: Text(
                              vehicle.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16),
                                    SizedBox(width: 4),
                                    Text('${vehicle.year}'),
                                    SizedBox(width: 16),
                                    Icon(Icons.speed, size: 16),
                                    SizedBox(width: 4),
                                    Text('${vehicle.mileage} km/l'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehiclePage()),
          );
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text('Add Vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
    );
  }
}
