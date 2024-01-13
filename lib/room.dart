import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hotel_apps/bookingDetails.dart';
import 'package:hotel_apps/detailsRoom.dart';
import 'package:hotel_apps/favoriteList.dart';

class Room extends StatefulWidget {
  const Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> bookingData = [];
  List<String> name = [
    "Luxury Room",
    "Single Room",
    "Double Room",
    "Standard Room",
    "Beach View Room",
    "Solo Room",
  ];

  List<String> description = [
    "Spacious and elegantly designed room \nKing-sized bed with premium bedding \nBathroom with a bathtub \nKitchen provided",
    "Simple and comfortable designed room \nTwo single bed with comfortable bedding \nBathroom with basic amenities",
    "Ideal for couples or friends traveling together \nDouble bed with comfortable bedding \nAdequate space for a comfortable stay \nStandard amenities",
    "comfortable stay \nAffordable accommodation \nTwin beds depending on guest preference \nBathroom with standard amenities \n ",
    "Spectacular views of the beach or ocean \nlarge windows for enjoying the scenery \nComfortable sleeping arrangements with quality bedding \nBeach-themed decor for a relaxing ambiance ",
    "Designed for solo travelers seeking comfort \nSingle bed with cozy bedding \nBathroom with essential amenities \nAccess to basic hotel facilities, perfect for individual travelers",
  ];

  List<String> roomImage = [
    "images/luxury.jpg",
    "images/single.jpg",
    "images/double.jpg",
    "images/standard.jpg",
    "images/beach.jpg",
    "images/solo.jpg",
  ];

  List<String> price = [
    "RM200",
    "RM80",
    "RM160",
    "RM50",
    "RM100",
    "RM120",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Booking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/beach.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/cafe.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/chef.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/hallway.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('images/pic1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 380.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                viewportFraction: 0.8,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    height: 250,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              child: InkWell(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(roomImage[index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          name[index],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 16.0),
                            Column(
                              children: <Widget>[
                                Text(
                                  price[index],
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const Text(
                                  "/per night",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => detailsRoom(
                                  RoomName: name[index],
                                  RoomDescription: description[index],
                                  RoomImage: roomImage[index],
                                  RoomPrice: price[index],
                                  favoriteList: [],
                                ),
                              ),
                            );
                          },
                          child: Text("See detail"),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteList()),
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
