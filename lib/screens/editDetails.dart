import 'package:flutter/material.dart';
import '../model/EditInfo.dart';

class EditInfoDetails extends StatelessWidget {
  final EditInfo editInfo;

  EditInfoDetails({required this.editInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stats'),
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
                    DataCell(Text('engine')),
                    DataCell(Text('${editInfo.engine}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('hp')),
                    DataCell(Text('${editInfo.hp}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('torque')),
                    DataCell(Text('${editInfo.torque}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('fuelType')),
                    DataCell(Text('${editInfo.fuelType.name}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('zeroToHundred')),
                    DataCell(Text('${editInfo.zeroToHundred}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('maxSpeed')),
                    DataCell(Text('${editInfo.maxSpeed}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('kerbWeight')),
                    DataCell(Text('${editInfo.kerbWeight}')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('tireSize')),
                    DataCell(Text('${editInfo.tireSize}')),
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
