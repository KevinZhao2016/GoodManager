//
//  NIMNetCallNetstat.h
//  NIMAVChat
//
//  Created by hzgaofeng on 2018/8/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

/**
 *  音视频网络状况
 */
#import <Foundation/Foundation.h>
#import "NIMAVChatDefs.h"

@interface NIMNetCallNetstat : NSObject

/**
 *  网络质量
 */
@property (nonatomic, assign) NIMNetCallNetStatus status;
/**
 *  rtt
 */
@property (nonatomic, assign) int rtt;
/**
 *  音频丢包率百分比（0~100）
 */
@property (nonatomic, assign) int audioLossrate;
/**
 *  视频丢包率百分比（0~100）
 */
@property (nonatomic, assign) int videoLossrate;


@end
