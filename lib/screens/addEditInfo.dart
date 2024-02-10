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
    // Initialize controllers with the current values
    engineController.text = widget.selectedCar.editRecord?.engine ?? '';
    hpController.text = widget.selectedCar.editRecord?.hp.toString() ?? '';
    torqueController.text = widget.selectedCar.editRecord?.torque.toString() ?? '';
    zeroToHundredController.text = widget.selectedCar.editRecord?.zeroToHundred.toString() ?? '';
    maxSpeedController.text = widget.selectedCar.editRecord?.maxSpeed.toString() ?? '';
    maxSpeedController.text = widget.selectedCar.editRecord?.maxSpeed.toString() ?? '';
    kerbWeightController.text = widget.selectedCar.editRecord?.kerbWeight.toString() ?? '';
    tireSizeController.text = widget.selectedCar.editRecord?.tireSize.toString() ?? '';
    selectedFuelType = widget.selectedCar.editRecord?.fuelType ?? FuelType.Petrol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stats'),
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
                          const DataCell(Text('Engine type')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: engineController,
                                decoration: InputDecoration(
                                  hintText: 'Enter engine',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          const DataCell(Text('HP')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: hpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter horsepower',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                                controller: torqueController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter torque',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),

                        // FuelType
                        // DataRow(cells: [
                        //   const DataCell(Text('FuelType')),
                        //   DataCell(
                        //     SizedBox(
                        //       width: 200,
                        //       height: 50,
                        //       child: DropdownButton<FuelType>(
                        //         value: selectedFuelType,
                        //         onChanged: (FuelType? newValue) {
                        //           if (newValue != null) {
                        //             setState(() {
                        //               selectedFuelType = newValue;
                        //             });
                        //           }
                        //         },
                        //         items: FuelType.values
                        //             .map<DropdownMenuItem<FuelType>>(
                        //           (FuelType value) {
                        //             return DropdownMenuItem<FuelType>(
                        //               value: value,
                        //               child: Text(
                        //                   value.toString().split('.').last),
                        //             );
                        //           },
                        //         ).toList(),
                        //       ),
                        //     ),
                        //   ),
                        // ]),
                        DataRow(cells: [
                          const DataCell(Text('FuelType')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: DropdownButton<FuelType>(
                                value: selectedFuelType, // Set initial value here
                                onChanged: (FuelType? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedFuelType = newValue;
                                    });
                                  }
                                },
                                items: FuelType.values.map<DropdownMenuItem<FuelType>>(
                                      (FuelType value) {
                                    return DropdownMenuItem<FuelType>(
                                      value: value,
                                      child: Text(value.toString().split('.').last),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ]),

                        // zeroToHundred
                        DataRow(cells: [
                          const DataCell(Text('0-100')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: zeroToHundredController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter 0-100',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          const DataCell(Text('Top speed')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: maxSpeedController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter top speed',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          const DataCell(Text('Kerb weight')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: kerbWeightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter kerb weight',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                          const DataCell(Text('Tire size')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: tireSizeController,
                                decoration: InputDecoration(
                                  hintText: 'Enter tire size',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    child: const Text('Save Stats',
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
        hp: double.parse(hpController.text),
        torque: double.parse(torqueController.text),
        fuelType: selectedFuelType,
        zeroToHundred: double.parse(zeroToHundredController.text),
        maxSpeed: int.parse(maxSpeedController.text),
        kerbWeight: int.parse(kerbWeightController.text),
        tireSize: tireSizeController.text);

    // Save the new Edit to the selected car's edit records
    for (var car in cars) {
      if (car.make == widget.selectedCar.make &&
          car.model == widget.selectedCar.model) {
        car.editRecord = newEdit;
        widget.selectedCar.editRecord = newEdit;
        print(car.editRecord);
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
