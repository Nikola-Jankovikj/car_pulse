import 'package:car_pulse/model/ModificationInfo.dart';
import 'package:flutter/material.dart';
import '../model/ModificationInfo.dart';

class modification_planner extends StatelessWidget {
  final ModificationInfo modificationInfo;

  modification_planner({required this.modificationInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification Details'),
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
                  DataColumn(label: Text('Value'))
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Category')),
                    DataCell(Text('${modificationInfo.category}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Description')),
                    DataCell(Text('${modificationInfo.description}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Price')),
                    DataCell(Text('${modificationInfo.price}')),
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
