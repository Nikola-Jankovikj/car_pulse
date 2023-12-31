import 'package:flutter/material.dart';
import '../model/ServiceInfo.dart';

class ServiceInfoDetails extends StatelessWidget {
  final ServiceInfo serviceInfo;

  ServiceInfoDetails({required this.serviceInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
      ),
      body: Container(
        color: Colors.grey[400], // Screen background color
        child: Center(
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
                  DataColumn(label: Text('Attribute')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Display Text')),
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          _showFullStringDialog(context, serviceInfo.display);
                        },
                        child: Tooltip(
                          message: serviceInfo.display,
                          child: Text(
                            serviceInfo.display.length > 20
                                ? '${serviceInfo.display.substring(0, 20)}...'
                                : serviceInfo.display,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date')),
                    DataCell(Text('${serviceInfo.dateService}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Odometer')),
                    DataCell(Text('${serviceInfo.odometer}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Description')),
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          _showFullStringDialog(context, serviceInfo.description);
                        },
                        child: Tooltip(
                          message: serviceInfo.description,
                          child: Text(
                            serviceInfo.description.length > 20
                                ? '${serviceInfo.description.substring(0, 20)}...'
                                : serviceInfo.description,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Category')),
                    DataCell(Text('${serviceInfo.category.name}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Condition')),
                    DataCell(Text('${serviceInfo.condition.name}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Price')),
                    DataCell(Text('${serviceInfo.price}')),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullStringDialog(BuildContext context, String fullString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Full Text'),
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
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
