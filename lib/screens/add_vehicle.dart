import 'package:flutter/material.dart';
import '../data/vehicle.dart';
import '../services/firestore.dart';

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
      final vehicle = Vehicle(
        id: '',
        name: _nameController.text,
        year: int.parse(_yearController.text),
        mileage: double.parse(_mileageController.text),
      );

      await firestoreService.addVehicle(vehicle);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vehicle Added Successfully')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Vehicle')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Vehicle Name'),
                validator: (value) =>
                value!.isEmpty ? 'Enter vehicle name' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter vehicle year' : null,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage (km/l)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Enter mileage' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVehicle,
                child: Text('Add Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
