//
//  ViewController.m
//  联动tableViewDemo
//
//  Created by xueer on 2018/7/25.
//  Copyright © 2018年 xueer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (assign, nonatomic) BOOL click;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _click = NO;
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) return 1;
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) return 6;
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    //设置cell被选中时背景颜色
    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
    backgroundViews.backgroundColor = [UIColor whiteColor];
    [cell setSelectedBackgroundView:backgroundViews];
    if (_leftTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        return cell;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行", indexPath.section, indexPath.row];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightTableView) return [NSString stringWithFormat:@"第 %ld 组", section];
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.leftTableView) return;
    
    //如果是点击左边tableView产生的滑动，不进行左边tableView的移动操作(不然在右边row不够铺满table的时候会出现左侧table移动位置不准确的问题)
    if(!_click) {
        // 取出显示在 视图 且最靠上 的 cell 的 indexPath
        NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
        [_leftTableView reloadData];
        // 左侧 talbelView 移动的 indexPath
        NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
        // 移动 左侧 tableView 到 指定 indexPath 居中显示
        [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.leftTableView) return;
    _click = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        _click = YES;
        // 将右侧 tableView 移动到指定位置
        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        // 取消选中效果
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
    }
}

@end
