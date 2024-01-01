import 'dart:convert';
import 'dart:typed_data';

import 'package:car_pulse/screens/service_history.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/car.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car; // Pass carId instead of the entire Car object
  final Function(Uint8List) onPhotoChanged;

  const CarDetailScreen({Key? key, required this.car, required this.onPhotoChanged}) : super(key: key);

  @override
  _CarDetailScreenState createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {

  @override
  void initState() {
    super.initState();
    loadCarDetails(); // Load car details based on carId
  }

  Future<void> loadCarDetails() async {
    // Load the Car object based on carId
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.car.make} ${widget.car.model} Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Car Image with Image Picker
          GestureDetector(
            onTap: () {
              _showImagePickerDialog();
            },
            child: SizedBox(
              height: 200,
              child: Image.memory(
                widget.car.photoBase64 != null ? base64Decode(widget.car.photoBase64!) : Uint8List(0),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Text Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${widget.car.make} ${widget.car.model}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Add more text details here as needed
              ],
            ),
          ),
          // Clickable Square Blocks
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildSquareBlock("Service History", Image.asset('icons/service-icon.png')),
                ),
                Expanded(
                  child: _buildSquareBlock("Modification Planner", Image.asset('icons/turbo.png')),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildSquareBlock("Upcoming Service", Image.asset('icons/canister.png')),
                ),
                Expanded(
                  child: _buildSquareBlock("Edit Stats", Image.asset('icons/bar-chart.png')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareBlock(String label, Image image) {
    return GestureDetector(
      onTap: () {
        // Handle block click as needed
        print("Clicked $label");
        if (label == "Service History"){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServiceHistoryScreen(
                    selectedCar: widget.car,
                  )));
        }
      },
      child: Container(
        margin: EdgeInsets.all(8), // Adjust the padding as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80, // Adjust the height as needed for the image
                width: 80, // Adjust the width as needed for the image
                child: image,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 16), // Adjust the fontSize as needed for the text
              ),
            ],
          ),
        ),
      ),
    );
  }





  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Image From:"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
                child: const Text("Gallery"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
                child: const Text("Camera"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final pickedImageBytes = await pickedFile.readAsBytes();
      setState(() {
        saveCarPhoto(pickedImageBytes);
        widget.car.photoBase64 = base64Encode(pickedImageBytes);
      });
    }
  }

  Future<void> saveCarPhoto(Uint8List pickedImageBytes) async {
    widget.onPhotoChanged(pickedImageBytes); // Call the callback function
  }

}
