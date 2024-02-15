import 'package:flutter/material.dart';
import '../model/car.dart';
import '../repository/car_storage.dart';
import '../service/notification_service.dart';

class UpcomingService extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final Car selectedCar;

  const UpcomingService({
    Key? key,
    required this.selectedCar,
    this.onDateSelected,
  }) : super(key: key);

  @override
  _UpcomingServiceState createState() => _UpcomingServiceState();
}

class _UpcomingServiceState extends State<UpcomingService> {
  List<Car> cars = [];
  CarStorage carsStorage = CarStorage();
  late DateTime selectedDate; // Declare selectedDate as a late variable

  @override
  void initState() {
    super.initState();
    loadCarData();
    selectedDate = DateTime.now(); // Initialize selectedDate in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Service'),
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text above the date picker
                const Text(
                  'Select the last service date.\n The next service date will be calculated automatically',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Date picker
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.green, // Text color
                              onPrimary: Colors.white, // Text color when selected
                              surface: Colors.white, // Background color
                              onSurface: Colors.black, // Text color on background
                            ),
                          ),
                          child: child!,
                        );
                      },
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                        if (widget.onDateSelected != null) {
                          widget.onDateSelected!(pickedDate);
                        }
                      }
                    });
                  },
                  child: Text(selectedDate != null
                      ? selectedDate.toString().split(' ')[0]
                      : 'Select Date',
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),
                // Save button
                ElevatedButton(
                  onPressed: () {
                    // Save the selected date to the car's information
                    widget.selectedCar.lastServiceDate = selectedDate;
                    save(widget.selectedCar, selectedDate);

                    // If a callback function is provided, invoke it with the selected date
                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(selectedDate);
                    }


                    // Close the UpcomingService screen
                    //Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(Car selectedCar, DateTime lastServiceDate) {
      // Create a EditInfo object based on input data
    print("cars length: "+ cars.length.toString());
      // Save the new Edit to the selected car's edit records
      for (var car in cars) {
        if (car.make == widget.selectedCar.make &&
            car.model == widget.selectedCar.model) {
          car.lastServiceDate = lastServiceDate;
          widget.selectedCar.lastServiceDate = lastServiceDate;
          // car.upcomingServiceDate = lastServiceDate.add(const Duration(days: 365));
          // widget.selectedCar.upcomingServiceDate = lastServiceDate.add(const Duration(days: 365));
          car.upcomingServiceDate = lastServiceDate.add(const Duration(minutes: 1));
          widget.selectedCar.upcomingServiceDate = lastServiceDate.add(const Duration(minutes: 1));
          widget.selectedCar.setNextServiceDate();

          print("last: " + widget.selectedCar.lastServiceDate.toString());
          print("next: " + widget.selectedCar.upcomingServiceDate.toString());
          break;
        }
      }

    NotificationService.scheduleNotification(
      selectedCar.id.hashCode, // Assuming car has an ID
      selectedCar.make,
      selectedCar.model,
      selectedCar.upcomingServiceDate as DateTime,
    );

      // Save the updated cars to SharedPreferences
      carsStorage.saveCarInfo(cars);

      Navigator.pop(context);
  }

  void loadCarData() async {
    List<Car> storedCars = await carsStorage.getCarInfo();
    setState(() {
      cars = storedCars;
    });
  }
}
