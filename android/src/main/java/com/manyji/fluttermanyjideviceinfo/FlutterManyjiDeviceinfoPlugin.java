package com.manyji.fluttermanyjideviceinfo;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterDevicePlugin */
public class FlutterManyjiDeviceinfoPlugin implements MethodCallHandler,PluginRegistry.RequestPermissionsResultListener {
  Registrar registrar;

  FlutterManyjiDeviceinfoPlugin(Registrar registrar){
    this.registrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_manyji_deviceinfo");
    FlutterManyjiDeviceinfoPlugin instanace = new FlutterManyjiDeviceinfoPlugin(registrar);
    channel.setMethodCallHandler(instanace);
    registrar.addRequestPermissionsResultListener(instanace);
  }

  private static final String IMSI = "imsi",IMEI="imei",ANDROID_ID="android_id",MODEL="model",BRAND="brand",OS_VERSION="os_version",
          OS_CODE="os_code",APP_CODE="app_code",APP_VERSION="app_version",NET_TYPE="net_type",RESOLUTION="resolution",WIFI_MAC="mac",
          APP_NAME="app_name",PACKAGE="package";


  Result permissionResult;
  MethodCall permissionCall;
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (ContextCompat.checkSelfPermission(registrar.activity(), Manifest.permission.READ_PHONE_STATE)
            != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(registrar.activity(), Manifest.permission.ACCESS_NETWORK_STATE)
            != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(registrar.activity(), Manifest.permission.ACCESS_WIFI_STATE)
            != PackageManager.PERMISSION_GRANTED) {
      permissionResult = result;
      permissionCall = call;
      ActivityCompat.requestPermissions(
              registrar.activity(),
              new String[] {
                      Manifest.permission.READ_PHONE_STATE,
                      Manifest.permission.ACCESS_NETWORK_STATE,
                      Manifest.permission.ACCESS_WIFI_STATE,
              },
              REQUEST_COARSE_LOCATION_PERMISSIONS);
      return;
    }
    methodCall(call,result);
  }


  private void methodCall(MethodCall call, Result result){
    if (call.method.equals(IMSI)) {
      result.success(getImsi(registrar.context()));
    }else if(call.method.equals(IMEI)){
      result.success(getImei(registrar.context()));
    }else if(call.method.equals(ANDROID_ID)){
      result.success(getAndroidId(registrar.context()));
    }else if(call.method.equals(MODEL)){
      result.success(getModel());
    }else if(call.method.equals(BRAND)){
      result.success(getBrand());
    }else if(call.method.equals(OS_VERSION)){
      result.success("Android_" + getSystemVersion());
    }else if(call.method.equals(OS_CODE)){
      result.success(getSystemCode());
    }else if(call.method.equals(APP_VERSION)){
      result.success(getAppVersion(registrar.context()));
    }else if(call.method.equals(APP_CODE)){
      result.success(getAppCode(registrar.context()));
    }else if(call.method.equals(NET_TYPE)){
      result.success(getNetType(registrar.context()));
    }else if(call.method.equals(RESOLUTION)){
      result.success(getResolution(registrar.activity()));
    }else if(call.method.equals(WIFI_MAC)){
      result.success(getWifimac(registrar.context()));
    }else if(call.method.equals(APP_NAME)){
      result.success(getAppName(registrar.context()));
    }else if(call.method.equals(PACKAGE)){
      result.success(registrar.context().getPackageName());
    }
  }

  /**
   * 获得imsi
   */
  private static String getImsi(Context context) {
    try{
      TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
      String imsi = tm.getSubscriberId();
      return TextUtils.isEmpty(imsi) ? "" : imsi;
    }catch(Exception e){
      return "";
    }
  }

  /**
   * 获得imei
   */
  private static String getImei(Context context) {
    try{
      SharedPreferences sp = context.getSharedPreferences("szsh", 0);
      String imei = sp.getString("imei", "");
      if (!TextUtils.isEmpty(imei)) {
        return imei;
      }

      TelephonyManager tm = (TelephonyManager) context
              .getSystemService(Context.TELEPHONY_SERVICE);
      imei = tm.getDeviceId();

      if (TextUtils.isEmpty(imei)) {
        return "";
      } else {
        sp.edit().putString("imei", imei).commit();
        return imei;
      }
    }catch(Exception e){
      return "";
    }
  }

  /**
   * 获得androidId
   */
  private static String getAndroidId (Context context) {
    try {
      String ANDROID_ID = Settings.System.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
      return ANDROID_ID;
    }catch (Exception e){
      return "";
    }
  }

  /**
   * 获得手机型号
   */
  private static String getModel(){
    try {
      return Build.MODEL;
    }catch (Exception e){
      return "";
    }
  }

  /**
   * 获得手机品牌
   */
  private static String getBrand(){
    try {
      return Build.BRAND;
    }catch (Exception e){
      return "";
    }
  }


  /**
   * 获得系统版本
   */
  private static String getSystemVersion(){
    try {
      return Build.VERSION.RELEASE;
    }catch (Exception e){
      return "";
    }
  }

  /**
   * 获得系统版本号
   */
  private int getSystemCode() {
    try {
      return Build.VERSION.SDK_INT;
    }catch (Exception e){
      return 0;
    }
  }

  /**
   * 获取本地软件版本号
   */
  private static int getAppCode(Context ctx) {
    int localVersion = 0;
    try {
      PackageInfo packageInfo = ctx.getApplicationContext()
              .getPackageManager()
              .getPackageInfo(ctx.getPackageName(), 0);
      localVersion = packageInfo.versionCode;
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    return localVersion;
  }

  /**
   * 获取本地软件版本号名称
   */
  private static String getAppVersion(Context ctx) {
    String localVersion = "";
    try {
      PackageInfo packageInfo = ctx.getApplicationContext()
              .getPackageManager()
              .getPackageInfo(ctx.getPackageName(), 0);
      localVersion = packageInfo.versionName;
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    return localVersion;
  }


  /**
   * 获得mac
   */
  private static String getWifimac(Context context) {
    try {
      WifiManager wifiMgr = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
      WifiInfo info = (null == wifiMgr ? null : wifiMgr.getConnectionInfo());
      if (null != info) {
        String mac =  info.getMacAddress();
        if(mac == null){
          mac = "";
        }
        return mac;
      } else {
        return "";
      }
    } catch (Exception e) {
      return "";
    }
  }


  private static final String NETWORN_NONE = "NOONE";
  private static final String NETWORN_WIFI = "WIFI";
  private static final String NETWORN_UNKNOWN = "UNKNOWN";
  private static final String NETWORN_2G = "2G";
  private static final String NETWORN_3G = "3G";
  private static final String NETWORN_4G = "4G";

  private static String getNetType(Context context) {
    try {
      ConnectivityManager connManager = (ConnectivityManager) context
              .getSystemService(Context.CONNECTIVITY_SERVICE);
      if (null == connManager)
        return NETWORN_NONE;
      NetworkInfo activeNetInfo = connManager.getActiveNetworkInfo();
      if (activeNetInfo == null || !activeNetInfo.isAvailable()) {
        return NETWORN_NONE;
      }
      NetworkInfo wifiInfo = connManager
              .getNetworkInfo(ConnectivityManager.TYPE_WIFI);
      if (null != wifiInfo) {
        NetworkInfo.State state = wifiInfo.getState();
        if (null != state)
          if (state == NetworkInfo.State.CONNECTED
                  || state == NetworkInfo.State.CONNECTING) {
            return NETWORN_WIFI;
          }
      }
      NetworkInfo networkInfo = connManager
              .getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
      if (null != networkInfo) {
        NetworkInfo.State state = networkInfo.getState();
        String strSubTypeName = networkInfo.getSubtypeName();
        if (null != state)
          if (state == NetworkInfo.State.CONNECTED
                  || state == NetworkInfo.State.CONNECTING) {
            switch (activeNetInfo.getSubtype()) {
              case TelephonyManager.NETWORK_TYPE_GPRS:
              case TelephonyManager.NETWORK_TYPE_CDMA:
              case TelephonyManager.NETWORK_TYPE_EDGE:
              case TelephonyManager.NETWORK_TYPE_1xRTT:
              case TelephonyManager.NETWORK_TYPE_IDEN:
                return NETWORN_2G;
              case TelephonyManager.NETWORK_TYPE_EVDO_A:
              case TelephonyManager.NETWORK_TYPE_UMTS:
              case TelephonyManager.NETWORK_TYPE_EVDO_0:
              case TelephonyManager.NETWORK_TYPE_HSDPA:
              case TelephonyManager.NETWORK_TYPE_HSUPA:
              case TelephonyManager.NETWORK_TYPE_HSPA:
              case TelephonyManager.NETWORK_TYPE_EVDO_B:
              case TelephonyManager.NETWORK_TYPE_EHRPD:
              case TelephonyManager.NETWORK_TYPE_HSPAP:
                return NETWORN_3G;
              case TelephonyManager.NETWORK_TYPE_LTE:
                return NETWORN_4G;
              default:
                if (strSubTypeName.equalsIgnoreCase("TD-SCDMA")
                        || strSubTypeName.equalsIgnoreCase("WCDMA")
                        || strSubTypeName
                        .equalsIgnoreCase("CDMA2000")) {
                  return NETWORN_3G;
                } else {
                  return NETWORN_UNKNOWN;
                }
            }
          }
      }
    } catch (Exception e) {
    }
    return NETWORN_NONE;
  }

  /**
   * 获取应用程序名称
   */
  private static String getAppName(Context context) {
    try {
      PackageManager packageManager = context.getPackageManager();
      PackageInfo packageInfo = packageManager.getPackageInfo(
              context.getPackageName(), 0);
      int labelRes = packageInfo.applicationInfo.labelRes;
      return context.getResources().getString(labelRes);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "";
  }

  private String getResolution(Activity context){
    DisplayMetrics metrics = new DisplayMetrics();
    metrics = context.getApplicationContext().getResources().getDisplayMetrics();
    int width = metrics.widthPixels;int height = metrics.heightPixels;
    return width+"*"+height;
  }


  private static final int REQUEST_COARSE_LOCATION_PERMISSIONS = 1452;
  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    if (requestCode == REQUEST_COARSE_LOCATION_PERMISSIONS) {
      for (int i = 0; i < permissions.length; i++) {
        if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
          permissionResult.success(null);
        }
      }
      methodCall(permissionCall,permissionResult);
      return true;
    }
    return false;
  }
}
