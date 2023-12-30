import 'package:car_pulse/repository/car_storage.dart';
import 'package:flutter/material.dart';
import '../enums/CategoryEnum.dart';
import '../enums/ConditionEnum.dart';
import '../model/car.dart';
import '../model/ServiceInfo.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  List<Car> cars = [];
  CarStorage carsStorage = CarStorage();

  Car selectedCar = Car(make: "Porsche", model: "911");
  final TextEditingController dateController = TextEditingController();
  final TextEditingController displayController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController odomController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  CategoryEnum selectedCategory = CategoryEnum.RegularService;
  ConditionEnum selectedCondition = ConditionEnum.New;
  DateTime? pickedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columnSpacing: 20.0,
                  dividerThickness: 1.0,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0)),
                  columns: [
                    DataColumn(label: Text('Attribute')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Service Date')),
                      DataCell(OutlinedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(pickedDate != null
                            ? pickedDate.toString().split(' ')[0]
                            : 'Select Date'),
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Odometer')),
                      DataCell(
                        Container(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: odomController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Odometer',
                            ),
                          ),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Display')),
                      DataCell(
                        Container(
                          child: TextField(
                            controller: displayController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Display Text',
                            ),
                          ),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Description')),
                      DataCell(
                        Container(
                          child: TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Description',
                            ),
                          ),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Category')),
                      DataCell(DropdownButton<CategoryEnum>(
                        value: selectedCategory,
                        onChanged: (CategoryEnum? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          }
                        },
                        items: CategoryEnum.values
                            .map<DropdownMenuItem<CategoryEnum>>(
                          (CategoryEnum value) {
                            return DropdownMenuItem<CategoryEnum>(
                              value: value,
                              child: Text(value.toString().split('.').last),
                            );
                          },
                        ).toList(),
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Condition')),
                      DataCell(DropdownButton<ConditionEnum>(
                        value: selectedCondition,
                        onChanged: (ConditionEnum? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCondition = newValue;
                            });
                          }
                        },
                        items: ConditionEnum.values
                            .map<DropdownMenuItem<ConditionEnum>>(
                          (ConditionEnum value) {
                            return DropdownMenuItem<ConditionEnum>(
                              value: value,
                              child: Text(value.toString().split('.').last),
                            );
                          },
                        ).toList(),
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Price')),
                      DataCell(
                        Container(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Price',
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveServiceInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  child: const Text('Save Service', style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
        dateController.text = pickedDate.toString();
      });
    }
  }

  void _saveServiceInfo() async {
    // Create a ServiceInfo object based on input data
    final ServiceInfo newService = ServiceInfo(
      dateService: DateTime.parse(dateController.text),
      odometer: int.parse(odomController.text),
      display: displayController.text,
      description: descriptionController.text,
      category: selectedCategory,
      condition: selectedCondition,
      price: double.parse(priceController.text),
    );

    if (cars.isNotEmpty) {
      int length = cars.length;
      print("Cars length: $length");
    }

    for (var car in cars) {
      if (car.make == selectedCar.make && car.model == selectedCar.model) {
        // To reset service records
        //car.serviceRecords.removeRange(0, car.serviceRecords.length);
        car.serviceRecords.add(newService);
        int length = car.serviceRecords.length;
        int lengthCars = cars.length;
        print("length: $length");
        print("Cars length: $lengthCars");

      }
    }
    // Save updated cars to SharedPreferences
    await CarStorage().saveCarInfo(cars);
  }

  void loadCarData() async {
    List<Car> storedCars = await carsStorage.getCarInfo();
    setState(() {
      cars = storedCars;
    });
  }
}
