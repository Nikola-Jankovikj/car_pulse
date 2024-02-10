import 'package:car_pulse/model/EditInfo.dart';
import 'package:car_pulse/service/car_service.dart';
import 'package:flutter/material.dart';
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
        title: const Text('Stats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[400], // Screen background color
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white, // Table background color
              ),
              child: DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(label: Text('Stat')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Engine')),
                    DataCell(Text(currCar.editRecord?.engine ?? 'Not set')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('HP')),
                    DataCell(Text('${currCar.editRecord?.hp} Hp')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Torque')),
                    DataCell(Text('${currCar.editRecord?.torque} Nm')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Fuel type')),
                    DataCell(Text('${currCar.editRecord?.fuelType.name}')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('0-100')),
                    DataCell(Text('${currCar.editRecord?.zeroToHundred} sec.')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Max speed')),
                    DataCell(Text('${currCar.editRecord?.maxSpeed} km/h')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Kerb weight')),
                    DataCell(Text('${currCar.editRecord?.kerbWeight} kg')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Tire size')),
                    DataCell(Text(currCar.editRecord?.tireSize ?? 'Not set')),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      //currCar.editRecord = newEdit;
                      // print("HERE");
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

  void loadCarData() async {
    List<Car> storedCars = await carService.loadAllCars();
    setState(() {
      cars = storedCars;
    });
  }
}
