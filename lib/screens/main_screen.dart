import 'dart:convert';
import 'dart:typed_data';
import 'package:car_pulse/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import '../model/car.dart';
import '../service/car_service.dart';
import 'car_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Car> cars = [];

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
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()), // Navigate to WeatherScreen
              );
            },
          ),
        ],
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
        onPressed: () async {
          await _showAddCarDialog(context);
          // Reload cars after adding a new one
          await loadCars();
        },
        backgroundColor: Colors.green, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Uint8List decoded(String string) {
    return base64Decode(string);
  }

  Widget _buildCarCard(Car car) {
    return Dismissible(
      key: Key(car.id!), // Use a unique key for each item
      onDismissed: (direction) async {
        // Remove the item from the data source
        setState(() {
          cars.remove(car);
        });
        // Remove the item from storage
        await CarService().deleteCar(car);
      },
      background: Container(
        color: Colors.red, // Background color when swiping
        child: const ListTile(
          leading: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          await _onCarTap(context, car);
          // Reload cars after updating the car
          await loadCars();
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (car.photoBase64 != null && car.photoBase64!.isNotEmpty)
                Image.memory(
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
        ),
      ),
    );
  }



  Future<void> _onCarTap(BuildContext context, Car car) async {
    // Navigate to a new screen and pass the Car object
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailScreen(
          car: car,
          onPhotoChanged: (newPhoto) async {
            // Update the photo in the current car list
            final updatedCar = cars.firstWhere((element) => element.id == car.id);
            updatedCar.photoBase64 = base64Encode(newPhoto);
            await CarService().saveCar(updatedCar);

            // Reload cars after updating the photo
            await loadCars();
          },
        ),
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
              onPressed: () async {
                // Add logic to create and add a new car to the list
                if (make.isNotEmpty && model.isNotEmpty) {
                  await _addNewCar(make, model);
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

  Future<void> _addNewCar(String make, String model) async {
    Car newCar = Car(make: make, model: model);
    setState(() {
      cars.add(newCar);
    });
    await CarService().saveCar(newCar); // Save the updated list to storage
  }
}
