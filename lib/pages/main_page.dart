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
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
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
        drawer: Drawer(
          // endDrawer를 사용하여 측면에서 설정 창 표시
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
        body: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
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
                    Text(": 12",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ))
                  ],
                )),
              ),
            )
          ],
        ));
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
  void initState() {
    super.initState();
    _getCurrentLocation(); // initState에서 _getCurrentLocation를 호출하여 초기 실행합니다.
  }

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
      {'name': '', 'latitude': 37.6259014, 'longitude': 127.0269987},
      {'name': '', 'latitude': 37.6256384, 'longitude': 127.0267982},
      {'name': '', 'latitude': 37.6256384, 'longitude': 127.0267982},
      {'name': '', 'latitude': 37.6259014, 'longitude': 127.0269987},
      {'name': '', 'latitude': 37.6263093, 'longitude': 127.0272992},
      {'name': '', 'latitude': 37.6259765, 'longitude': 127.0273602},
      {'name': '', 'latitude': 37.6258148, 'longitude': 127.0274303},
      {'name': '', 'latitude': 37.6261921, 'longitude': 127.0272894},
      {'name': '', 'latitude': 37.6263433, 'longitude': 127.0270496},
      {'name': '', 'latitude': 37.6263503, 'longitude': 127.0278991},
      {'name': '', 'latitude': 37.626282, 'longitude': 127.0283532},
      {'name': '', 'latitude': 37.6264754, 'longitude': 127.0277729},
      {'name': '', 'latitude': 37.6265501, 'longitude': 127.0280891},
      {'name': '', 'latitude': 37.6265694, 'longitude': 127.0282475},
      {'name': '', 'latitude': 37.6260126, 'longitude': 127.02847},
      {'name': '', 'latitude': 37.625849, 'longitude': 127.0282908},
      {'name': '', 'latitude': 37.6261901, 'longitude': 127.0281391},
      {'name': '', 'latitude': 37.6265168, 'longitude': 127.0284181},
      {'name': '', 'latitude': 37.6259824, 'longitude': 127.0280852},
      {'name': '', 'latitude': 37.6260169, 'longitude': 127.0278921},
      {'name': '', 'latitude': 37.6260158, 'longitude': 127.0277562},
      {'name': '', 'latitude': 37.625881, 'longitude': 127.0278033},
      {'name': '', 'latitude': 37.6262473, 'longitude': 127.0285235},
      {'name': '', 'latitude': 37.6264327, 'longitude': 127.0280567},
      {'name': '', 'latitude': 37.62538, 'longitude': 127.0293391},
      {'name': '', 'latitude': 37.625281, 'longitude': 127.0293518},
      {'name': '', 'latitude': 37.6266718, 'longitude': 127.0286426},
      {'name': '', 'latitude': 37.6256418, 'longitude': 127.0293924},
      {'name': '', 'latitude': 37.6258187, 'longitude': 127.0289936},
      {'name': '', 'latitude': 37.6262223, 'longitude': 127.0287618},
      {'name': '', 'latitude': 37.6255232, 'longitude': 127.029224},
      {'name': '', 'latitude': 37.6255232, 'longitude': 127.029224},
      {'name': '', 'latitude': 37.6257985, 'longitude': 127.0287333},
      {'name': '', 'latitude': 37.6255253, 'longitude': 127.0283743},
      {'name': '', 'latitude': 37.6250691, 'longitude': 127.0287881},
      {'name': '', 'latitude': 37.6250691, 'longitude': 127.0287881},
      {'name': '', 'latitude': 37.6250691, 'longitude': 127.0287881},
      {'name': '', 'latitude': 37.6250691, 'longitude': 127.0287881},
      {'name': '', 'latitude': 37.625696, 'longitude': 127.0283155},
      {'name': '', 'latitude': 37.6256128, 'longitude': 127.028056},
      {'name': '', 'latitude': 37.6255938, 'longitude': 127.0279429},
      {'name': '', 'latitude': 37.6255132, 'longitude': 127.0280006},
      {'name': '', 'latitude': 37.625523, 'longitude': 127.0281025},
      {'name': '', 'latitude': 37.6256085, 'longitude': 127.0286338},
      {'name': '', 'latitude': 37.6256085, 'longitude': 127.0286338},
      {'name': '', 'latitude': 37.6254547, 'longitude': 127.0274576},
      {'name': '', 'latitude': 37.62551, 'longitude': 127.0276155},
      {'name': '', 'latitude': 37.6252405, 'longitude': 127.0277096},
      {'name': '', 'latitude': 37.6247968, 'longitude': 127.0274435},
      {'name': '', 'latitude': 37.6251348, 'longitude': 127.026918},
      {'name': '', 'latitude': 37.6254066, 'longitude': 127.0270957},
      {'name': '', 'latitude': 37.6253559, 'longitude': 127.0275042},
      {'name': '', 'latitude': 37.6253843, 'longitude': 127.0276625},
      {'name': '', 'latitude': 37.6246888, 'longitude': 127.0274563},
      {'name': '', 'latitude': 37.6248281, 'longitude': 127.0279642},
      {'name': '', 'latitude': 37.624845, 'longitude': 127.0278281},
      {'name': '', 'latitude': 37.6248494, 'longitude': 127.0272729},
      {'name': '', 'latitude': 37.6251728, 'longitude': 127.0271554},
      {'name': '', 'latitude': 37.6251111, 'longitude': 127.0273148},
      {'name': '', 'latitude': 37.6250202, 'longitude': 127.0272141},
      {'name': '', 'latitude': 37.6249378, 'longitude': 127.0281554},
      {'name': '', 'latitude': 37.6249378, 'longitude': 127.0281554},
      {'name': '', 'latitude': 37.6251356, 'longitude': 127.0281075},
      {'name': '', 'latitude': 37.6249458, 'longitude': 127.0280307},
      {'name': '', 'latitude': 37.6249269, 'longitude': 127.027929},
      {'name': '', 'latitude': 37.6248076, 'longitude': 127.0276586},
      {'name': '', 'latitude': 37.6269397, 'longitude': 127.0305424},
      {'name': '', 'latitude': 37.6326376, 'longitude': 127.0265711},
      {'name': '', 'latitude': 37.6326376, 'longitude': 127.0265711},
      {'name': '', 'latitude': 37.633201, 'longitude': 127.0271416},
      {'name': '', 'latitude': 37.6338108, 'longitude': 127.0267937},
      {'name': '', 'latitude': 37.6344338, 'longitude': 127.0269442},
      {'name': '', 'latitude': 37.6346947, 'longitude': 127.0268955},
      {'name': '', 'latitude': 37.6345667, 'longitude': 127.0266706},
      {'name': '', 'latitude': 37.6346956, 'longitude': 127.0270088},
      {'name': '', 'latitude': 37.6343612, 'longitude': 127.0268885},
      {'name': '', 'latitude': 37.6341799, 'longitude': 127.0267549},
      {'name': '', 'latitude': 37.6341254, 'longitude': 127.026699},
      {'name': '', 'latitude': 37.6344861, 'longitude': 127.0267396},
      {'name': '', 'latitude': 37.6343955, 'longitude': 127.0266728},
      {'name': '', 'latitude': 37.6339148, 'longitude': 127.0262939},
      {'name': '', 'latitude': 37.6337079, 'longitude': 127.0263305},
      {'name': '', 'latitude': 37.6333991, 'longitude': 127.02604},
      {'name': '', 'latitude': 37.6336943, 'longitude': 127.0257756},
      {'name': '', 'latitude': 37.6341228, 'longitude': 127.0263818},
      {'name': '', 'latitude': 37.6342758, 'longitude': 127.0263685},
      {'name': '', 'latitude': 37.6344587, 'longitude': 127.0255956},
      {'name': '', 'latitude': 37.6346165, 'longitude': 127.0261601},
      {'name': '', 'latitude': 37.6333155, 'longitude': 127.0257352},
      {'name': '', 'latitude': 37.6333713, 'longitude': 127.0259384},
      {'name': '', 'latitude': 37.6333532, 'longitude': 127.0259386},
      {'name': '', 'latitude': 37.6333532, 'longitude': 127.0259386},
      {'name': '', 'latitude': 37.6342077, 'longitude': 127.0257575},
      {'name': '', 'latitude': 37.6342283, 'longitude': 127.0260632},
      {'name': '', 'latitude': 37.633854, 'longitude': 127.0254789},
      {'name': '', 'latitude': 37.6346861, 'longitude': 127.0258533},
      {'name': '', 'latitude': 37.6340648, 'longitude': 127.0259067},
      {'name': '', 'latitude': 37.6338847, 'longitude': 127.0259204},
      {'name': '', 'latitude': 37.6345735, 'longitude': 127.0242232},
      {'name': '', 'latitude': 37.6341851, 'longitude': 127.0252027},
      {'name': '', 'latitude': 37.6345095, 'longitude': 127.0251984},
      {'name': '', 'latitude': 37.6344905, 'longitude': 127.0250854},
      {'name': '', 'latitude': 37.6340568, 'longitude': 127.0249438},
      {'name': '', 'latitude': 37.6340568, 'longitude': 127.0249438},
      {'name': '', 'latitude': 37.6341466, 'longitude': 127.0248973},
      {'name': '', 'latitude': 37.6341466, 'longitude': 127.0248973},
      {'name': '', 'latitude': 37.6341448, 'longitude': 127.024682},
      {'name': '', 'latitude': 37.6337938, 'longitude': 127.0247319},
      {'name': '', 'latitude': 37.6337748, 'longitude': 127.0246075},
      {'name': '', 'latitude': 37.6340795, 'longitude': 127.024411},
      {'name': '', 'latitude': 37.6340795, 'longitude': 127.024411},
      {'name': '', 'latitude': 37.6341051, 'longitude': 127.0242407},
      {'name': '', 'latitude': 37.6344597, 'longitude': 127.0246213},
      {'name': '', 'latitude': 37.6344218, 'longitude': 127.0244065},
      {'name': '', 'latitude': 37.6339306, 'longitude': 127.0249341},
      {'name': '', 'latitude': 37.6338131, 'longitude': 127.0248903},
      {'name': '', 'latitude': 37.6338231, 'longitude': 127.0250035},
      {'name': '', 'latitude': 37.6333292, 'longitude': 127.0241148},
      {'name': '', 'latitude': 37.6330763, 'longitude': 127.0240388},
      {'name': '', 'latitude': 37.6330763, 'longitude': 127.0240388},
      {'name': '', 'latitude': 37.6338784, 'longitude': 127.0240624},
      {'name': '', 'latitude': 37.6337786, 'longitude': 127.0239843},
      {'name': '', 'latitude': 37.6339389, 'longitude': 127.0237557},
      {'name': '', 'latitude': 37.6338481, 'longitude': 127.0236662},
      {'name': '', 'latitude': 37.6335548, 'longitude': 127.0252449},
      {'name': '', 'latitude': 37.6335548, 'longitude': 127.0252449},
      {'name': '', 'latitude': 37.6336112, 'longitude': 127.0244397},
      {'name': '', 'latitude': 37.6334665, 'longitude': 127.0243736},
      {'name': '', 'latitude': 37.6333947, 'longitude': 127.0244086},
      {'name': '', 'latitude': 37.6332392, 'longitude': 127.0252263},
      {'name': '', 'latitude': 37.6331381, 'longitude': 127.0249784},
      {'name': '', 'latitude': 37.6331381, 'longitude': 127.0249784},
      {'name': '', 'latitude': 37.6335173, 'longitude': 127.0250754},
      {'name': '', 'latitude': 37.6330635, 'longitude': 127.0246735},
      {'name': '', 'latitude': 37.6332523, 'longitude': 127.0246257},
      {'name': '', 'latitude': 37.6331116, 'longitude': 127.0261344},
      {'name': '', 'latitude': 37.6331662, 'longitude': 127.0262016},
      {'name': '', 'latitude': 37.6322504, 'longitude': 127.0265988},
      {'name': '', 'latitude': 37.6322504, 'longitude': 127.0265988},
      {'name': '', 'latitude': 37.6330218, 'longitude': 127.0261695},
      {'name': '', 'latitude': 37.6314635, 'longitude': 127.0262352},
      {'name': '', 'latitude': 37.6314635, 'longitude': 127.0262352},
      {'name': '', 'latitude': 37.6324163, 'longitude': 127.0259508},
      {'name': '', 'latitude': 37.6320492, 'longitude': 127.0262389},
      {'name': '', 'latitude': 37.6317799, 'longitude': 127.0263557},
      {'name': '', 'latitude': 37.6315374, 'longitude': 127.0264608},
      {'name': '', 'latitude': 37.6315831, 'longitude': 127.0265395},
      {'name': '', 'latitude': 37.6317718, 'longitude': 127.0264691},
      {'name': '', 'latitude': 37.6329474, 'longitude': 127.0258986},
      {'name': '', 'latitude': 37.6331271, 'longitude': 127.0258283},
      {'name': '', 'latitude': 37.6322111, 'longitude': 127.0262028},
      {'name': '', 'latitude': 37.6322111, 'longitude': 127.0262028},
      {'name': '', 'latitude': 37.6326774, 'longitude': 127.0259361},
      {'name': '', 'latitude': 37.6326642, 'longitude': 127.0254264},
      {'name': '', 'latitude': 37.632799, 'longitude': 127.0253794},
      {'name': '', 'latitude': 37.6329952, 'longitude': 127.0251389},
      {'name': '', 'latitude': 37.6325999, 'longitude': 127.02528},
      {'name': '', 'latitude': 37.6321329, 'longitude': 127.025456},
      {'name': '', 'latitude': 37.6321329, 'longitude': 127.025456},
      {'name': '', 'latitude': 37.6324553, 'longitude': 127.0252252},
      {'name': '', 'latitude': 37.6328595, 'longitude': 127.0250727},
      {'name': '', 'latitude': 37.631875, 'longitude': 127.0258673},
      {'name': '', 'latitude': 37.6317132, 'longitude': 127.025926},
      {'name': '', 'latitude': 37.6317286, 'longitude': 127.0255973},
      {'name': '', 'latitude': 37.631648, 'longitude': 127.0256663},
      {'name': '', 'latitude': 37.6316649, 'longitude': 127.0255301},
      {'name': '', 'latitude': 37.6318178, 'longitude': 127.0254941},
      {'name': '', 'latitude': 37.6318178, 'longitude': 127.0254941},
      {'name': '', 'latitude': 37.6324048, 'longitude': 127.0256564},
      {'name': '', 'latitude': 37.6323051, 'longitude': 127.0255784},
      {'name': '', 'latitude': 37.6323485, 'longitude': 127.0253852},
      {'name': '', 'latitude': 37.6328359, 'longitude': 127.0254809},
      {'name': '', 'latitude': 37.631895, 'longitude': 127.0250173},
      {'name': '', 'latitude': 37.6325527, 'longitude': 127.0250087},
      {'name': '', 'latitude': 37.6322293, 'longitude': 127.0251262},
      {'name': '', 'latitude': 37.632273, 'longitude': 127.024967},
      {'name': '', 'latitude': 37.6324436, 'longitude': 127.0248968},
      {'name': '', 'latitude': 37.6327132, 'longitude': 127.024814},
      {'name': '', 'latitude': 37.6324954, 'longitude': 127.0246242},
      {'name': '', 'latitude': 37.6316528, 'longitude': 127.0251564},
      {'name': '', 'latitude': 37.6317679, 'longitude': 127.0249056},
      {'name': '', 'latitude': 37.6315254, 'longitude': 127.0249994},
      {'name': '', 'latitude': 37.6314266, 'longitude': 127.0250347},
      {'name': '', 'latitude': 37.6325417, 'longitude': 127.0247709},
      {'name': '', 'latitude': 37.6320026, 'longitude': 127.0249592},
      {'name': '', 'latitude': 37.6317098, 'longitude': 127.0244192},
      {'name': '', 'latitude': 37.6311098, 'longitude': 127.0248689},
      {'name': '', 'latitude': 37.6325912, 'longitude': 127.0242264},
      {'name': '', 'latitude': 37.63146, 'longitude': 127.0247171},
      {'name': '', 'latitude': 37.6309851, 'longitude': 127.0261281},
      {'name': '', 'latitude': 37.6310171, 'longitude': 127.0267395},
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
