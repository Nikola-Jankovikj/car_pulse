import 'package:car_pulse/repository/car_storage.dart';
import 'package:flutter/material.dart';
import '../enums/CategoryEnum.dart';
import '../enums/ConditionEnum.dart';
import '../model/car.dart';
import '../model/ServiceInfo.dart';

typedef OnServiceAddedCallback = Function(ServiceInfo);

class AddServiceScreen extends StatefulWidget {
  final Car selectedCar;
  final Function onServiceAdded; // Define the callback

  const AddServiceScreen({
    Key? key,
    required this.selectedCar,
    required this.onServiceAdded, // Include the callback in the constructor
  }) : super(key: key);

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {

  List<Car> cars = [];
  CarStorage carsStorage = CarStorage();

  //Car selectedCar = Car(make: "Porsche", model: "911");
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
    super.initState();
    loadCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),

      ),
      body: Container(
        color: Colors.grey[400], // Light gray color for the screen background
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
                      color:
                          Colors.white, // White color for the table background
                    ),
                    child: DataTable(
                      columnSpacing: 20.0,
                      dividerThickness: 2.0,
                      columns: const [
                        DataColumn(label: SizedBox.shrink()),
                        DataColumn(label: SizedBox.shrink()),
                      ],
                      rows: [
                        // Service Date
                        DataRow(cells: [
                          const DataCell(Text('Service Date')),
                          DataCell(OutlinedButton(
                            onPressed: () => _selectDate(context),
                            child: Text(pickedDate != null
                                ? pickedDate.toString().split(' ')[0]
                                : 'Select Date'),
                          )),
                        ]),

// Odometer
                        DataRow(cells: [
                          const DataCell(Text('Odometer')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: odomController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Odometer',
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

// Display
                        DataRow(cells: [
                          const DataCell(Text('Display')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: displayController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Display Text',
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

// Description
                        DataRow(cells: [
                          const DataCell(Text('Description')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Description',
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

// Category
                        DataRow(cells: [
                          const DataCell(Text('Category')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: DropdownButton<CategoryEnum>(
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
                                      child: Text(
                                          value.toString().split('.').last),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ]),

// Condition
                        DataRow(cells: [
                          const DataCell(Text('Condition')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: DropdownButton<ConditionEnum>(
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
                                      child: Text(
                                          value.toString().split('.').last),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ]),
                        // Price
                        DataRow(cells: [
                          const DataCell(Text('Price')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: priceController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Price',
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
                    onPressed: _saveServiceInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    child: const Text('Save Service',
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

  void _saveServiceInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Service?'),
          content: const Text('Do you want to save this service?'),
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveAndRedirect()  {
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

    // Save the new service to the selected car's service records
    for (var car in cars) {
      if (car.make == widget.selectedCar.make &&
          car.model == widget.selectedCar.model) {
        car.serviceRecords.add(newService);
        widget.selectedCar.serviceRecords.add(newService);
        break;
      }
    }

    // Save the updated cars to SharedPreferences
    carsStorage.saveCarInfo(cars);

    // Navigate to the target screen after saving
    widget.onServiceAdded(newService);
    Navigator.pop(context);
  }

  void loadCarData() async {
    List<Car> storedCars = await carsStorage.getCarInfo();
    setState(() {
      cars = storedCars;
    });
  }
}
