
import 'dart:async';
import 'package:flutter/services.dart';

class FlutterDevice {
  static const MethodChannel _channel =
      const MethodChannel('flutter_manyji_deviceinfo');

  ///手机imsi
  static Future<String> get imsi async => await _channel.invokeMethod('imsi');

  ///手机imei
  static Future<String> get imei async => await _channel.invokeMethod('imei');

  ///安卓id
  static Future<String> get androidId async => await _channel.invokeMethod('android_id');

  ///手机型号
  static Future<String> get model async => await _channel.invokeMethod('model');

  ///手机品牌
  static Future<String> get brand async => await _channel.invokeMethod('brand');

  ///系统版本号
  static Future<String> get osVersion async => await _channel.invokeMethod('os_version');

  ///系统版本Code
  static Future<int> get osCode async => await _channel.invokeMethod('os_code');

  ///app版本号
  static Future<String> get appVersion async => await _channel.invokeMethod('app_version');

  ///app版本Code
  static Future<int> get appCode async => await _channel.invokeMethod('app_code');

  ///网络状态
  static Future<String> get netType async => await _channel.invokeMethod('net_Type');

  ///手机分辨率
  static Future<String> get resolution async => await _channel.invokeMethod('resolution');

  ///WIFI_mac
  static Future<String> get mac async => await _channel.invokeMethod('mac');

  ///应用名字
  static Future<String> get appName async => await _channel.invokeMethod('app_name');

  ///包名
  static Future<String> get package async => await _channel.invokeMethod('package');
}
