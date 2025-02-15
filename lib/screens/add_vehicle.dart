import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  void _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      try {
        final vehicle = Vehicle(
          id: '',
          name: _nameController.text,
          year: int.parse(_yearController.text),
          mileage: double.parse(_mileageController.text),
        );

        await firestoreService.addVehicle(vehicle);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Vehicle Added Successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Error adding vehicle'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black87),
      prefixIcon: Icon(icon, color: Colors.black87),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.black87, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Add New Vehicle',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 80,
                  color: Colors.black87,
                ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                      'Vehicle Name', Icons.drive_file_rename_outline),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter vehicle name' : null,
                ).animate().fadeIn(duration: 600.ms).moveX(begin: -100, end: 0),
                SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  decoration:
                      _buildInputDecoration('Year', Icons.calendar_today),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter vehicle year';
                    final year = int.tryParse(value);
                    if (year == null) return 'Enter a valid year';
                    if (year < 1900 || year > DateTime.now().year + 1) {
                      return 'Enter a valid year between 1900 and ${DateTime.now().year + 1}';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .moveX(begin: -100, end: 0, delay: 100.ms),
                SizedBox(height: 16),
                TextFormField(
                  controller: _mileageController,
                  decoration:
                      _buildInputDecoration('Mileage (km/l)', Icons.speed),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter mileage';
                    final mileage = double.tryParse(value);
                    if (mileage == null) return 'Enter a valid number';
                    if (mileage <= 0) return 'Mileage must be greater than 0';
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .moveX(begin: -100, end: 0, delay: 200.ms),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Vehicle',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .moveY(begin: 50, end: 0, delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }
}
