//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMSessionListViewController.h>
#import <NIMSessionViewController.h>
// IDCard识别
#import "IDAuthViewController.h"
#import "IDInfoViewController.h"
// BankCard识别
#import "BankAuthViewController.h"
// 多图片选择
//#import "RITLPhotos/RITLPhotos.h"
// 视频
//#import "DmcPickerViewController.h"
// 单选图片编辑
#import <jot/jot.h>
// 微信支付
#import <WXApi.h>
#import <WXApiObject.h>
// 支付宝支付
#import <AlipaySDK/AlipaySDK.h>
//#import "RSADataSigner.h"
