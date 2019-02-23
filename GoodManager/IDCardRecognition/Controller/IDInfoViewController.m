//
//  IDInfoViewController.m
//  IDCardRecognition
//
//  Created by HanJunqiang on 2017/2/21.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "IDInfoViewController.h"
#import "IDInfo.h"
#import "AVCaptureViewController.h"
#import "IDAuthViewController.h"
#import "GoodManager-Swift.h"

@interface IDInfoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *IDImageView;
@property (strong, nonatomic) IBOutlet UILabel *IDNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *VisaAgencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *TermOfValidityLabel;

@end

@implementation IDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"身份证信息";
    
    self.IDImageView.layer.cornerRadius = 8;
    self.IDImageView.layer.masksToBounds = YES;
    
    
    self.IDImageView.image = _IDImage;
    if (_IDInfo.name) {
        self.IDNumLabel.text = _IDInfo.num;
        self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@",_IDInfo.name];
        self.sexLabel.text = [NSString stringWithFormat:@"性别: %@",_IDInfo.gender];
        self.nationLabel.text = [NSString stringWithFormat:@"民族: %@",_IDInfo.nation];
        self.adressLabel.text = [NSString stringWithFormat:@"地址: %@",_IDInfo.address];
    } else {
        self.VisaAgencyLabel.text = [NSString stringWithFormat:@"签发机关: %@",_IDInfo.issue];
        self.TermOfValidityLabel.text = [NSString stringWithFormat:@"有效期: %@",_IDInfo.valid];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 错误，重新拍摄
- (IBAction)shootAgain:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 正确，下一步
- (IBAction)nextStep:(UIButton *)sender {
    NSLog(@"经用户核对，身份证号码正确，那就进行下一步，比如身份证图像或号码经加密后，传递给后台");
    
    UIImageWriteToSavedPhotosAlbum(_IDImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //NSLog(@"path:%s",);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentDirectory = paths[0];
    NSString *IDNum = [_IDInfo.num stringByAppendingFormat:@".jpg"];
    NSString *fullPath = [doucumentDirectory stringByAppendingPathComponent:IDNum];
    [UIImageJPEGRepresentation(_IDImage, 0.5) writeToFile:fullPath atomically:YES];
    NSLog(@"上传图片路径=====%@",fullPath);
    
    UIViewController *present = self.presentingViewController;
    while (YES) {
        if (present.presentingViewController) {
            present = present.presentingViewController;
        }else{
            break;
        }
    }
    ocUseSwift *ous = [ocUseSwift alloc];
    //callbackfun+"(\"+...+"\")"
    NSString *str = [[[self.callbackfun stringByAppendingString:@"(\""] stringByAppendingString:fullPath] stringByAppendingString:@"\")"];
    NSLog(str);
    [ous ExecWinJSWithJSFun:str];
    [present dismissViewControllerAnimated:YES completion:nil];

//    //发送通知
//    //把要发送的信息放入字典中
//    NSDictionary *message = @{@"idCardFrontImage" : fullPath};
//    //创建通知对象
//    NSNotification * notification = [NSNotification notificationWithName:@"idCardFront" object:self userInfo:message];
//    //向通知中心发送消息（发布消息）
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    NSLog(@"发送消息！！！");
    
    
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];

    
    //[ous ExecWinJSWithJSFun:];
    
//    ous
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存图片成功");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationAVCaptureViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
