//
//  checkNet.m
//  GoodManager
//
//  Created by DJ on 2019/4/18.
//  Copyright © 2019 GoodManager. All rights reserved.
//

#import "checkNet.h"
#define kAppleUrlToCheckNetStatus @"http://captive.apple.com/"
#define kAppleUrlTocheckWifi @"http://captive.apple.com"


@implementation checkNet

- (BOOL)checkNetCanUse {
    
    __block BOOL canUse = NO;
    
    NSString *urlString = kAppleUrlToCheckNetStatus;
    
    // 使用信号量实现NSURLSession同步请求**
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //解析html页面
        NSString *htmlString = [self filterHTML:result];
        //除掉换行符
        NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if ([resultString isEqualToString:@"SuccessSuccess"]) {
            canUse = YES;
            NSLog(@"手机所连接的网络是可以访问互联网的: %d",canUse);
            
        }else {
            canUse = NO;
            NSLog(@"手机无法访问互联网: %d",canUse);
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return canUse;
}

//检测网络是否可以使用
- (BOOL)isReach{
    
    // 1.将网址初始化成一个OC字符串对象
    NSString *newUrlStr = kAppleUrlTocheckWifi;
    
    // 2.构建网络URL对象, NSURL
    NSURL *url = [NSURL URLWithString:newUrlStr];
    // 3.创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* result1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if ([result1 containsString:@"Success"])
    {
        NSLog(@"可以上网了");
        //   [PronetwayGeneralHandle shareHandle].NetworkCanUse = YES;
        return YES;
    }else {
        NSLog(@"未联网");
        //[self showNetworkStatus:@"未联网"];
        //   [PronetwayGeneralHandle shareHandle].NetworkCanUse = NO;
        return NO;
    }
}

- (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}
@end
