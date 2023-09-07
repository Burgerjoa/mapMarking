import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(searchController: _searchController),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final TextEditingController searchController;

  const MyHomePage({required this.searchController});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MILESTONE beta",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 버튼을 누르면 검색 기능을 추가할 수 있습니다.
              // 여기에 검색 기능을 구현하세요.
              // 예를 들면 showDialog 등을 사용하여 검색창을 띄울 수 있습니다.
              // widget.searchController.text 에 검색어가 들어있을 것입니다.
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          map_widget(),
          SettingScreen(),
          // PublicTransportScreen(),
          // NavigationScreen(),
          // NearbyScreen(),
          // BookmarksScreen(),
          // MyLogScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "설정",
          ),
        ],
        selectedItemColor: Colors.greenAccent,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             title: Text("내 위치"),
      //             content: Text("현재 위치"),
      //             actions: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: Text("닫기"),
      //               )
      //             ],
      //           );
      //         });
      //   },
      //   child: Icon(Icons.my_location),
      // ),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 검색 결과를 보여주는 화면을 구현하세요.
    return Center(
      child: Text('검색 결과 화면'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 검색어 입력 중에 보여줄 예상 검색어 목록을 구현하세요.
    return Center(
      child: Text('예상 검색어 목록'),
    );
  }
}

// 홈 화면
class map_widget extends StatefulWidget {
  const map_widget({Key? key, required}) : super(key: key);

  @override
  State<map_widget> createState() => _map_widgetState();
}

class _map_widgetState extends State<map_widget> {
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화된 경우, 사용자에게 위치 서비스를 활성화하라는 메시지를 보여줄 수 있음
      return;
    }

    // 위치 권한 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 위치 권한이 거부된 경우, 사용자에게 위치 권한을 부여하라는 메시지를 보여줄 수 있음
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition();
    final cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _myLocationEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> places = [
      {
        'name': '',
        'latitude': 37.6259014,
        'longitude': 127.0269987,
      },
      {
        'name': 'Place 2',
        'latitude': 37.532700,
        'longitude': 127.024712,
      },
      {
        'name': 'Place 3',
        'latitude': 37.532800,
        'longitude': 127.024812,
      },
      {
        'name': 'Place 4',
        'latitude': 37.532900,
        'longitude': 127.024912,
      },
      {
        'name': 'Place 5',
        'latitude': 37.533000,
        'longitude': 127.025012,
      },
      {
        'name': 'Place 6',
        'latitude': 37.533100,
        'longitude': 127.025112,
      },
      {
        'name': 'Place 7',
        'latitude': 38.533100,
        'longitude': 127.025112,
      },
    ];
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.532600, 127.024612), // 서울 시청 위치
              zoom: 18,
            ),
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: false,
            markers: Set<Marker>.of(places.map((place) {
              return Marker(
                markerId: MarkerId(place['name']),
                position: LatLng(place['latitude'], place['longitude']),
                infoWindow: InfoWindow(title: place['name']),
              );
            })),
            onMapCreated: (controller) => _controller = controller,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 8, // 그림자 크기
              child: Icon(Icons.my_location),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글기
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class marker_widget extends StatelessWidget {
  const marker_widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PublicTransportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("123 화면"),
      ),
      body: Center(
        child: Text("대중교통 리스트"),
      ),
    );
  }
}
class SettingScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("설정"),
    ),
    body: ListView(
      children: [
ListTile(
  title: Text("내 정보"),
onTap: () {
},
),
Divider(), // 구분선을 추가하여 항목을 구분할 수 있습니다.
ListTile(
  title: Text("알림 설정"),
onTap: () {
},
),
Divider(),
ListTile(
title: Text(
"로그아웃",
style: TextStyle(
color: Colors.red, // 텍스트 색상을 빨간색으로 설정
),
),
onTap: () {
// 로그아웃 로직을 여기에 추가하세요.
},
)
// 여기에 다른 설정 항목들을 추가할 수 있습니다.
],
),
);
}
}

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내비게이션 화면"),
      ),
      body: Center(
        child: Text("내비게이션 지도"),
      ),
    );
  }
}

class NearbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("주변 화면"),
      ),
      body: Center(
        child: Text("주변에 뭐 있나"),
      ),
    );
  }
}

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("즐겨찾기 화면"),
      ),
      body: Center(
        child: Text("즐겨찾기 리스트"),
      ),
    );
  }
}

class MyLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("마이로그 화면"),
      ),
      body: Center(
        child: Text("마이로그 이것저것"),
      ),
    );
  }
}
