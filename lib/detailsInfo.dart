import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_apps/bookingDetails.dart';
import 'package:hotel_apps/favoriteList.dart';
import 'package:hotel_apps/room.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(details());
}

class details extends StatefulWidget {
  @override
  _details createState() => _details();
}

class _details extends State<details> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _numberOfRoom = 1;
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 1));
  final _formKey = GlobalKey<FormState>();
  String? _error;
  int _currentIndex = 0;
  List<Map<String, dynamic>> bookingData = [];

  void infoUser() async {
    final url = Uri.https(
      'hoteluser-16325-default-rtdb.asia-southeast1.firebasedatabase.app',
      'UserInfo.json',
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'room': _numberOfRoom.toInt(),
          'checkInDate': formatDate(_checkInDate),
          'checkOutDate': formatDate(_checkOutDate)
        }),
      );

      if (response.statusCode == 200) {
        print('signed up success!');
      } else {
        setState(() {
          _error = 'Failed to signup';
        });
      }
    } catch (error) {
      print('Error during signUp request: $error');
      setState(() {
        _error =
            'An error occurred while trying to log in. Please try again later.';
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        hintColor: const Color.fromARGB(255, 148, 121, 112),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personal Details'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                Row(
                  children: [
                    Text('Number of room:'),
                    DropdownButton<int>(
                      value: _numberOfRoom,
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() {
                            _numberOfRoom = value;
                          });
                        }
                      },
                      items: List.generate(10, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text((index + 1).toString()),
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Check In:'),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _checkInDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != _checkInDate) {
                          setState(() {
                            _checkInDate = pickedDate;
                          });
                        }
                      },
                      child:
                          Text(DateFormat('MMM d, yyyy').format(_checkInDate)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Check Out:'),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _checkOutDate,
                          firstDate: _checkInDate,
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (pickedDate != null && pickedDate != _checkOutDate) {
                          setState(() {
                            _checkOutDate = pickedDate;
                          });
                        }
                      },
                      child:
                          Text(DateFormat('MMM d, yyyy').format(_checkOutDate)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                    infoUser();
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Booking',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Room()),
                );
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoriteList()));
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bookingDetails()),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Are you sure you want to book the  room?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bookingDetails()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
