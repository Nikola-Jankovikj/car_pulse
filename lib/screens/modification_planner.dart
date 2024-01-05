import 'package:flutter/material.dart';
import 'package:car_pulse/model/car.dart';
import 'package:car_pulse/model/ModificationInfo.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class CarStorage {
  static const _keyModificationInfo = 'modificationInfo';

  Future<void> saveModificationInfo(
      List<ModificationInfo> modifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String modificationInfoData = ModificationInfo.listToJson(modifications);
    await prefs.setString(_keyModificationInfo, modificationInfoData);
  }

  Future<List<ModificationInfo>> getModificationInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final modificationInfoData = prefs.getString(_keyModificationInfo);
    if (modificationInfoData != null) {
      return ModificationInfo.listFromJson(modificationInfoData);
    } else {
      // Default values if no saved data
      return [];
    }
  }
}

class ModificationPlannerScreen extends StatefulWidget {
  final Car selectedCar;

  ModificationPlannerScreen({Key? key, required this.selectedCar})
      : super(key: key);

  @override
  _ModificationPlannerScreenState createState() =>
      _ModificationPlannerScreenState();
}

class _ModificationPlannerScreenState extends State<ModificationPlannerScreen> {
  late List<ModificationInfo> _modifications;
  late Car _selectedCar;

  final CarStorage _carStorage = CarStorage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedCar = widget.selectedCar;
  }

  @override
  void initState() {
    super.initState();
    _modifications = [];
    _loadModificationInfo();
  }

  Future<void> _loadModificationInfo() async {
    final savedModifications = await _carStorage.getModificationInfo();
    setState(() {
      _modifications = savedModifications;
    });
  }

  Future<void> _saveModificationInfo() async {
    await _carStorage.saveModificationInfo(_modifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modification Planner'),
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
                  _selectedCar.photoBase64 != null
                      ? base64Decode(_selectedCar.photoBase64!)
                      : Uint8List(0),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "${_selectedCar.make} ${_selectedCar.model}",
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
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: _selectedCar.modifications
                          .asMap()
                          .entries
                          .map(
                            (entry) => DataRow(
                              cells: [
                                DataCell(Text(entry.value.category)),
                                DataCell(Text(entry.value.description)),
                                DataCell(Text(entry.value.price.toString())),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedCar.modifications
                                            .removeAt(entry.key);
                                      });
                                      _saveModificationInfo();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
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
          onPressed: () {
            _navigateToAddModificationScreen();
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

  void _navigateToAddModificationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddModificationScreen(selectedCar: _selectedCar),
      ),
    );

    if (result != null && result is ModificationInfo) {
      setState(() {
        _selectedCar.modifications.add(result);
      });

      if (!_modifications.contains(result)) {
        _modifications.add(result);
        await _saveModificationInfo();
      }
    }
  }
}

class AddModificationScreen extends StatefulWidget {
  final Car selectedCar;

  AddModificationScreen({Key? key, required this.selectedCar})
      : super(key: key);

  @override
  _AddModificationScreenState createState() => _AddModificationScreenState();
}

class _AddModificationScreenState extends State<AddModificationScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Modification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveModification();
              },
              child: Text('Save Modification'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveModification() async {
    final category = _categoryController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;

    if (category.isNotEmpty && description.isNotEmpty) {
      final newModification = ModificationInfo(
        category: category,
        description: description,
        price: price,
      );

      widget.selectedCar.modifications.add(newModification);

      // Save the modifications for the selected car only if it's a new modification
      if (!widget.selectedCar.modifications.contains(newModification)) {
        await CarStorage()
            .saveModificationInfo(widget.selectedCar.modifications);
      }

      Navigator.pop(context, newModification);
    } else {
      // Show an error message
    }
  }
}
