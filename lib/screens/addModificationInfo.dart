import 'package:car_pulse/repository/car_storage.dart';
import 'package:flutter/material.dart';
import '../model/car.dart';
import '../model/ModificationInfo.dart';

typedef OnServiceAddedCallback = Function(ModificationInfo);

class AddModificationScreen extends StatefulWidget {
  final Car selectedCar;
  final Function onModificationAdded;

  const AddModificationScreen({
    Key? key,
    required this.selectedCar,
    required this.onModificationAdded,
  }) : super(key: key);

  @override
  _AddModificationScreenState createState() => _AddModificationScreenState();
}

class _AddModificationScreenState extends State<AddModificationScreen> {
  List<Car> cars = [];
  CarStorage carsStorage = CarStorage();

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Modification'),
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
                        DataColumn(label: SizedBox.shrink())
                      ],
                      rows: [
                        // Category
                        DataRow(cells: [
                          DataCell(Text('Category')),
                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: TextField(
                                controller: categoryController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Category',
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
                          DataCell(Text('Description')),
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

                        // Price
                        DataRow(cells: [
                          DataCell(Text('Price')),
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
                    onPressed: _saveModificationInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    child: const Text('Save Modification',
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

  void _saveModificationInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Modification?'),
          content: const Text('Do you want to save this modification?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveAndRedirect(); // Save the modification and navigate to a different page
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
    // Create a ModificationInfo object based on input data
    final ModificationInfo newModification = ModificationInfo(
      category: categoryController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
    );

    // Save the new modification to the selected car's modification records
    for (var car in cars) {
      if (car.make == widget.selectedCar.make &&
          car.model == widget.selectedCar.model) {
        car.modificationRecords.add(newModification);
        widget.selectedCar.modificationRecords.add(newModification);
        break;
      }
    }

    // Save the updated cars to SharedPreferences
    carsStorage.saveCarInfo(cars);

    // Navigate to the target screen after saving
    widget.onModificationAdded(newModification);
    Navigator.pop(context);
  }

  void loadCarData() async {
    List<Car> storedCars = await carsStorage.getCarInfo();
    setState(() {
      cars = storedCars;
    });
  }
}
