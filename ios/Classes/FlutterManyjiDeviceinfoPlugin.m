#import "FlutterManyjiDeviceinfoPlugin.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@implementation FlutterManyjiDeviceinfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_manyji_deviceinfo"
                                     binaryMessenger:[registrar messenger]];
    FlutterManyjiDeviceinfoPlugin* instance = [[FlutterManyjiDeviceinfoPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self deviceVersion];
    //手机imsi
    if ([@"imsi" isEqualToString:call.method]) {
        result([self getidentifierStr]);
    }
    //手机imei
    else if ([@"imei" isEqualToString:call.method]) {
        result([self getidentifierStr]);
    }
    //安卓id
    else if ([@"android_id" isEqualToString:call.method]) {
        result(NULL);
    }
    //手机型号
    else if ([@"model" isEqualToString:call.method]) {
        result([self getDeviceName]);
    }
    //手机品牌
    else if ([@"brand" isEqualToString:call.method]) {
        result([self getuserPhoneName]);
    }
    //系统版本号
    else if ([@"os_version" isEqualToString:call.method]) {
        result([self getsystemVersion]);
    }
    //系统版本Code
    else if ([@"os_code" isEqualToString:call.method]) {
        result(NULL);
    }
    //app版本号
    else if ([@"app_version" isEqualToString:call.method]) {
        result([self getapp_Version]);
    }
    //app版本Code
    else if ([@"app_code" isEqualToString:call.method]) {
        result([NSNumber numberWithInt:[[self getapp_build] intValue]]);
    }
    //网络状态
    else if ([@"net_Type" isEqualToString:call.method]) {
        result(NULL);
    }
    //手机分辨率
    else if ([@"resolution" isEqualToString:call.method]) {
        result([self getscale_screen]);
    }
    //WIFI_mac
    else if ([@"mac" isEqualToString:call.method]) {
        result([self wifiMac]);
    }
    //应用名字
    else if ([@"app_name" isEqualToString:call.method]) {
        result([self getapp_Name]);
    }
    //包名
    else if ([@"package" isEqualToString:call.method]) {
        result([self getapp_Identifier]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSString *)getidentifierStr {
    //设备唯一标识符
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return identifierStr;
}

- (NSString *)getapp_Name {
    // app名称
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    return app_Name;
}

- (NSString *)getapp_Version {
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

- (NSString *)getapp_build {
    // app build版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

- (NSString *)getapp_Identifier {
    // app 包名
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return app_build;
}

- (NSString *)getsystemVersion {
    // 系统版本号
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

- (NSString *)getuserPhoneName {
    NSString* userPhoneName = [[UIDevice currentDevice] systemName];
    return userPhoneName;
}

- (NSString *)getscale_screen {
    // 手机分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *ft = [NSString stringWithFormat:@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen];
    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    return ft;
}



- (NSString *)deviceVersion {
    //设备唯一标识符
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"设备唯一标识符:%@",identifierStr);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString * phoneModel =  [self getDeviceName];
    NSLog(@"手机型号:%@",phoneModel);
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"infoDictionary == %@",infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app_Name == %@",app_Name);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSLog(@"物理尺寸:%.0f × %.0f",width,height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"分辨率是:%.0f × %.0f",width*scale_screen ,height*scale_screen);
    NSLog(@"wifi名称:%@",[self wifiName]);
    NSLog(@"wifimac地址:%@",[self wifiMac]);
    //NSString *macstr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"imei=&imsi=&mac=",[self getMacStr],@"&vendor=",userPhoneName,@"&model=",phoneModel,@"&appVersionName=",appCurVersion,@"&versionCode=",appCurVersionNum,@"&appVersionCode=",appCurVersionNum,@"&opera=",phoneVersion,@"&channel=",@"ios-test"];
    return [self getMacStr];
}

- (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    //    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    //    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    //    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    //    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    //    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    //    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    //    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    //    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    //    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    //    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    //    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    //    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    //    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    //    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    //    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    //    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    //    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    //    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    //    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    //    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    //    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    //    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    //    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    //    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    //    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    //    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    //    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    //    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    //    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    //    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    //    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    //    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    //    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    //    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    //    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    //
    //    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    //    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    //    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    //    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    //
    //    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    //    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
    
}

- (NSString *)dicToJson:(NSDictionary *)dic{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
    
    // 将json字符串转换成字典
    //    NSData * getJsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
}


- (NSString *)getParam {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    NSString *headerStr = @"imei=";
    NSString *footerStr = @"&imsi=&mac=&vendor=oppo&model=vivo&versionName=1.2.3&versionCode=11&appVersionCode=1&channel=testios1";
    NSString *res = [NSString stringWithFormat:@"%@%@%@",headerStr,result,footerStr];
    return res;
}

- (NSString *)getMacStr {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macStr = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return macStr;
}
// 获取wifi名称
- (NSString *)wifiName
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *ssid = [[dic objectForKey:@"SSID"] lowercaseString];
    
    return ssid;
}
//获取BSSID即mac地址。
- (NSString *)wifiMac
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *bssid = [dic objectForKey:@"BSSID"];
    
    return bssid;
}



@end
