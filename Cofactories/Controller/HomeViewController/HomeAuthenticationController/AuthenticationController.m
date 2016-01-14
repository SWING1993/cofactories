//
//  AuthenticationController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AuthenticationController.h"
#import "AuthenticationCell.h"
#import "HttpClient.h"
#import "AuthenticationPhotoController.h"
static NSString *renZhengCellIdentifier = @"renZhengCell";
@interface AuthenticationController () {
    NSArray *titleArray, *placeHolderArray;
    UITextField *priseNameTextField, *priseAddressTextField, *personNameTextField, *idCardTextField;
    UIButton *lastButton;
}

@end

@implementation AuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"认证信息";
    
    [self creatHeaderview];
    [self creatFooterView];
    
    [self.tableView registerClass:[AuthenticationCell class] forCellReuseIdentifier:renZhengCellIdentifier];
    titleArray = @[@"企业名称", @"企业地址", @"个人姓名", @"身份证号"];
    placeHolderArray = @[@"企业姓名/个人姓名", @"省、市、区街道地址", @"个人姓名", @"身份证号"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];

}


- (void)creatHeaderview {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:242.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW - 30, 50)];
    myLabel.numberOfLines = 2;
    myLabel.font = [UIFont systemFontOfSize:13];
    myLabel.text = @"赶快提交资料，成为认证用户吧！让你享受更极致的体验，更贴心的服务。";
    myLabel.textColor = [UIColor colorWithRed:229.0f/255.0f green:83.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
    [headerView addSubview:myLabel];
    self.tableView.tableHeaderView = headerView;
}

- (void)creatFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(20, 10, kScreenW - 40, 38);
    [lastButton setTitle:@"下一步" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    lastButton.layer.cornerRadius = 4;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    lastButton.userInteractionEnabled = NO;
    [lastButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lastButton];
    self.tableView.tableFooterView = footerView;

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthenticationCell *cell = [tableView dequeueReusableCellWithIdentifier:renZhengCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myLabel.text = titleArray[indexPath.row];
    cell.myTextField.placeholder = placeHolderArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            priseNameTextField = cell.myTextField;
        }
            break;
        case 1:
        {
            priseAddressTextField = cell.myTextField;
        }
            break;
        case 2:
        {
            personNameTextField = cell.myTextField;
        }
            break;
        case 3:
        {
            idCardTextField = cell.myTextField;
            //身份证号可能带x，所以弹出默认键盘
//            cell.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - 下一步
- (void)nextStepAction:(UIButton *)button {
    
    
    AuthenticationPhotoController *photoVC = [[AuthenticationPhotoController alloc] initWithStyle:UITableViewStyleGrouped];
    photoVC.hidesBottomBarWhenPushed = YES;
    photoVC.priseName = priseNameTextField.text;
    photoVC.priseAddress = priseAddressTextField.text;
    photoVC.personName = personNameTextField.text;
    photoVC.idCard = idCardTextField.text;
    photoVC.homeEnter = self.homeEnter;
    [self.navigationController pushViewController:photoVC animated:YES];
    NSLog(@"%@， %@， %@， %@", priseNameTextField.text, priseAddressTextField.text, personNameTextField.text, idCardTextField.text);
    
}


- (void)infoAction {
    if (priseNameTextField.text.length != 0 && priseAddressTextField.text.length != 0 && personNameTextField.text.length != 0 && (idCardTextField.text.length == 18 || idCardTextField.text.length == 19 || idCardTextField.text.length == 20) ) {
        DLog(@"去认证");
        lastButton.backgroundColor = kLightBlue;
        [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = YES;

    } else {
        DLog(@"信息不完善");
        lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
