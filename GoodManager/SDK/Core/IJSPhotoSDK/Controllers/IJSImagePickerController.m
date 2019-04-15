//
//  IJSImagePickerController.m
//  JSPhotoSDK
//
//  Created by shan on 2017/5/28.
//  Copyright © 2017年 shan. All rights reserved.
//

#import "IJSImagePickerController.h"
#import <IJSFoundation/IJSFoundation.h>
#import "IJSExtension.h"

#import "IJSAlbumPickerController.h"
#import "IJSPhotoPickerController.h"
#import "IJSImageManager.h"
#import "IJSConst.h"
#import "IJSMapViewModel.h"
#import "GoodManager-Swift.h"


@interface IJSImagePickerController ()
{
    NSTimer *_timer;
    UILabel *_tipLabel;
    UIButton *_settingBtn;
    BOOL _pushPhotoPickerVc; // 是否直接跳转
    BOOL _didPushPhotoPickerVc;
}
/* 默认的列数 */
@property (nonatomic, assign) NSInteger columnNumber;
@property(nonatomic, weak) UIImagePickerController *picker;    //test for nothing
@property(nonatomic, weak) IJSAlbumPickerController *albumVc;  // 相册控制器
@property(nonatomic, weak) IJSPhotoPickerController *photoVc;  // 相册预览界面
@property(nonatomic, assign) int countoftime;


@property(nonatomic,copy) void(^selectedHandler)(NSArray<UIImage *> *photos, NSArray *avPlayers, NSArray *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType,NSError *error);  // 数据回调

@property(nonatomic,copy) void(^cancelHandler)(void);  // 取消选择的属性

@end

@implementation IJSImagePickerController


- (void)viewDidLoad
{
    
    self.countoftime = 0;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createrUI];    // 设置UI
    [self configNaviTitleAppearance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (self.dataSource == 1){
        if (_countoftime == 0){
            _countoftime += 1;
            [self camera];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)loadTheSelectedData:(void(^)(NSArray<UIImage *> *photos, NSArray<NSURL *> *avPlayers, NSArray<PHAsset *> *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType,NSError *error))selectedHandler
{
    self.albumVc.selectedHandler = selectedHandler;
    self.photoVc.selectedHandler = selectedHandler;
}

-(void)cancelSelectedData:(void(^)(void))cancelHandler
{
    self.albumVc.cancelHandler = cancelHandler;
    self.photoVc.cancelHandler = cancelHandler;
}

/*-----------------------------------初始化方法-------------------------------------------------------*/
#pragma mark 初始化方法
// 默认是4个返回值
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount
{
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 pushPhotoPickerVc:YES dataSource:0];
}
// 自定义
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber
{
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber  pushPhotoPickerVc:YES dataSource:0];
}
// 自定义
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber pushPhotoPickerVc:(BOOL)pushPhotoPickerVc
{
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber  pushPhotoPickerVc:pushPhotoPickerVc dataSource:0];
}

// 统一接口
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber pushPhotoPickerVc:(BOOL)pushPhotoPickerVc dataSource:(NSInteger)dataSource
{
    
    _pushPhotoPickerVc = pushPhotoPickerVc;
    IJSAlbumPickerController *albumPickerVc = [[IJSAlbumPickerController alloc] init];
    self.albumVc = albumPickerVc;
    self.dataSource = dataSource;
    albumPickerVc.columnNumber = columnNumber;
    self = [super initWithRootViewController:albumPickerVc]; // 设置返回的跟控制器
    if (self)
    {
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9; // Default is 9 / 默认最大可选9张图片
        self.selectedModels = [NSMutableArray array];
        self.columnNumber = columnNumber;

        [self setupDefaultData]; // 初始化信息

        if (![[IJSImageManager shareManager] authorizationStatusAuthorized]) // 没有授权,自定义的界面
        {
            _tipLabel = [[UILabel alloc] init];
            _tipLabel.backgroundColor = [UIColor redColor];
            _tipLabel.frame = CGRectMake(8, 200, self.view.js_width - 16, 60);
            _tipLabel.textAlignment = NSTextAlignmentCenter;
            _tipLabel.layer.cornerRadius = 5;
            _tipLabel.layer.masksToBounds =YES;
            _tipLabel.numberOfLines = 0;
            _tipLabel.font = [UIFont systemFontOfSize:16];
            _tipLabel.textColor = [UIColor blackColor];
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName)
                appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
            NSString *tipText;
            if ([NSBundle localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""] != nil)
            {
                tipText = [NSString stringWithFormat:[NSBundle localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""], appName];
            }
            _tipLabel.text = tipText;
            [self.view addSubview:_tipLabel];

            _settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [_settingBtn setTitle:[NSBundle localizedStringForKey:@"Setting"] forState:UIControlStateNormal];
            _settingBtn.frame = CGRectMake(JSScreenWidth / 2 - 50, 280, 100, 44);
            _settingBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _settingBtn.tintColor =[UIColor blueColor];
            _settingBtn.backgroundColor =[UIColor greenColor];
            _settingBtn.layer.borderWidth =1;
            _settingBtn.layer.cornerRadius = 5;
            _settingBtn.layer.masksToBounds = YES;
            [_settingBtn addTarget:self action:@selector(_settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_settingBtn];

            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(_observeAuthrizationStatusChange) userInfo:nil repeats:YES];
        }
        else // 已经授权
        {
            [self _pushPhotoPickerVc];
        }
    }
    return self;
}

/*-----------------------------------属性初始化-------------------------------------------------------*/
// 初始化时间排序的信息
- (void)setSortAscendingByModificationDate:(BOOL)sortAscendingByModificationDate
{
    _sortAscendingByModificationDate = sortAscendingByModificationDate;
    [IJSImageManager shareManager].sortAscendingByModificationDate = sortAscendingByModificationDate;
}

/*-----------------------------------私有方法-------------------------------------------------------*/
#pragma mark 私有方法
// 监听授权状态
- (void)_settingBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (void)_observeAuthrizationStatusChange
{
    if ([[IJSImageManager shareManager] authorizationStatusAuthorized])
    {
        [_tipLabel removeFromSuperview];
        [_settingBtn removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        [self _pushPhotoPickerVc];
    }
}

// 跳转界面
- (void)_pushPhotoPickerVc
{
    _didPushPhotoPickerVc = NO;
    if (!_didPushPhotoPickerVc && _pushPhotoPickerVc) // 直接push
    {
        IJSPhotoPickerController *vc = [[IJSPhotoPickerController alloc] init];
        self.photoVc = vc;
        vc.columnNumber = self.columnNumber; //列数
        __weak typeof(self) weakSelf = self;
        __weak typeof(vc) weakVc = vc;
        [[IJSImageManager shareManager] getCameraRollAlbumContentImage:_allowPickingImage contentVideo:_allowPickingVideo completion:^(IJSAlbumModel *model) {
            weakVc.albumModel = model;
            [weakSelf pushViewController:vc animated:YES];
            _didPushPhotoPickerVc = YES;
        }];
    }
}

//
- (void)_pushPhotoPickerVc_nojudge
{
    _didPushPhotoPickerVc = NO;
    
    IJSPhotoPickerController *vc = [[IJSPhotoPickerController alloc] init];
    self.photoVc = vc;
    vc.columnNumber = self.columnNumber; //列数
    __weak typeof(self) weakSelf = self;
    __weak typeof(vc) weakVc = vc;
    [[IJSImageManager shareManager] getCameraRollAlbumContentImage:_allowPickingImage contentVideo:_allowPickingVideo completion:^(IJSAlbumModel *model) {
        weakVc.albumModel = model;
        [weakSelf pushViewController:vc animated:YES];
        _didPushPhotoPickerVc = YES;
    }];
}

// 跳转到拍照页面
- (void)camera
{
    UIImagePickerController *_pickerView;
    if (_pickerView == nil) {
        _pickerView = [[UIImagePickerController alloc] init];
    }
    // 如果拍摄的摄像头可用
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
        _pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置拍摄照片
        _pickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        // 设置使用手机的后置摄像头（默认使用后置摄像头）
        _pickerView.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        // 设置使用手机的前置摄像头。
        //picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        // 设置拍摄的照片允许编辑
        _pickerView.allowsEditing = NO;
        _pickerView.delegate = self;
        
    }else{
        NSLog(@"模拟器无法打开摄像头");
    }
    [self presentViewController:_pickerView animated:YES completion:nil];
}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info--->成功：%@", info);
    UIImage *theImage =nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing])
    {
        // 获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else {
        // 获取原始的照片
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(theImage,self,@selector(image: didFinishSavingWithError: contextInfo:),nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"NSString * _Nonnull format, ...");
    //  定位1
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"保存图片失败";
    } else {
        msg = @"保存图片成功";
        [self dismissViewControllerAnimated:NO completion:^{
            IJSImagePickerController *ijsip = [[IJSImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 pushPhotoPickerVc:YES];
            ijsip.allowPickingVideo = NO;
            ijsip.isHiddenEdit = _isHiddenEdit;
            ijsip.hiddenOriginalButton = _hiddenOriginalButton;
            if (_hiddenOriginalButton==YES) {
                ijsip.allowPickingOriginalPhoto = NO;
            }else{
                ijsip.allowPickingOriginalPhoto = YES;
            }
            ijsip.dataSource = 0;
            [ijsip loadTheSelectedData:^(NSArray<UIImage *> *photos, NSArray<NSURL *> *avPlayers, NSArray<PHAsset *> *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType, NSError *error) {
                NSMutableArray *path = [[NSMutableArray alloc] init];

                [[PHImageManager defaultManager] requestImageForAsset:assets[0] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {

                    if (ijsip.allowPickingOriginalPhoto) {
                        NSURL *imageURL = info[@"PHImageFileURLKey"];
                        [path addObject:(imageURL.path)];
                    }else{
                        NSLog(@"ijsimagepickercontroller.m  image  301行");
                        NSFileManager *fileMG = [NSFileManager defaultManager];
                        NSString *rootPath = NSHomeDirectory();
                        rootPath = [NSString stringWithFormat:@"%@",rootPath];
                        int name = info[@"PHImageResultDeliveredImageFormatKey"];
                        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%d.jpg",rootPath,name];
                        NSData *imageData = UIImageJPEGRepresentation(image,1);
                        [fileMG createFileAtPath:filePath contents:imageData attributes:nil];
                        [path addObject:filePath];
                    }
                    NSString *result = @"";
                    if (![NSJSONSerialization isValidJSONObject:path]) {
                        NSLog(@"无法解析出JSONString");
                    }else{
                        NSData *a = [NSJSONSerialization dataWithJSONObject:path options:nil error:nil];
                        NSString *json = [[NSString alloc] initWithData:a encoding:NSUTF8StringEncoding];
                        result = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                        ocUseSwift *ous = [ocUseSwift alloc];
                        [ous ExecWinJSWithJSFun:[NSString stringWithFormat:@"appChooseSingleImageCallBack(\"%@\")",result]];
                    }
                }];
            }];
            getLMVC *ll = [getLMVC alloc];
            UIViewController *main = [ll getLastMainViewController];
            [main presentViewController:ijsip animated:YES completion:nil];
        }];
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片结果" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"用户取消的拍摄！");
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/// 跳转到相册列表页
- (void)goAlbumViewController
{
    IJSAlbumPickerController *vc = [[IJSAlbumPickerController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击方法
/*-----------------------------------get set 方法-------------------------------------------------------*/
#pragma mark set方法

- (void)setAllowPickingImage:(BOOL)allowPickingImage
{
    _allowPickingImage = allowPickingImage;
}
- (void)setAllowPickingVideo:(BOOL)allowPickingVideo
{
    _allowPickingVideo = allowPickingVideo;
}
-(void)setIsHiddenEdit:(BOOL)isHiddenEdit
{
    _isHiddenEdit = isHiddenEdit;
}
- (void)setMinPhotoWidthSelectable:(NSInteger)minPhotoWidthSelectable
{
    _minPhotoWidthSelectable = minPhotoWidthSelectable;
    [IJSImageManager shareManager].minPhotoWidthSelectable = minPhotoWidthSelectable;
}

- (void)setMinPhotoHeightSelectable:(NSInteger)minPhotoHeightSelectable
{
    _minPhotoHeightSelectable = minPhotoHeightSelectable;
    [IJSImageManager shareManager].minPhotoHeightSelectable = minPhotoHeightSelectable;
}
- (void)setNetworkAccessAllowed:(BOOL)networkAccessAllowed
{
    _networkAccessAllowed = networkAccessAllowed;
    [IJSImageManager shareManager].networkAccessAllowed = networkAccessAllowed;
}
- (void)setDataSource:(NSInteger)dataSource
{
    _dataSource = dataSource;
}

// 设置屏幕默认的宽度
- (void)setPhotoPreviewMaxWidth:(CGFloat)photoPreviewMaxWidth
{
    _photoPreviewMaxWidth = photoPreviewMaxWidth;
    if (photoPreviewMaxWidth > 800)
    {
        _photoPreviewMaxWidth = 800;
    }
    else if (photoPreviewMaxWidth < 500)
    {
        _photoPreviewMaxWidth = 500;
    }
    [IJSImageManager shareManager].photoPreviewMaxWidth = _photoPreviewMaxWidth;
}
// 设置最大的列数
- (void)setMaxImagesCount:(NSInteger)maxImagesCount
{
    _maxImagesCount = maxImagesCount;
    if (maxImagesCount > 1)
    {
    }
}
/// 是否选择原图
- (void)setAllowPickingOriginalPhoto:(BOOL)allowPickingOriginalPhoto
{
    _allowPickingOriginalPhoto = allowPickingOriginalPhoto;
    [IJSImageManager shareManager].allowPickingOriginalPhoto = allowPickingOriginalPhoto;
}
/// 是否隐藏原图按钮
-(void)setHiddenOriginalButton:(BOOL)hiddenOriginalButton
{
    _hiddenOriginalButton = hiddenOriginalButton;
}
/// 贴图数组
- (void)setMapImageArr:(NSMutableArray<IJSMapViewModel *> *)mapImageArr
{
    _mapImageArr = mapImageArr;
}

// 给相册控制和图片管理者设置列数计算图片高度
- (void)setColumnNumber:(NSInteger)columnNumber
{
    _columnNumber = columnNumber;
    if (columnNumber <= 2)
    {
        _columnNumber = 2;
    }
    else if (columnNumber >= 6)
    {
        _columnNumber = 6;
    }
    IJSAlbumPickerController *albumPickerVc = [self.childViewControllers firstObject];
    albumPickerVc.columnNumber = _columnNumber;
    [IJSImageManager shareManager].columnNumber = _columnNumber;
}

- (void)setMinVideoCut:(NSInteger)minVideoCut
{
    _minVideoCut = minVideoCut;
}
- (void)setMaxVideoCut:(NSInteger)maxVideoCut
{
    _maxVideoCut = maxVideoCut;
}
#pragma mark 初始化设置UI
/*-----------------------------------------------------初始化默认设置-------------------------------*/
/// 设置默认的数据
-(void)setupDefaultData
{
    self.photoWidth = 828.0;
    self.photoPreviewMaxWidth = 750; // 图片预览器默认的宽度
    // 默认准许用户选择原图和视频, 你也可以在这个方法后置为NO
    _allowPickingOriginalPhoto = NO;
    _allowPickingVideo = YES;
    _allowPickingImage = YES;
    _isHiddenEdit = NO;
    _sortAscendingByModificationDate = NO; //时间排序
    _networkAccessAllowed = NO;
    _hiddenOriginalButton = YES;
}
// 默认的外观，你可以在这个方法后重置
- (void)_createrUI
{
    self.navigationBar.barTintColor = [UIColor colorWithRed:(34 / 255.0) green:(34 / 255.0) blue:(34 / 255.0) alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configNaviTitleAppearance]; // 中间的文字
    [self configBarButtonItemAppearance];  //左右两边
}
// 导航条中间文字的颜色
- (void)configNaviTitleAppearance
{
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    self.navigationBar.titleTextAttributes = textAttrs;
}
 ///  设置导航条左右两边的按钮
- (void)configBarButtonItemAppearance
{
    UIBarButtonItem *barItem;
    if (iOS9Later)
    {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[IJSImagePickerController class]]];
    }
    else
    {
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[IJSImagePickerController class], nil];
    }
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] =[UIFont systemFontOfSize:17];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}
/// 警告
- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSBundle localizedStringForKey:@"OK"] style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
