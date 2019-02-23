import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_manyji_deviceinfo/flutter_manyji_deviceinfo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _imsi = 'Unknown';
  String _imei = 'Unknown';
  String _androidId = 'Unknown';
  String _model = 'Unknown';
  String _brand = 'Unknown';
  String _osVersion = 'Unknown';
  int _osCode = 0;
  String _appVersion = 'Unknown';
  int _appCode = 0;
  String _netType = 'Unknown';
  String _resolution = 'Unknown';
  String _mac = 'Unknown';
  String _appName = 'Unknown';
  String _package = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String imsi;
    String imei;
    String androidId;
    String model;
    String brand;
    String osVersion;
    int osCode;
    String appVersion;
    int appCode;
    String netType;
    String resolution;
    String mac;
    String appName;
    String package;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      imsi = await FlutterDevice.imsi;
      imei = await FlutterDevice.imei;
      androidId = await FlutterDevice.androidId;
      model = await FlutterDevice.model;
      brand = await FlutterDevice.brand;
      osVersion = await FlutterDevice.osVersion;
      osCode = await FlutterDevice.osCode;
      appVersion = await FlutterDevice.appVersion;
      appCode = await FlutterDevice.appCode;
      netType = await FlutterDevice.netType;
      resolution = await FlutterDevice.resolution;
      mac = await FlutterDevice.mac;
      appName = await FlutterDevice.appName;
      package = await FlutterDevice.package;
    } on PlatformException {
      imsi = 'Failed to get imsi version.';
      imei = 'Failed to get imei version.';
      androidId = 'Failed to get androidId version.';
      model = 'Failed to get model version.';
      brand = 'Failed to get brand version.';
      osVersion = 'Failed to get osVersion version.';
      osCode = 1;
      appVersion = 'Failed to get appVersion version.';
      appCode = 1;
      netType = 'Failed to get netType version.';
      resolution = 'Failed to get resolution version.';
      mac = 'Failed to get mac version.';
      appName = 'Failed to get appName version.';
      package = 'Failed to get package version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imsi = imsi;
      _imei = imei;
      _androidId = androidId;
      _model = model;
      _brand = brand;
      _osVersion = osVersion;
      _osCode = osCode;
      _appVersion = appVersion;
      _appCode = appCode;
      _netType = netType;
      _resolution = resolution;
      _mac = mac;
      _appName = appName;
      _package = package;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${_imsi}'),
              Container(height: 20,),
              Text('${_imei}'),
              Container(height: 20,),
              Text('${_androidId}'),
              Container(height: 20,),
              Text('${_model}'),
              Container(height: 20,),
              Text('${_brand}'),
              Container(height: 20,),
              Text('${_osVersion}'),
              Container(height: 20,),
              Text('${_osCode}'),
              Container(height: 20,),
              Text('${_appVersion}'),
              Container(height: 20,),
              Text('${_appCode}'),
              Container(height: 20,),
              Text('${_netType}'),
              Container(height: 20,),
              Text('${_resolution}'),
              Container(height: 20,),
              Text('${_mac}'),
              Container(height: 20,),
              Text('${_appName}'),
              Container(height: 20,),
              Text('${_package}'),
              Container(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
