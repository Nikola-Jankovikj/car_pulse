import 'dart:convert';
import 'dart:typed_data';
import 'package:car_pulse/screens/serviceDetails.dart';
import 'package:car_pulse/service/car_service.dart';
import 'package:flutter/material.dart';
import '../model/ServiceInfo.dart';
import '../model/car.dart';
import 'addServiceInfo.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final Car selectedCar;

  ServiceHistoryScreen({required this.selectedCar});

  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
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
        title: Text('Service Book'),
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
                      rows: currCar.serviceRecords.map((serviceRecord) {
                        return DataRow(cells: [
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                _showFullStringDialog(
                                    context, serviceRecord.display);
                              },
                              child: Tooltip(
                                message: serviceRecord.display,
                                child: Text(
                                  serviceRecord.display.length > 15
                                      ? '${serviceRecord.display.substring(0, 15)}...'
                                      : serviceRecord.display,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                _navigateToServiceInfoScreen(serviceRecord);
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
                                _deleteServiceInfo(serviceRecord);
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
                builder: (context) => AddServiceScreen(
                  selectedCar: currCar,
                  onServiceAdded: (ServiceInfo newService) {
                    // This function will be called when a new service is added
                    // Use the newService callback to update currCar
                    setState(() {
                      //currCar.serviceRecords.add(newService);
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

  void _navigateToServiceInfoScreen(ServiceInfo serviceInfo) async{
    await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ServiceInfoDetails(serviceInfo: serviceInfo)));
  }

  void _deleteServiceInfo(ServiceInfo serviceRecord) {
    setState(() {
      widget.selectedCar.serviceRecords.remove(serviceRecord);
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
