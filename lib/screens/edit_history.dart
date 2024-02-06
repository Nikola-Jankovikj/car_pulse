import 'dart:convert';
import 'dart:typed_data';
import 'package:car_pulse/model/EditInfo.dart';
import 'package:car_pulse/screens/editDetails.dart';
import 'package:car_pulse/service/car_service.dart';
import 'package:flutter/material.dart';
import '../model/EditInfo.dart';
import '../model/car.dart';
import 'addEditInfo.dart';

class EditHistoryScreen extends StatefulWidget {
  final Car selectedCar;

  EditHistoryScreen({required this.selectedCar});

  @override
  _EditHistoryScreenState createState() => _EditHistoryScreenState();
}

class _EditHistoryScreenState extends State<EditHistoryScreen> {
  List<Car> cars = [];
  CarService carService = CarService();
  Car currCar = Car(make: "", model: "");

  @override
  void initState() {
    super.initState();
    loadCarData();
    setState(() {});
    currCar = widget.selectedCar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Stats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: Image.memory(
                  currCar.photoBase64 != null
                      ? base64Decode(currCar.photoBase64!)
                      : Uint8List(0),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "${currCar.make} ${currCar.model}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: DataTable(
                      columnSpacing: 20.0,
                      columns: const [
                        DataColumn(label: Text('Display Text')),
                        DataColumn(label: Text('Action')),
                        DataColumn(label: Text('Delete')),
                      ],
                      //so string
                      rows: currCar.editRecords.map((editRecord) {
                        return DataRow(cells: [
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                _navigateToEditInfoScreen(editRecord);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text('Show',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                _deleteEditInfo(editRecord);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditScreen(
                  selectedCar: currCar,
                  onEditAdded: (EditInfo newEdit) {
                    // Use the newEdit callback to update currCar
                    setState(() {
                      //currCar.editRecords.add(newEdit);
                    });
                  },
                ),
              ),
            );
          },
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showFullStringDialog(BuildContext context, String fullString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Full Text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(fullString),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditInfoScreen(EditInfo editInfo) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditInfoDetails(editInfo: editInfo)));
  }

  void _deleteEditInfo(EditInfo editRecord) {
    setState(() {
      widget.selectedCar.editRecords.remove(editRecord);
      carService.saveCar(widget.selectedCar);
    });
  }

  void loadCarData() async {
    List<Car> storedCars = await carService.loadAllCars();
    setState(() {
      cars = storedCars;
    });
  }
}
