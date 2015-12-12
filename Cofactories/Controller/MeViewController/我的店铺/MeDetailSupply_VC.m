//
//  MeDetailSupply_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeDetailSupply_VC.h"
#import "MaterialAbstractCell.h"
#import "MeTextLabelCell.h"
#import "FabricMarketModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MeGoodsCategoryCell.h"

static NSString *MeCatergoryCellIdentifier = @"MeCatergoryCell";

static NSString *abstractCellIdentifier = @"abstractCell";
static NSString *myTextCellIdentifier = @"myTextCell";
@interface MeDetailSupply_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *myTitleArray;
    FabricMarketModel *marketDetailModel;
    UIImageView *noPhotoView;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView1;
@end

@implementation MeDetailSupply_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"商品详情";
    myTitleArray = @[@"售价", @"市场标价", @"库存"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[MeTextLabelCell class] forCellReuseIdentifier:myTextCellIdentifier];
    [self.tableView registerClass:[MaterialAbstractCell class] forCellReuseIdentifier:abstractCellIdentifier];//商品简介

    
    noPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, kScreenW/3, kScreenW/3)];
    noPhotoView.image = [UIImage imageNamed:@"默认图片"];
    
    [self netWork];
}

- (void)netWork {
    [HttpClient getFabricDetailWithId:self.goodsID WithCompletionBlock:^(NSDictionary *dictionary) {
        int statusCode = [dictionary[@"statusCode"] intValue];
        if (statusCode == 200) {
            marketDetailModel = (FabricMarketModel *)dictionary[@"model"];
            DLog(@"%@", marketDetailModel);
            [self.collectionView reloadData];
            [self.collectionView1 reloadData];
            [self.tableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        MaterialAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:abstractCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.AbstractTitleLabel.text = @"商品简介：";

        CGSize size = [Tools getSize:marketDetailModel.descriptions andFontOfSize:13 andWidthMake:kScreenW - 60];
        cell.AbstractDetailLabel.frame = CGRectMake(30, 45, kScreenW - 60, size.height);
        cell.AbstractDetailLabel.text = marketDetailModel.descriptions;
        return cell;
    }else if (indexPath.section == 0 || indexPath.section == 2) {
        MeTextLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:myTextCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.shangPinTitle.text = @"商品名称";
            cell.shangPinDetail.text = marketDetailModel.name;
        } else if (indexPath.section == 2) {
            cell.shangPinTitle.text = myTitleArray[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.shangPinDetail.text = [NSString stringWithFormat:@"￥%@", marketDetailModel.price];
                    break;
                case 1:
                    cell.shangPinDetail.text = [NSString stringWithFormat:@"￥%@", marketDetailModel.marketPrice];
                    break;
                case 2:
                    cell.shangPinDetail.text = [NSString stringWithFormat:@"%@%@", marketDetailModel.amount, marketDetailModel.unit];//库存
                    break;
                default:
                    break;
            }
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            //图片
            if ([marketDetailModel.photoArray count]==0) {
                noPhotoView.hidden = NO;
                [cell addSubview:noPhotoView];
            }else {
                noPhotoView.hidden = YES;
                [cell addSubview:self.collectionView];
            }

        } else {
            //分类
            if ([marketDetailModel.catrgoryArray count]==0) {
                
            }else {
                [cell addSubview:self.collectionView1];
            }

            
        }
        
        return cell;
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"商品展示";
    } else if (section == 3) {
        return @"商品分类";
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([marketDetailModel.photoArray count]== 0) {
            return kScreenW/3+4;
        }
        if (0 < [marketDetailModel.photoArray count] && [marketDetailModel.photoArray count] < 4) {
            return kScreenW/3+4;
        }
        if (3 < [marketDetailModel.photoArray count] && [marketDetailModel.photoArray count] < 7) {
            return 2*kScreenW/3+4;
        }
        if (6 < [marketDetailModel.photoArray count] && [marketDetailModel.photoArray count] < 10) {
            return kScreenW+4;
        }

    } else if (indexPath.section == 3) {
        return 100;
    } else if (indexPath.section == 4) {
        CGSize size = [Tools getSize:marketDetailModel.descriptions andFontOfSize:13 andWidthMake:kScreenW - 60];
        return size.height + 50;
    }
        return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 3 ) {
        return 30;
    } else {
        return 0.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 4) {
        return 0.5;
    } else {
        return 10;
    }
}






- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 2, kScreenW, kScreenW) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tag = 222;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}
- (UICollectionView *)collectionView1{
    if (!_collectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 100) collectionViewLayout:layout];
        _collectionView1.backgroundColor = [UIColor clearColor];
        
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.tag = 223;
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.showsVerticalScrollIndicator = NO;
        [_collectionView1 registerClass:[MeGoodsCategoryCell class] forCellWithReuseIdentifier:MeCatergoryCellIdentifier];
    }
    return _collectionView1;
}



#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 222) {
        return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    } else {
        //计算宽度
        CGSize size = [Tools getSize:marketDetailModel.catrgoryArray[indexPath.row] andFontOfSize:14];
        return CGSizeMake(size.width + 20, 30);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 222) {
        return marketDetailModel.photoArray.count;
    } else {
        return marketDetailModel.catrgoryArray.count;
    }
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        UIImageView*imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,marketDetailModel.photoArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@""]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell addSubview:imageView];
        
        return cell;
    } else {
        MeGoodsCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeCatergoryCellIdentifier forIndexPath:indexPath];
        cell.goodsCategory.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        cell.goodsCategory.text = marketDetailModel.catrgoryArray[indexPath.row];
        
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[marketDetailModel.photoArray count]];
        [marketDetailModel.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,marketDetailModel.photoArray[idx]]]; // 图片
            [photos addObject:photo];
        }];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photos;
        [browser show];

    } else {
        
    }
    
    
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
