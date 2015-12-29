//
//  SetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "HttpClient.h"
#import "SetViewController.h"

#import "SetaddressViewController.h"
#import "UbRoleViewController.h"
#import "DescriptionViewController.h"
#import "ScaleViewController.h"
#import "PhotoViewController.h"

static NSString * CellIdentifier = @"CellIdentifier";


@interface SetViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,retain)UserModel * MyProfile;

@property (nonatomic,retain)UIButton * headBtn;

@property (nonatomic,copy) NSArray * UbRoleArray;


@end

@implementation SetViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
        
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.MyProfile = [responseDictionary objectForKey:@"model"];
            [self.tableView reloadData];
        }else {
            self.MyProfile = [[UserModel alloc]getMyProfile];
            double delayInSeconds = 3.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBtn.frame = CGRectMake(kScreenW-100, 5, 65, 65);
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 65.0f/2.0f;
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,self.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headBtn"]];
    [self.headBtn addTarget:self action:@selector(uploadHeadBtn) forControlEvents:UIControlEventTouchUpInside];
        
    switch (self.type) {
        case UserType_designer:{
            self.UbRoleArray = @[@"个人设计者",@"设计工作室"];
        
        }
            break;
            
        case UserType_processing:{
            self.UbRoleArray = @[@"加工厂",@"锁眼钉扣",@"代裁",@"后整包装",@"砂洗水洗",@"印花厂",@"印染厂",@"绣花厂",@"其他特种工艺"];

        }
            break;
            
        case UserType_supplier:{
            self.UbRoleArray = @[@"面料商",@"辅料商",@"机械设备商"];

        }
            break;
            
        default:
            self.UbRoleArray = @[@"该身份暂无二级身份"];
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadHeadBtn{
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,self.uid]];
    NSArray *photos = [[NSArray alloc]initWithObjects:photo, nil];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos;
    [browser show];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    else if (section == 1) {
        switch (self.type) {
            case UserType_clothing:
                //服装企业
                return 6;
                break;
                
            case UserType_processing:
                //加工配套
                return 6;
                break;
                
            default:
                return 5;
                break;
        }
    }
    else if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        
        cell.textLabel.font = kFont;
        cell.detailTextLabel.font = kFont;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.section) {
            case 0:{
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"头像";
                    [cell addSubview:self.headBtn];
                }
            }
                break;
                
            case 1:{
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"手机号";
                        cell.detailTextLabel.text = self.MyProfile.phone;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        break;
                    case 1:
                        cell.textLabel.text = @"名称";
                        cell.detailTextLabel.text = self.MyProfile.name;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        break;
                    case 2:
                        cell.textLabel.text = @"地址";
                        cell.detailTextLabel.text = self.MyProfile.address;
                        break;
                    case 3:
                        cell.textLabel.text = @"二级身份";
                        cell.detailTextLabel.text = self.MyProfile.subRole;
                        break;
                        
                    case 4:
                        cell.textLabel.text = @"备注";
                        cell.detailTextLabel.text = self.MyProfile.descriptionString;

                        break;
                        
                    case 5:
                        cell.textLabel.text = @"规模";
                        cell.detailTextLabel.text = self.MyProfile.scale;

                        break;
                        
                        
                    default:
                        break;
                }
            }
                break;
                
            case 2:{
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"相册";
                        if ([self.MyProfile.photoArray count] == 0) {
                            cell.detailTextLabel.text = @"暂无照片";
                        }else {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu张",(unsigned long)[self.MyProfile.photoArray count]];
                        }
                        break;
                    default:
                        break;
                }
                
            }
                break;
                
                
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            
        case 0:{
            if (indexPath.row == 0) {
                DLog(@"头像");
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
                [actionSheet showInView:self.view];
            }
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 2:{
                    DLog(@"地址");
                    SetaddressViewController * addressVC = [[SetaddressViewController alloc]init];
                    [self.navigationController pushViewController:addressVC animated:YES];
                }
                    break;
                case 3:{
                    DLog(@"二级身份");
                    UbRoleViewController * ubRoleVC = [[UbRoleViewController alloc]init];
                    ubRoleVC.placeholder = self.MyProfile.subRole;
                    ubRoleVC.cellPickList = [self.UbRoleArray copy];
                    [self.navigationController pushViewController:ubRoleVC animated:YES];
                }
                    break;
                case 4:{
                 DLog(@"备注");
                    DescriptionViewController * DescriptionVC =[[DescriptionViewController alloc]init];
                    DescriptionVC.placeholder = self.MyProfile.descriptionString;
                    [self.navigationController pushViewController:DescriptionVC animated:YES];
                }
                    break;
                case 5:{
                    DLog(@"规模");
                    ScaleViewController * scaleVC =[[ScaleViewController alloc]init];
                    scaleVC.placeholder = self.MyProfile.scale;
                    scaleVC.userType = self.MyProfile.UserType;
                    [self.navigationController pushViewController:scaleVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:{
                    DLog(@"相册");
                    PhotoViewController * photoVC = [[PhotoViewController alloc]init];
                    photoVC.title = @"我的相册";
                    photoVC.isMySelf = YES;
                    photoVC.photoArray = self.MyProfile.photoArray;
                    [self.navigationController pushViewController:photoVC animated:YES];
                
                }
                    break;
                default:
                    break;
            }
            break;
    
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            kTipAlert(@"设备没有相机!");
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        return;
    }
    if (buttonIndex == 1) {
        // 相册
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData*imageData = UIImageJPEGRepresentation(image, 0.2);
    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
    [picker dismissViewControllerAnimated:YES completion:^{
        [HttpClient uploadPhotoWithType:@"avatar" WithImage:newImage andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                kTipAlert(@"头像上传成功,但是头像显示会略有延迟。");
                [self.headBtn setBackgroundImage:newImage forState:UIControlStateNormal];
                double delayInSeconds = 45.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    [Tools removeAllCached];
                });

            }else {
                kTipAlert(@"头像上传失败,尝试再次上传！");
            }
        }];
    }];
}



@end
