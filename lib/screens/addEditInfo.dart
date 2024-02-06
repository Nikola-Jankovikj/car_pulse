import 'package:car_pulse/model/EditInfo.dart';
import 'package:car_pulse/repository/car_storage.dart';
import 'package:flutter/material.dart';
import '../enums/FuelType.dart';
import '../model/car.dart';
import '../model/EditInfo.dart';

typedef OnEditAddedCallback = Function(EditInfo);

class AddEditScreen extends StatefulWidget {
  final Car selectedCar;
  final Function onEditAdded;

  const AddEditScreen({
    Key? key,
    required this.selectedCar,
    required this.onEditAdded,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  List<Car> cars = [];
  CarStorage carsStorage = CarStorage();

  final TextEditingController engineController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController torqueController = TextEditingController();
  final TextEditingController zeroToHundredController = TextEditingController();
  final TextEditingController maxSpeedController = TextEditingController();
  final TextEditingController kerbWeightController = TextEditingController();
  final TextEditingController tireSizeController = TextEditingController();
  FuelType selectedFuelType = FuelType.Petrol;

  @override
  void initState() {
    super.initState();
    loadCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit car info'),
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: DataTable(
                      columnSpacing: 20.0,
                      dividerThickness: 2.0,
                      columns: const [
                        DataColumn(label: SizedBox.shrink()),
                        DataColumn(label: SizedBox.shrink()),
                      ],
                      rows: [
                        // engine
                        DataRow(cells: [
                          const DataCell(Text('engine')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: engineController,
                                decoration: InputDecoration(
                                  hintText: 'Enter engine',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // HP
                        DataRow(cells: [
                          const DataCell(Text('hp')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: hpController,
                                decoration: InputDecoration(
                                  hintText: 'Enter horsepower',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // Torque
                        DataRow(cells: [
                          const DataCell(Text('Torque')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: torqueController,
                                decoration: InputDecoration(
                                  hintText: 'Enter torque',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // FuelType
                        DataRow(cells: [
                          const DataCell(Text('FuelType')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: DropdownButton<FuelType>(
                                value: selectedFuelType,
                                onChanged: (FuelType? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedFuelType = newValue;
                                    });
                                  }
                                },
                                items: FuelType.values
                                    .map<DropdownMenuItem<FuelType>>(
                                  (FuelType value) {
                                    return DropdownMenuItem<FuelType>(
                                      value: value,
                                      child: Text(
                                          value.toString().split('.').last),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ]),

                        // zeroToHundred
                        DataRow(cells: [
                          const DataCell(Text('zeroToHundred')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: zeroToHundredController,
                                decoration: InputDecoration(
                                  hintText: 'Enter 0-100km/h',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // maxSpeed
                        DataRow(cells: [
                          const DataCell(Text('maxSpeed')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: maxSpeedController,
                                decoration: InputDecoration(
                                  hintText: 'Enter max speed',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // kerbWeight
                        DataRow(cells: [
                          const DataCell(Text('kerbWeight')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: kerbWeightController,
                                decoration: InputDecoration(
                                  hintText: 'Enter kerb weight',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // tireSize
                        DataRow(cells: [
                          const DataCell(Text('tireSize')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: tireSizeController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your tire size',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveEditInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    child: const Text('Save Edit',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveEditInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Edit?'),
          content: const Text('Do you want to save the stats?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveAndRedirect(); // Save the service and navigate to a different page
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveAndRedirect() {
    // Create a EditInfo object based on input data
    final EditInfo newEdit = EditInfo(
        engine: engineController.text,
        hp: int.parse(hpController.text),
        torque: int.parse(torqueController.text),
        fuelType: selectedFuelType,
        zeroToHundred: int.parse(zeroToHundredController.text),
        maxSpeed: int.parse(maxSpeedController.text),
        kerbWeight: int.parse(kerbWeightController.text),
        tireSize: tireSizeController.text);

    // Save the new Edit to the selected car's edit records
    for (var car in cars) {
      if (car.make == widget.selectedCar.make &&
          car.model == widget.selectedCar.model) {
        car.editRecords.add(newEdit);
        widget.selectedCar.editRecords.add(newEdit);
        break;
      }
    }

    // Save the updated cars to SharedPreferences
    carsStorage.saveCarInfo(cars);

    // Navigate to the target screen after saving
    widget.onEditAdded(newEdit);
    Navigator.pop(context);
  }

  void loadCarData() async {
    List<Car> storedCars = await carsStorage.getCarInfo();
    setState(() {
      cars = storedCars;
    });
  }
}
