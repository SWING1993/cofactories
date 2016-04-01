//
//  IMChatListViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/14.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatListViewController.h"
#import "IMChatViewController.h"
#import "IMSearchResult_VC.h"
#import "IMSearchResultModel.h"

@interface IMChatListViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating, IMSearchResult_VCDelegate> {
    UIView *bigView;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) IMSearchResult_VC *searchResult_VC;
@property (nonatomic, strong) NSMutableArray *searchResultArray;

@end

@implementation IMChatListViewController


//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    
    conversationVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    //self.emptyConversationView.userInteractionEnabled = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.conversationListTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    [self updateBadgeValueForTabBarItem];
}

/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    self.conversationListTableView.tableFooterView = [UIView new];
    
    _searchResult_VC = [[IMSearchResult_VC alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResult_VC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;//背景
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"搜索服装厂商家";
    self.conversationListTableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
    self.searchResult_VC.tableView.backgroundColor = [UIColor whiteColor];
    self.searchResult_VC.delegate = self;
    [self creatBackgroundView];
}

- (void)creatBackgroundView {
    bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.alpha = 0;
    [self.view addSubview:bigView];
}

- (void)updateBadgeValueForTabBarItem
{
    __weak IMChatListViewController *IMSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count>0) {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        } else {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    });
}

#pragma mark - UISearchControllerDelegate  (which you use ,which you choose!!)

- (void)willPresentSearchController:(UISearchController *)searchController{
    bigView.alpha = 1;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    bigView.alpha = 0;
    self.tabBarController.tabBar.hidden = NO;
}


- (void)presentSearchController:(UISearchController *)searchController{
    DLog(@"AAAAAÀAÁAAAA");
}
#pragma mark - UISearchResultsUpdating  (which you use ,which you choose!!)

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    DLog(@"searchText = %@", self.searchController.searchBar.text);
    [HttpClient searchBusinessWithRole:@"clothing" scale:nil province:nil city:nil subRole:nil keyWord:self.searchController.searchBar.text verified:nil page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        self.searchResultArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            IMSearchResultModel *model = [IMSearchResultModel getBusinessSupplierModelWithDictionary:myDic];
            model.searchString = self.searchController.searchBar.text;
            [self.searchResultArray addObject:model];
        }
        IMSearchResult_VC *tableController = (IMSearchResult_VC *)self.searchController.searchResultsController;
        tableController.searchResultArray = self.searchResultArray;
        [tableController.tableView reloadData];
    }];
}

- (void)IMSearchResult_VC:(IMSearchResult_VC *)searchResultVC myModel:(IMSearchResultModel *)myModel {
    
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = myModel.businessUid;
    conversationVC.title = myModel.businessName;
    conversationVC.hidesBottomBarWhenPushed=YES;
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

@end
