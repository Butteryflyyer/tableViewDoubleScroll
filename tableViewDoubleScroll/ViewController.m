//
//  ViewController.m
//  tableViewDoubleScroll
//
//  Created by 信昊 on 2018/9/10.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "ViewController.h"
//竖屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//设备型号
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusScale ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//导航栏
#define StatusBarHeight (iPhoneX ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight (iPhoneX ? 88.f : 64.f)
#define TabbarHeight (iPhoneX ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight (iPhoneX ? (34.f) : (0.f))

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView * leftTableView;

@property (nonatomic, strong) UITableView * rightTableView;

/**
 滑到了第几组
 */
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

//用来处理leftTableView的cell的点击事件引起的rightTableView的滑动和用户拖拽rightTableView的事件冲突
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view  addSubview:self.leftTableView];
    [self.view  addSubview:self.rightTableView];
    
}

#pragma mark -- Getter

- (UITableView *)leftTableView{
    
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, SCREEN_WIDTH / 3.0, SCREEN_HEIGHT - StatusBarHeight) style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3.0, StatusBarHeight, SCREEN_WIDTH / 3.0 * 2, SCREEN_HEIGHT - StatusBarHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
    }
    return _rightTableView;
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        return 44;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 0.01;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return nil;
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor orangeColor];
    label.text = [NSString stringWithFormat:@"第%ld组",section];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    if (tableView == _leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组",indexPath.section];
        if (indexPath == _currentIndexPath) {
            cell.textLabel.textColor = [UIColor purpleColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组内的商品",(long)indexPath.section];
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == _leftTableView) {
        _currentIndexPath = indexPath;
        [tableView reloadData];
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        _isSelected = YES;
    }
    
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //方案一
//        if (scrollView == _rightTableView && _isSelected == NO) {
////    返回tableView可见的cell数组
//            NSArray * array = [_rightTableView visibleCells];
////    返回cell的IndexPath
//            NSIndexPath * indexPath = [_rightTableView indexPathForCell:array.firstObject];
//            NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
//            _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//            [_leftTableView reloadData];
//            [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//        }
    
    //方案二
    if (scrollView == _rightTableView && _isSelected == NO) {
        //系统方法返回处于tableView某坐标处的cell的indexPath
        NSIndexPath * indexPath = [_rightTableView indexPathForRowAtPoint:scrollView.contentOffset];
        NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [_leftTableView reloadData];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    //获取处于UITableView中心的cell
    //系统方法返回处于tableView某坐标处的cell的indexPath
    NSIndexPath * middleIndexPath = [_rightTableView  indexPathForRowAtPoint:CGPointMake(0, scrollView.contentOffset.y + _rightTableView.frame.size.height/2)];
    NSLog(@"中间的cell：第 %ld 组 %ld个",middleIndexPath.section, middleIndexPath.row);
    
    //获取某个cell在当前tableView上的坐标位置
    CGRect rectInTableView = [_rightTableView rectForRowAtIndexPath:middleIndexPath];
    //获取cell在当前屏幕的位置
    CGRect rectInSuperview = [_rightTableView convertRect:rectInTableView toView:[_rightTableView superview]];
    NSLog(@"中间的cell处于tableView上的位置: %@ /n 中间cell在当前屏幕的位置：%@", NSStringFromCGRect(rectInTableView), NSStringFromCGRect(rectInSuperview));
    
    /*UICollectionView同理也可实现
     NSIndexPath * indexPath = [collectionView  indexPathForItemAtPoint:scrollView.contentOffset];
     NSLog(@"滑到了第 %ld 组 %ld个",indexPath.section, indexPath.row);
     
     //获取cell在当前collection的位置
     CGRect cellInCollection = [_collectionView convertRect:item.frame toView:_collectionView];
     UICollectionViewCell * item = [_collectionView cellForItemAtIndexPath:indexPath]];
     //获取cell在当前屏幕的位置
     CGRect cellInSuperview = [_collectionView convertRect:item.frame toView:[_collectionView superview]];
     NSLog(@"获取cell在当前collection的位置: %@ /n 获取cell在当前屏幕的位置：%@", NSStringFromCGRect(cellInCollection), NSStringFromCGRect(cellInSuperview));
     */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isSelected = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
