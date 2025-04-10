import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';
import 'add_vehicle.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'edit_vehicle.dart';

class VehicleListPage extends StatefulWidget {
  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  final FirestoreService firestoreService = FirestoreService();
  String searchQuery = "";
  bool isSearching = false;
  double minMileage = 0;
  double maxMileage = 50;
  int? selectedYear;

  Color getVehicleColor(Vehicle vehicle) {
    int currentYear = DateTime.now().year;
    int age = currentYear - vehicle.year;
    if (vehicle.mileage >= 15) {
      return age <= 5 ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2);
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

  List<Vehicle> filterVehicles(List<Vehicle> vehicles) {
    return vehicles
        .where((vehicle) =>
    vehicle.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
        vehicle.mileage >= minMileage &&
        vehicle.mileage <= maxMileage &&
        (selectedYear == null || vehicle.year == selectedYear))
        .toList();
  }

  void _showFilterDialog() {
    double tempMinMileage = minMileage;
    double tempMaxMileage = maxMileage;
    int? tempSelectedYear = selectedYear;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Vehicles",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Mileage Range Section
                  Text(
                    "Mileage Range",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${tempMinMileage.toStringAsFixed(1)} - ${tempMaxMileage.toStringAsFixed(1)} km/lt",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: RangeSlider(
                      values: RangeValues(tempMinMileage, tempMaxMileage),
                      min: 0,
                      max: 50,
                      divisions: 50,
                      activeColor: Colors.black87,
                      inactiveColor: Colors.grey[300],
                      labels: RangeLabels(
                        tempMinMileage.toStringAsFixed(1),
                        tempMaxMileage.toStringAsFixed(1),
                      ),
                      onChanged: (values) {
                        setModalState(() {
                          tempMinMileage = values.start;
                          tempMaxMileage = values.end;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 25),

                  // Year Selection Section
                  Text(
                    "Manufacturing Year",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: tempSelectedYear,
                        isExpanded: true,
                        hint: Text(
                          "Any Year",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text("Any Year"),
                          ),
                          ...List.generate(30, (index) {
                            int year = DateTime.now().year - index;
                            return DropdownMenuItem(
                              value: year,
                              child: Text("$year"),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            tempSelectedYear = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              minMileage = 0;
                              maxMileage = 50;
                              selectedYear = null;
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Reset Filters",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              minMileage = tempMinMileage;
                              maxMileage = tempMaxMileage;
                              selectedYear = tempSelectedYear;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Vehicle vehicle) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                "Delete Vehicle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this vehicle?",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        getVehicleIcon(vehicle),
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${vehicle.year} • ${vehicle.mileage} km/lt',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await firestoreService.deleteVehicle(vehicle.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vehicle deleted successfully'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting vehicle'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildSearchField() {
    return TextField(
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: 'Search vehicles by name...',
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25.0),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(Icons.filter_list, color: Colors.black87),
        onPressed: _showFilterDialog,
      ),
      isSearching
          ? IconButton(
        icon: Icon(Icons.clear, color: Colors.grey),
        onPressed: () {
          setState(() {
            searchQuery = "";
            isSearching = false;
          });
        },
      )
          : IconButton(
        icon: Icon(Icons.search, color: Colors.black87),
        onPressed: () {
          setState(() {
            isSearching = true;
          });
        },
      ),
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: isSearching
          ? _buildSearchField()
          : Text(
        'My Vehicles',
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      actions: _buildAppBarActions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: StreamBuilder<List<Vehicle>>(
        stream: firestoreService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vehicles found'));
          }

          List<Vehicle> filteredVehicles = filterVehicles(snapshot.data!);

          if (filteredVehicles.isEmpty && searchQuery.isNotEmpty) {
            return Center(child: Text('No matches found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredVehicles.length,
            itemBuilder: (context, index) {
              Vehicle vehicle = filteredVehicles[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                child: ListTile(
                  tileColor: getVehicleColor(vehicle),
                  leading: Icon(getVehicleIcon(vehicle), size: 30, color: Colors.black87),
                  title: Text(vehicle.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${vehicle.year} • ${vehicle.mileage} km/lt'),
                  onLongPress: () => _showDeleteDialog(context, vehicle),
                  onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditVehiclePage(vehicle: vehicle),
                    ),
                  );
                  }
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddVehiclePage()));
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
    );
  }
}
