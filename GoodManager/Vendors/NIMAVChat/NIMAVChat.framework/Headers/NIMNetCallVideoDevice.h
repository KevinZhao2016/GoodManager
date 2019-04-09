//
//  NIMNetCallVideoDevice.h
//  NIMAVChat
//
//  Created by He on 2018/10/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  视频设备信息
 */
@interface NIMNetCallVideoDevice : NSObject

/**
 *  视频设备类
 */
@property(nonatomic, strong) AVCaptureDevice *device;

/**
 *  视频设备输入类
 */
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@end

NS_ASSUME_NONNULL_END
