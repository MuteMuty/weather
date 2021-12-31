import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _lokacija = 'Ljubljana';
  var _cast1h = [];
  var _cast6h = [];
  var _castToday = {
    'icon': 'partCloudy_night',
    'temperature': '3',
    'date': '2021-12-29T16:00:00+00:00',
    'humidity': '97',
    'pressure': '1013',
    'weather': 'delno oblačno',
    'wind': 'šibek S',
    'sunrise': '07:44',
    'sunset': '16:24'
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: const Icon(Icons.settings))
        ],
      ),*/
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () {
          return _fetchData();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade900,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _cloudIcon(),
                _temperature(),
                _location(),
                _sun(),
                _hourlyPrediction(),
                _dailyPredictions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final mesta = {
    'Babno Polje',
    'Bilje pri Novi Gorici',
    'Blegoš',
    'Boršt Gorenja vas',
    'Breginj',
    'Bukovski vrh',
    'Celje',
    'Cerkniško jezero',
    'Davča',
    'Gačnik',
    'Godnje',
    'Gornji Grad',
    'Hočko Pohorje',
    'Hrastnik',
    'Idrija',
    'Iskrba',
    'Jeronim',
    'Jeruzalem',
    'Jezersko',
    'Kamniška Bistrica',
    'Kanin',
    'Kočevje',
    'Korensko sedlo',
    'Kranj',
    'Kredarica',
    'Krn',
    'Krvavec',
    'Kubed',
    'Kum',
    'Letališče Cerklje ob Krki',
    'Letališče Jožeta Pučnika Ljubljana',
    'Letališče Portorož',
    'Lisca',
    'Litija',
    'Ljubljana',
    'Logarska dolina',
    'Logatec',
    'Maribor',
    'Marinča vas',
    'Metlika',
    'Mežica',
    'Miklavž na Gorjancih',
    'Murska Sobota',
    'Nanos',
    'Nova Gorica',
    'Nova vas - Bloke',
    'Novo mesto',
    'Osilnica',
    'Otlica',
    'Park Škocjanske jame',
    'Pasja ravan',
    'Pavličevo sedlo',
    'Planina pod Golico',
    'Podnanos',
    'Postojna',
    'Predel',
    'Ptuj',
    'Radegunda',
    'Rogaška Slatina',
    'Rogla',
    'Rudno polje',
    'Sevno',
    'Slavnik',
    'Slovenske Konjice',
    'Sviščaki',
    'Šebreljski vrh',
    'Šmartno pri Slovenj Gradcu',
    'Tatre',
    'Tolmin - Volče',
    'Topol',
    'Trbovlje',
    'Trebnje',
    'Trije Kralji na Pohorju',
    'Trojane - Limovce',
    'Uršlja gora',
    'Vedrijan',
    'Velenje',
    'Velike Lašče',
    'Vogel',
    'Vrhnika',
    'Vršič',
    'Zadlog',
    'Zelenica',
    'Zgornja Kapla',
    'Zgornja Radovna',
    'Zgornja Sorica'
  };
  _fetchData([kraj]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lokacija = prefs.getString('_lokacija') ?? 'Ljubljana';

    var ur = Uri.https('vreme.arso.gov.si', '/api/1.0/location/',
        {"location": kraj ?? _lokacija});
    var data = await http.get(ur);

    if (data.statusCode == 200) {
      //var jsonResponse = convert.jsonDecode(data.body) as Map<String, dynamic>;
      var jsonResponse =
          convert.jsonDecode(convert.utf8.decode(data.bodyBytes));
      var f1h = jsonResponse['forecast1h']['features'][0]['properties']['days'];
      var forecast1h = [];
      for (var item in f1h) {
        for (var tmp in item['timeline']) {
          forecast1h.add({
            'hour': tmp['valid'] ?? '',
            'icon': tmp['clouds_icon_wwsyn_icon'] ?? '',
            'temperature': tmp['t'] ?? ''
          });
        }
      }

      var f3h = jsonResponse['forecast3h']['features'][0]['properties']['days'];
      for (var item in f3h) {
        for (var tmp in item['timeline']) {
          forecast1h.add({
            'hour': tmp['valid'] ?? '',
            'icon': tmp['clouds_icon_wwsyn_icon'] ?? '',
            'temperature': tmp['t'] ?? ''
          });
        }
      }

      var f6h = jsonResponse['forecast6h']['features'][0]['properties']['days'];
      var forecast6h = [];
      for (var item in f6h) {
        for (var tmp in item['timeline']) {
          forecast6h.add({
            'hour': tmp['valid'] ?? '',
            'icon': tmp['clouds_icon_wwsyn_icon'] ?? '',
            'temperature': tmp['t'] ?? ''
          });
        }
      }

      var rise = jsonResponse['forecast1h']['features'][0]['properties']['days']
              [0]['sunrise']
          .substring(11, 16);
      var sett = jsonResponse['forecast1h']['features'][0]['properties']['days']
              [0]['sunset']
          .substring(11, 16);
      var fToday = jsonResponse['forecast1h']['features'][0]['properties']
          ['days'][0]['timeline'][0];
      var forecastToday = {
        'icon': fToday['clouds_icon_wwsyn_icon'],
        'temperature': fToday['t'] ?? '',
        'date': fToday['valid'] ?? '',
        'humidity': fToday['rh'] ?? '',
        'pressure': fToday['msl'] ?? '',
        'weather': fToday['clouds_shortText'] ?? '',
        'wind': fToday['ff_shortText'] ?? '',
        'sunrise': rise ?? '',
        'sunset': sett ?? ''
      };

      setState(() {
        _cast1h = forecast1h;
        _cast6h = forecast6h;
        _castToday = forecastToday.cast();
        _lokacija = kraj ?? _lokacija;
      });

      await prefs.setString('_lokacija', kraj ?? _lokacija);
      print('Dela: $_castToday');
    } else {
      print('Napaka: ${data.statusCode}.');
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text('Izberi lokacijo'),
      children: <Widget>[
        for (var item in mesta)
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                _lokacija = item;
              });
              _fetchData(_lokacija);
              Navigator.pop(context);
            },
            child: Text(item),
          ),
      ],
    );
  }

  _dailyPredictions() {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _cast6h.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 50,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _cast6h[index]['hour'].split('T')[0].substring(8) +
                          '.' +
                          _cast6h[index]['hour'].split('T')[0].substring(5, 7) +
                          '.',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/${_cast6h[index]['icon']}.svg',
                    ),
                    Text(
                      '${_cast6h[index]['temperature']} °C',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _hourlyPrediction() {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white,
          ),
          bottom: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _cast1h.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 70,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _cast1h[index]['hour'].split('T')[1].substring(0, 2),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/${_cast1h[index]['icon']}.svg',
                  ),
                  Text(
                    '${_cast1h[index]['temperature']} °C',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _sun() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_upward),
              Icon(Icons.wb_twilight),
              Text(_castToday['sunrise'].toString())
            ],
          ),
          Row(
            children: [
              Icon(Icons.arrow_downward),
              Icon(Icons.wb_twilight),
              Text(_castToday['sunset'].toString())
            ],
          ),
        ],
      ),
    );
  }

  _location() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.place),
              const SizedBox(
                width: 10,
              ),
              Text(
                _lokacija,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              _fetchData(_lokacija);
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  _temperature() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text('Tlak'),
            Text(
              _castToday['pressure'].toString() + ' hPa',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
        Text(
          '${_castToday['temperature']}°C',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w100,
          ),
        ),
        Column(
          children: [
            Text('Vlažnost'),
            Text(
              _castToday['humidity'].toString() + ' %',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _cloudIcon() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
              ),
              SvgPicture.asset(
                'assets/images/${_castToday['icon']}.svg',
                width: 200,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
                    icon: Icon(Icons.settings)),
              ),
            ],
          ),
          Text(
            _castToday['weather'].toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
