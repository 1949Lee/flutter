import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blog App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  dynamic _identifierForVendor;
  String barcode = "";
  TextEditingController _controller1;
  TextEditingController _controller2;
  String loginUrl = "";
  String origin = "http://localhost:8080";
  final List<Map<String, String>> originItems = <Map<String, String>>[
    {
      "value": "http://localhost:8080",
      "text": "本地",
    },
    {
      "value": "https://www.jiaxuanlee.com",
      "text": "线上",
    },
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    IosDeviceInfo deviceData;

    try {
      if (Platform.isAndroid) {
//        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = await deviceInfoPlugin.iosInfo;
      }
    } on PlatformException {}

    if (!mounted) return;

    print(deviceData.identifierForVendor);
    setState(() {
      _identifierForVendor = deviceData.identifierForVendor;
    });
  }

  ///登录方法
  void _doLogin(String key) async {
    try {
      var passport = md5.convert(utf8.encode(key + _identifierForVendor));
      Map<String, dynamic> param = {"key": key, "passport": "$passport"};
//    http://192.168.0.100:1016/confirm-login
//    http://localhost:8080
      var response = await http.post(loginUrl.toString(),
          body: jsonEncode(param),
          headers: {"Origin": origin, "Content-Type": "application/json"});
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == 0) {
          print("确认登录成功，leeToken: ${body['data']['leeToken']}");
        } else {
          print("确认登录失败。$body");
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      Map<String, dynamic> content = json.decode(barcode);
      switch (content['action']) {
        case "login":
          if (content['key'] != null) {
            _doLogin(content['key']);
          }
          break;
        default:
          break;
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        用户拒绝授权
      } else {
//        未知错误
      }
    } on FormatException {
//      用户没有扫描，直接取消
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _setURL(String value) {
    setState(() {
      loginUrl = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.crop_free),
            onPressed: scan,
          )
        ],
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller1,
            onSubmitted: _setURL,
          ),
          DropdownButton<String>(
            value: origin,
            onChanged: (String string) => setState(() => origin = string),
//            selectedItemBuilder: (BuildContext context) {
//              return originItems.map<Widget>((Map<String, String> item) {
//                return Text(item["text"]);
//              }).toList();
//            },
            items: originItems.map((Map<String, String> item) {
              return DropdownMenuItem<String>(
                child: Text(item["text"]),
                value: item["value"],
              );
            }).toList(),
          ),
          Text(
            '按钮被点击了:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.display1,
          ),
          Text(barcode),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
