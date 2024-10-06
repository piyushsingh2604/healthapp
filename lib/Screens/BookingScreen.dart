// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'aboutscreen.dart';
// import 'package:gap/gap.dart';

// class Bookingscreen extends StatefulWidget {
//   final String userid;
//   Bookingscreen({required this.userid});

//   @override
//   State<Bookingscreen> createState() => _BookingscreenState();
// }

// class _BookingscreenState extends State<Bookingscreen> {
//   TextEditingController _dateController = TextEditingController();
//   TextEditingController _timeController = TextEditingController();
//   TextEditingController _patientNameController = TextEditingController();
//   TextEditingController _mobileController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();

//   @override
//   void dispose() {
//     _dateController.dispose();
//     _timeController.dispose();
//     _patientNameController.dispose();
//     _mobileController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   void _submitBooking() async {
//     final patientName = _patientNameController.text;
//     final mobile = _mobileController.text;
//     final description = _descriptionController.text;
//     final date = _dateController.text;
//     final time = _timeController.text;

//     String userId = widget.userid;

//     try {
//       await FirebaseFirestore.instance.collection('appointments').add({
//         'userId': userId,
//         'patientName': patientName,
//         'mobile': mobile,
//         'description': description,
//         'date': date,
//         'time': time,
//       });
//       print("Appointment added successfully");

//       // Clear fields
//       _patientNameController.clear();
//       _mobileController.clear();
//       _descriptionController.clear();
//       _dateController.clear();
//       _timeController.clear();

//       // Navigate to Aboutscreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Aboutscreen(userid: userId),
//         ),
//       );
//     } catch (e) {
//       print("Failed to add appointment: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon:
//               Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 25),
//         ),
//         title: Text("Appointment Booking",
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 height: 190,
//                 width: 250,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage('assets/appointment.jpg'),
//                       fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 25, top: 20),
//               child: Text("Enter Patient Details",
//                   style: TextStyle(color: Colors.grey, fontSize: 16)),
//             ),
//             _buildTextField("Patient Name*", _patientNameController),
//             _buildTextField("Mobile*", _mobileController),
//             _buildTextField("Description*", _descriptionController),
//             _buildDatePickerField("Select Date*", _dateController),
//             _buildTimePickerField("Select Time*", _timeController),
//             Padding(
//               padding: const EdgeInsets.only(left: 30, right: 20, top: 25),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigo[900],
//                   minimumSize: Size(MediaQuery.of(context).size.width, 50),
//                 ),
//                 onPressed: _submitBooking,
//                 child: Text("Book Appointment",
//                     style: TextStyle(color: Colors.white, fontSize: 17)),
//               ),
//             ),
//             Gap(30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String hintText, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//       child: Container(
//         height: 45,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             color: Colors.grey[400], borderRadius: BorderRadius.circular(30)),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: TextField(
//             controller: controller,
//             cursorHeight: 16,
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: hintText,
//               hintStyle: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePickerField(
//       String hintText, TextEditingController controller) {
//     return GestureDetector(
//       onTap: () async {
//         FocusScope.of(context).requestFocus(FocusNode());
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2024, 1),
//           lastDate: DateTime(2025, 1),
//         );

//         if (pickedDate != null) {
//           setState(() {
//             controller.text =
//                 "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//           });
//         }
//       },
//       child: _buildTextField(hintText, controller),
//     );
//   }

//   Widget _buildTimePickerField(
//       String hintText, TextEditingController controller) {
//     return GestureDetector(
//       onTap: () async {
//         FocusScope.of(context).requestFocus(FocusNode());
//         TimeOfDay? pickedTime = await showTimePicker(
//           context: context,
//           initialTime: TimeOfDay.now(),
//         );

//         if (pickedTime != null) {
//           setState(() {
//             controller.text = "${pickedTime.hour}:${pickedTime.minute}";
//           });
//         }
//       },
//       child: _buildTextField(hintText, controller),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'aboutscreen.dart';
import 'package:gap/gap.dart';

class Bookingscreen extends StatefulWidget {
  final String userid;
  final String currentid;
  final String profileuserName;

  Bookingscreen({
    required this.userid,
    required this.currentid,
    required this.profileuserName,
  });

  @override
  State<Bookingscreen> createState() => _BookingscreenState();
}

class _BookingscreenState extends State<Bookingscreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _patientNameController.dispose();
    _mobileController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitBooking() async {
    final patientName = _patientNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final description = _descriptionController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();

    String userId = widget.userid;

    // Check if any required field is empty
    if (patientName.isEmpty ||
        mobile.isEmpty ||
        description.isEmpty ||
        date.isEmpty ||
        time.isEmpty) {
      _showAlertDialog(
          "Missing Information", "Please fill in all required fields.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientName': patientName,
        'mobile': mobile,
        'date': date,
        'time': time,
        'description': description,
        'doctorName': widget.profileuserName,
        'userId': userId,
        'senderId': widget.currentid,
      });

      print("Appointment added successfully");

      // Clear fields
      _patientNameController.clear();
      _mobileController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _timeController.clear();

      Navigator.pop(context);
    } catch (e) {
      print("Failed to add appointment: $e");
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 25),
        ),
        title: Text("Appointment Booking",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 190,
                width: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/appointment.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 20),
              child: Text("Enter Patient Details",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 7, left: 20, right: 20),
                  child: TextField(
                    readOnly: true,
                    cursorHeight: 16,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Dr.${widget.profileuserName}',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            _buildTextField("Patient Name*", _patientNameController),
            _buildTextField("Mobile*", _mobileController),
            _buildTextField("Description*", _descriptionController),
            _buildDatePickerField("Select Date*", _dateController),
            _buildTimePickerField("Select Time*", _timeController),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, top: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                ),
                onPressed: _submitBooking,
                child: Text("Book Appointment",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
            ),
            Gap(30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            controller: controller,
            cursorHeight: 16,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
      String hintText, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus(); // Unfocus the text field
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2025, 1),
        );

        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd MMMM yyyy').format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        // Prevent focusing
        child: _buildTextField(hintText, controller),
      ),
    );
  }

  Widget _buildTimePickerField(
      String hintText, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus(); // Unfocus the text field
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            controller.text =
                "${pickedTime.hourOfPeriod}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.period == DayPeriod.am ? 'AM' : 'PM'}";
          });
        }
      },
      child: AbsorbPointer(
        // Prevent focusing
        child: _buildTextField(hintText, controller),
      ),
    );
  }
}
