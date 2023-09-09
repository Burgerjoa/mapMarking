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
      appBar:
      AppBar(
        title: RichText(
          text: TextSpan(
            children: <TextSpan> [
              TextSpan(
                text: "MILESTONE ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "YourNormalFont", // 일반 글꼴 이름으로 변경해야 합니다.
                ),
              ),
              TextSpan(
                text: "beta",
                style: TextStyle(
                  color: Colors.yellow,
                  fontStyle: FontStyle.italic, // 필기체 글꼴 이름으로 변경해야 합니다.
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 10,
        // leading: IconButton(
        //   icon: Icon(Icons.settings), // 설정 아이콘
        //   onPressed: () {
        //     // 설정 버튼을 눌렀을 때 이동할 화면을 여기에 추가
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => SettingScreen()),
        //     );
        //   },
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      drawer: Drawer( // endDrawer를 사용하여 측면에서 설정 창 표시
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // 설정 1을 선택했을 때의 동작을 추가하세요.
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("My"),
              onTap: () {
                // 설정 2를 선택했을 때의 동작을 추가하세요.
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                // 설정 2를 선택했을 때의 동작을 추가하세요.
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Log Out"),
              onTap: () {
                // 설정 2를 선택했을 때의 동작을 추가하세요.
              },
            ),
            // 추가적인 설정 항목을 여기에 추가하세요.
          ],
        ),
      ),
      body:Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index){
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              map_widget(),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              width: 100,
              height: 65,
              color: Colors.white.withOpacity(0.4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4),
                    Text(
                      ": 12",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )
                    )
                  ],
                )
              ),
            ),
          )
        ],
      )
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

