import 'package:car_pulse/screens/serviceDetails.dart';
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
  late Car selectedCar;

  @override
  void initState() {
    super.initState();
    selectedCar = widget.selectedCar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Book'),
      ),
      body: Container(
        color: Colors.grey[400], // Screen background color
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white, // Table background color
                ),
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(label: Text('Display Text')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: selectedCar.serviceRecords.map((serviceRecord) {
                    return DataRow(cells: [
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            _showFullStringDialog(context, serviceRecord.display);
                          },
                          child: Tooltip(
                            message: serviceRecord.display, // Full string
                            child: Text(
                              serviceRecord.display.length > 20
                                  ? '${serviceRecord.display.substring(0, 20)}...'
                                  : serviceRecord.display,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            _navigateToServiceInfoDetails(serviceRecord);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Button background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),
                          ),
                          child: const Text('Show', style: TextStyle(color: Colors.grey),),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddServiceScreen()),
            );
          },
          backgroundColor: Colors.green, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
          ),
          child: const Icon(Icons.add, color: Colors.white,), // Change the icon as needed
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

  void _navigateToServiceInfoDetails(ServiceInfo serviceInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceInfoDetails(serviceInfo: serviceInfo),
      ),
    );
  }
}
