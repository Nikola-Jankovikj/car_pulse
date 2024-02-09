import 'dart:convert';
import 'dart:typed_data';
import 'package:car_pulse/model/ModificationInfo.dart';
import 'package:car_pulse/screens/addModificationInfo.dart';
import 'package:car_pulse/screens/modification_planner.dart';
import 'package:car_pulse/service/car_service.dart';
import 'package:flutter/material.dart';
import '../model/car.dart';

class ModificationHistoryScreen extends StatefulWidget {
  final Car selectedCar;

  ModificationHistoryScreen({required this.selectedCar});

  @override
  _ModificationHistoryScreenState createState() =>
      _ModificationHistoryScreenState();
}

class _ModificationHistoryScreenState extends State<ModificationHistoryScreen> {
  List<Car> cars = [];
  CarService carModification = CarService();
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
        title: Text('Modification Book'),
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
                      rows: currCar.modificationRecords
                          .map((modificationRecord) {
                        return DataRow(cells: [
                            DataCell(
                            GestureDetector(
                            onTap: () {
                          _showFullStringDialog(
                              context, modificationRecord.description);
                        },
                        child: Tooltip(
                        message: modificationRecord.description,
                        child: Text(
                        modificationRecord.description.length > 15
                        ? '${modificationRecord.description.substring(0, 15)}...'
                            : modificationRecord.description,
                        softWrap: true,
                        ),
                        ),
                        ),
                        ),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                _navigateToModifcationInfoScreen(
                                    modificationRecord);
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
                                _deleteModificationInfo(modificationRecord);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          )
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
                builder: (context) => AddModificationScreen(
                  selectedCar: currCar,
                  onModificationAdded: (ModificationInfo newModification) {
                    // Use the newModification callback to update currCar
                    setState(() {
                      //currCar.modificationRecords.add(newModification);
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

  void _navigateToModifcationInfoScreen(
      ModificationInfo modificationInfo) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                modification_planner(modificationInfo: modificationInfo)));
  }

  void _deleteModificationInfo(ModificationInfo modificationRecords) {
    setState(() {
      widget.selectedCar.modificationRecords.remove(modificationRecords);
      carModification.saveCar(widget.selectedCar);
    });
  }

  void loadCarData() async {
    List<Car> storedCars = await carModification.loadAllCars();
    setState(() {
      cars = storedCars;
    });
  }
}
