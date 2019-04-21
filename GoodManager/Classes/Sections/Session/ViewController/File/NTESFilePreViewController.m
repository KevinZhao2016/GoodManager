//
//  NTESFilePreViewController.m
//  NIM
//
//  Created by chris on 15/4/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESFilePreViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GoodManager-Swift.h"
@interface NTESFilePreViewController ()<NIMChatManagerDelegate>

@property(nonatomic,strong)NIMFileObject *fileObject;

@property(nonatomic,strong)UIDocumentInteractionController *interactionController;


@property(nonatomic,assign)BOOL isDownLoading;

@end

@implementation NTESFilePreViewController

- (instancetype)initWithFileObject:(NIMFileObject*)object{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _fileObject = object;
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatManager cancelFetchingMessageAttachment:_fileObject.message];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.fileObject.displayName;
   
    NSString *filePath = self.fileObject.path;
   
   
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      
       
        PreviewFileViewController *filevc = [[PreviewFileViewController alloc]init];
        [filevc setPathWithPath:self.fileObject.path];
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:filevc animated:NO];
        
        
    }else{
        [self downLoadFile];
    }
    
   
  
    
}

- (void)touchUpBtn{
    NSString *filePath = self.fileObject.path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
       
        PreviewFileViewController *filevc = [[PreviewFileViewController alloc]init];
        [filevc setPathWithPath:self.fileObject.path];
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:filevc animated:NO];
   
    }else{
        if (self.isDownLoading) {
            [[NIMSDK sharedSDK].chatManager cancelFetchingMessageAttachment:self.fileObject.message];
           [self downLoadFile];
        }else{
            [self downLoadFile];
        }
    }
}




#pragma mark - 文件下载

- (void)downLoadFile
{
    [[NIMSDK sharedSDK].chatManager fetchMessageAttachment:self.fileObject.message error:nil];
}

- (void)fetchMessageAttachment:(NIMMessage *)message
                      progress:(float)progress
{
    if ([message.messageId isEqualToString:self.fileObject.message.messageId])
    {
        self.isDownLoading = YES;
       
    }
}


- (void)fetchMessageAttachment:(NIMMessage *)message
          didCompleteWithError:(nullable NSError *)error
{
    if ([message.messageId isEqualToString:self.fileObject.message.messageId])
    {
        self.isDownLoading = NO;
       
        if (!error)
        {
            
            
            PreviewFileViewController *filevc = [[PreviewFileViewController alloc]init];
            [filevc setPathWithPath:self.fileObject.path];
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:filevc animated:NO];
            
            
         
        }
        else
        {
     
        }
    }
}



#pragma mark - 其他应用打开

- (void)openWithOtherApp{
    self.interactionController =
    [UIDocumentInteractionController
    interactionControllerWithURL:[NSURL fileURLWithPath:self.fileObject.path]];
    if (![self.interactionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未找到打开该应用的程序" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

@end
