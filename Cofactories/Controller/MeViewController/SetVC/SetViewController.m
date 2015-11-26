//
//  SetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HttpClient.h"
#import "SetViewController.h"

#import "SetaddressViewController.h"
#import "UbRoleViewController.h"
#import "DescriptionViewController.h"

@interface SetViewController ()

@property (nonatomic,retain)UserModel * MyProfile;

@end

@implementation SetViewController

-(void)viewDidAppear:(BOOL)animated
{
    DLog(@"2222");
    [super viewDidAppear:animated];
    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
        
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.MyProfile = [responseDictionary objectForKey:@"model"];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        switch (self.type) {
            case UserType_clothing:
                //服装企业
                return 6;
                break;
                
            case UserType_supplier:
                //加工配套
                return 6;
                break;
                
            default:
                return 5;
                break;
        }
    }
    else if (section == 1) {
        return 2;
    }
    else {
    
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
                
            case 1:{
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"邀请码";
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        break;
                    case 1:
                        cell.textLabel.text = @"相册";
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
        case 0:
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
                case 5:
                    DLog(@"规模");
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 1:
                    DLog(@"相册");
                    break;
                default:
                    break;
            }
            break;
    
        default:
            break;
    }
}


@end
