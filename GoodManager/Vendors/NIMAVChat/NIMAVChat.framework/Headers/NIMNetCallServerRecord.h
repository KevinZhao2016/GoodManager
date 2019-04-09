//
//  NIMNetCallServerRecord.h
//  NIMAVChat
//
//  Created by fanghe's mac on 2018/8/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMAVChatDefs.h"

/**
 * 音视频服务端录制设置参数
 */
@interface NIMNetCallServerRecord : NSObject <NSCopying>

/**
 *  启用服务器录制音频, 默认 NO
 *  @discussion 该开关仅在服务器开启录制功能时才有效，代表是否会有音频文件AAC生成
 */
@property (nonatomic, assign) BOOL enableServerAudioRecording;

/**
 *  启用服务器录制视频, 默认 NO
 *  @discussion 该开关仅在服务器开启录制功能时才有效，代表是否会有视频文件MP4生成
 */
@property (nonatomic, assign) BOOL enableServerVideoRecording;

/**
 *  录制模式, 默认为 NIMNetCallServerRecordModeDefault
 */
@property (nonatomic, assign) NIMNetCallServerRecordMode  serverRecordingMode;

/**
 *  是否为录制主讲人, 默认 NO
 *  @discussion 视频画面作为主画面的那个人称为录制主讲人
 */
@property (nonatomic, assign) BOOL enableServerHostRecording;

@end
