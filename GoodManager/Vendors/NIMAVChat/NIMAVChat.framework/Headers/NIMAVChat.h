//
//  NIMAVChat.h
//  NIMAVChat
//
//  Created by Netease
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIMAVChatDefs.h"

/**
 *  实时会话定义
 */
#import "NIMRTSManagerProtocol.h"
#import "NIMRTSOption.h"
#import "NIMRTSRecordingInfo.h"

/**
 *  多方实时会话定义
 */
#import "NIMRTSConferenceManagerProtocol.h"
#import "NIMRTSConference.h"
#import "NIMRTSConferenceData.h"
#import "NIMRTSSocksParam.h"



/**
 *  音视频网络通话定义
 */
#import "NIMNetCallManagerProtocol.h"
#import "NIMNetCallOption.h"
#import "NIMNetCallRecordingInfo.h"
#import "NIMNetCallMeeting.h"
#import "NIMNetCallUserInfo.h"
#import "NIMNetCallAudioFileMixTask.h"
#import "NIMNetCallVideoCaptureParam.h"
#import "NIMNetCallCustomVideoParam.h"
#import "NIMNetCallVideoProcessorParam.h"
#import "NIMNetCallServerRecord.h"
#import "NIMNetCallSocksParam.h"
#import "NIMNetCallAudioCustomInputTask.h"
#import "NIMNetCallNetstat.h"
#import "NIMNetCallMP4RecordOption.h"

#ifdef NIM_MAC
#import "NIMNetCallMacAudioDevice.h"
#endif

#import "NIMNetCallVideoDevice.h"

/**
 *  网络探测定义
 */
#import "NIMAVChatNetDetectManagerProtocol.h"
#import "NIMAVChatNetDetectResult.h"

/**
 *  音视频业务类
 */
#import "NIMAVChatServerSetting.h"
#import "NIMAVChatHeader.h"
