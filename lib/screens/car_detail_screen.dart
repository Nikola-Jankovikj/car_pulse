import 'dart:convert';
import 'dart:typed_data';

import 'package:car_pulse/repository/car_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/car.dart';
import '../service/car_service.dart';

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
                  child: _buildSquareBlock("Block 1", Colors.blue),
                ),
                Expanded(
                  child: _buildSquareBlock("Block 2", Colors.green),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildSquareBlock("Block 3", Colors.orange),
                ),
                Expanded(
                  child: _buildSquareBlock("Block 4", Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareBlock(String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle block click as needed
        print("Clicked $label");
      },
      child: Container(
        color: color,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
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
