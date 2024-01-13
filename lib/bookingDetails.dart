import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_apps/favoriteList.dart';
import 'package:hotel_apps/room.dart';
import 'package:http/http.dart' as http;

class bookingDetails extends StatefulWidget {
  const bookingDetails({Key? key}) : super(key: key);

  @override
  State<bookingDetails> createState() => _bookingDetailsState();
}

class _bookingDetailsState extends State<bookingDetails> {
  int _currentIndex = 2;
  String newPhone = '';

  List<Map<String, dynamic>> bookingData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.https(
      'hoteluser-16325-default-rtdb.asia-southeast1.firebasedatabase.app',
      'UserInfo.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data != null) {
          bookingData = data.entries.map((entry) {
            final Map<String, dynamic> userData = entry.value;
            return {
              'key': entry.key,
              'name': userData['name'],
              'phone': userData['phone'],
              'room': userData['room'],
              'checkInDate': userData['checkInDate'],
              'checkOutDate': userData['checkOutDate'],
            };
          }).toList();
          setState(() {});
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during data fetch: $error');
    }
  }

  Future<void> _deleteBooking(String key) async {
    final url = Uri.https(
      'hoteluser-16325-default-rtdb.asia-southeast1.firebasedatabase.app',
      'UserInfo/$key.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Booking deleted successfully');
        fetchData();
      } else {
        print('Failed to delete booking. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during booking deletion: $error');
    }
  }

  Future<void> _updatePhone(String key, String newPhone) async {
    final url = Uri.https(
      'hoteluser-16325-default-rtdb.asia-southeast1.firebasedatabase.app',
      'UserInfo/$key.json',
    );

    try {
      final response = await http.patch(
        url,
        body: jsonEncode({'phone': newPhone}),
      );

      if (response.statusCode == 200) {
        print('Phone number updated successfully');
        fetchData();
      } else {
        print(
            'Failed to update phone number. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during phone number update: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: ListView.builder(
        itemCount: bookingData.length,
        itemBuilder: (context, index) {
          final data = bookingData[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(data['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${data['phone'] ?? ''}'),
                  Text('Rooms: ${data['room']}'),
                  Text('Check In: ${data['checkInDate'] ?? ''}'),
                  Text('Check Out: ${data['checkOutDate'] ?? ''}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit Phone Number'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue: data['phone'] ?? '',
                                onChanged: (value) {
                                  newPhone = value;
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: 'New Phone Number'),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _updatePhone(data['key'], newPhone);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Cancel Booking'),
                          content: Text(
                              'Are you sure you want to cancel this booking?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteBooking(data['key']);
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteList(),
                ),
              );
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
    );
  }
}
