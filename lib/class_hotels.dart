import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hotels/hotels.dart';

List<Hotels> _hotels = [];
String uuid = '';

class ClassHotels extends StatefulWidget {
  static const routeName = '/';
  ClassHotels({Key? key}) : super(key: key);

  @override
  State<ClassHotels> createState() => _ClassHotelsState();
}

class _ClassHotelsState extends State<ClassHotels> {
  bool isLoading = false;
  bool hasError = false;
  bool isList = false;

  Dio _dio = Dio();

  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    getDataDio();
  }

  getDataDio() async {
    setState(() {
      isLoading = true;
      isList = true;
    });
    try {
      final response = await _dio
          .get('https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301');
      var data = response.data;
      _hotels = data.map<Hotels>((hotel) => Hotels.fromJson(hotel)).toList();
    } on DioError catch (error) {
      print(error.response?.data['message']);
      setState(() {
        errorMessage = error.response?.data['message'];
        hasError = true;
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isList = true;
              });
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isList = false;
              });
            },
            icon: Icon(Icons.grid_view_sharp),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                    ],
                  ),
                )
              : isList == true
                  ? LisstViewPage()
                  : GridViewPage(),
    );
  }
}

class DetailPage extends StatefulWidget {
  static const routeName = '/detail';
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = false;
  bool hasError = false;
  bool isList = false;
  var _hotelDetails;
  Dio _dio = Dio();
  List<String> images = [];
  List<String> servicesPaid = [];
  List<String> servicesFree = [];
  String name = '';
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    getDataDio();
  }

  getDataDio() async {
    setState(() {
      isLoading = true;
      isList = true;
    });
    try {
      final response = await _dio.get('https://run.mocky.io/v3/${uuid}');
      var data = response.data;
      _hotelDetails = HotelsDetails.fromJson(data);
      for (var item in _hotelDetails.photos) {
        images.add(item);
      }
      for (var item in _hotelDetails.services.paid) {
        servicesPaid.add(item);
      }
      for (var item in _hotelDetails.services.free) {
        servicesFree.add(item);
      }
      name = _hotelDetails.name;
    } on DioError catch (error) {
      setState(() {
        Text(errorMessage);
        errorMessage = error.response?.data['message'];
        hasError = true;
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${name}'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2,
                          enlargeCenterPage: true,
                        ),
                        items: images
                            .map(
                              (item) => Container(
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/${item}',
                                    fit: BoxFit.cover,
                                    width: 500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    ShowDataAddress(
                      detail: _hotelDetails.address.country,
                      left: 10,
                      top: 10,
                      right: 0,
                      bottom: 0,
                      name: 'Страна: ',
                    ),
                    ShowDataAddress(
                      detail: _hotelDetails.address.city,
                      left: 10,
                      top: 5,
                      right: 0,
                      bottom: 0,
                      name: 'Город: ',
                    ),
                    ShowDataAddress(
                      detail: _hotelDetails.address.street,
                      left: 10,
                      top: 5,
                      right: 0,
                      bottom: 0,
                      name: 'Улица: ',
                    ),
                    ShowDataAddress(
                      detail: _hotelDetails.rating.toString(),
                      left: 10,
                      top: 5,
                      right: 0,
                      bottom: 0,
                      name: 'Рейтинг: ',
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 30, 20, 5),
                      child: const Text(
                        'Сервесы',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Платные',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Бесплатно',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Row(
                        children: [
                          ShowServices(services: servicesPaid),
                          ShowServices(services: servicesFree),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class GridViewPage extends StatelessWidget {
  const GridViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      shrinkWrap: true,
      children: [
        ..._hotels.map(
          (hotel) {
            return Container(
              child: Card(
                margin: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                elevation: 8,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/${hotel.poster}'),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      child: ListTile(
                        title: Text(
                          hotel.name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            uuid = hotel.uuid;
                            Navigator.of(context).pushNamed('/detail');
                          },
                          child: const Text('Подробнее'),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class LisstViewPage extends StatelessWidget {
  const LisstViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ..._hotels.map(
          (hotel) {
            return Container(
              height: 200,
              width: 200,
              child: Card(
                margin: EdgeInsets.fromLTRB(12, 2, 12, 2),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                elevation: 8,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/${hotel.poster}'),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: ListTile(
                              title: Text(hotel.name),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              uuid = hotel.uuid;
                              Navigator.of(context).pushNamed('/detail');
                            },
                            child: Text('Подробнее'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class ShowDataAddress extends StatelessWidget {
  ShowDataAddress({
    Key? key,
    required this.detail,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.name,
  }) : super(key: key);
  dynamic detail;
  double left, top, right, bottom;
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: [
                TextSpan(text: name),
                TextSpan(
                  text: detail,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowServices extends StatelessWidget {
  ShowServices({Key? key, required this.services}) : super(key: key);
  List<String> services = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...services.map(
              (paid) => Container(
                child: Column(
                  children: [
                    Text(paid),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
