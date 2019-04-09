//
//  NIMNetCallMP4RecordOption.h
//  NIMAVChat
//
//  Created by He on 2018/12/17.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMAVChatDefs.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  本地MP4录制设置可选参数
 */
@interface NIMNetCallMP4RecordOption : NSObject

/**
 *  录制的分辨率，默认为NIMNetCallVideoQualityDefault 480p, 可不设置
 */
@property(nonatomic, assign) NIMNetCallVideoQuality videoQuality;

/**
 *  录制的视频码率，可不设置
 */
@property(nonatomic, assign) NSUInteger videoBitrate;
@end

NS_ASSUME_NONNULL_END
