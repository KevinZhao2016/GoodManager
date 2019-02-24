//
//  IDInfoViewController.m
//  IDCardRecognition
//
//  Created by tianxiuping on 2018/6/27.
//  Copyright © 2018年 XP. All rights reserved.
//

#import "BankInfoViewController.h"
#import "JYBDCardIDInfo.h"
#import "GoodManager-Swift.h"


@interface BankInfoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic)  NSMutableArray *dataArr;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UIButton *okButton;

@end

@implementation BankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.navigationItem.title = @"扫描信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height-200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.okButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-self.view.bounds.size.width*0.7)/2, self.view.bounds.size.height-70, self.view.bounds.size.width*0.7, 60)];
    self.okButton.backgroundColor = [UIColor orangeColor];
    NSString *title = @"确定使用照片！";
    [self.okButton setTitle: title forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:self.okButton];
    [self.okButton addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *hearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width-30, 200)];
    imageV.image = self.IDImage;
    [hearView addSubview:imageV];
    self.tableView.tableHeaderView = hearView;
    
    [self.dataArr addObject:[NSString stringWithFormat:@"银行卡号：%@",self.cardInfo.bankNumber]];
    [self.dataArr addObject:[NSString stringWithFormat:@"银行卡类型：%@",self.cardInfo.bankName]];
    
    [self.tableView reloadData];
}

-(void)okClick{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentDirectory = paths[0];
    
    NSString *imageName = [self.cardInfo.bankNumber stringByReplacingOccurrencesOfString:@" " withString:@""];// [urlString stringByReplacingOccurrencesOfString:@" " withString:@""]
    imageName = [imageName stringByAppendingFormat:@".jpg"];
    NSString *fullPath = @"";
    if (imageName != nil) {//BankCard正面 有银行卡号
        NSLog(imageName);
        fullPath = [doucumentDirectory stringByAppendingPathComponent:imageName];
    }else{//BankCard正面 无银行卡号
        NSLog(@"背面！");//有效期
    }
    [UIImageJPEGRepresentation(_IDImage, 0.5) writeToFile:fullPath atomically:YES];
    NSLog(@"上传图片路径=====%@",fullPath);
    
    
    NSLog(@"ok:  %s",fullPath);
    UIViewController *present = self.presentingViewController;
    while (YES) {
        if (present.presentingViewController) {
            present = present.presentingViewController;
        }else{
            break;
        }
    }
    ocUseSwift *ous = [ocUseSwift alloc];
    NSString *str = [[[self.callbackfun stringByAppendingString:@"(\""] stringByAppendingString:fullPath] stringByAppendingString:@"\")"];
    [ous ExecWinJSWithJSFun:str];
    [present dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
