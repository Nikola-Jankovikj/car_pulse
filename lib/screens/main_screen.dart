import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/car.dart';
import '../service/car_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Car> cars = [];
  //late Uint8List photoBytes;

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    List<Car> loadedCars = await CarService().loadAllCars();
    setState(() {
      cars = loadedCars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Garage"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (context, index) {
            return _buildCarCard(cars[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCarDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Uint8List decoded(String string){
    return base64Decode(string);
  }

  Widget _buildCarCard(Car car) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.memory(
            // Convert base64 photo to bytes
            // Uint8List.fromList(car.photoBase64),
           // Uint8List.fromList(decoded(car.photoBase64!)),
            base64Decode(car.photoBase64!),
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${car.make} ${car.model}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _showAddCarDialog(BuildContext context) async {
    String make = '';
    String model = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Make'),
                onChanged: (value) {
                  make = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Model'),
                onChanged: (value) {
                  model = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add logic to create and add a new car to the list
                if (make.isNotEmpty && model.isNotEmpty) {
                  _addNewCar(make, model);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewCar(String make, String model) {
    Car newCar = Car(make: make, model: model);
    setState(() {
      cars.add(newCar);
    });
    CarService().saveCar(newCar); // Save the updated list to storage
  }
}
