import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';

class EditVehiclePage extends StatefulWidget {
  final Vehicle vehicle;

  EditVehiclePage({required this.vehicle});

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle.name);
    _yearController = TextEditingController(text: widget.vehicle.year.toString());
    _mileageController = TextEditingController(text: widget.vehicle.mileage.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _updateVehicle() async {
    if (_formKey.currentState!.validate()) {
      Vehicle updatedVehicle = Vehicle(
        id: widget.vehicle.id,
        name: _nameController.text,
        year: int.parse(_yearController.text),
        mileage: double.parse(_mileageController.text),
      );

      await firestoreService.updateVehicle(updatedVehicle);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle updated successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit Vehicle', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vehicle Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: 5),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  hintText: "Enter vehicle name",
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              SizedBox(height: 15),

              Text("Manufacturing Year", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: 5),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  hintText: "Enter year",
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a year';
                  int? year = int.tryParse(value);
                  if (year == null || year < 1900 || year > DateTime.now().year) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              Text("Mileage (km/lt)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: 5),
              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  hintText: "Enter mileage",
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter mileage';
                  double? mileage = double.tryParse(value);
                  if (mileage == null || mileage < 0) {
                    return 'Enter a valid mileage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _updateVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: Text(
                    "Update Vehicle",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
