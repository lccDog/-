//
//  ContentViewCell.m
//  首页布局
//
//  Created by TP on 2018/8/10.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "ContentViewCell.h"
#import "FootRefreshView.h"
@interface ContentViewCell()<UITableViewDataSource,UITableViewDelegate>
///tableView
@property (nonatomic,strong) UITableView *tableView;
///数据
@property (nonatomic,assign) NSInteger arrCount;
@end


@implementation ContentViewCell
static NSString *const contentCellId = @"contentCellId";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置UI界面
        [self YJSetupUI];
        _arrCount = 20;
    }
    return self;
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:contentCellId];
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - UI
- (void)YJSetupUI{
    [self addSubview:self.tableView];
    //刷新
    [self YJSetupRefresh];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
    cell.textLabel.text = [NSString stringWithFormat:@"------%ld--------",indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///scrollView.contentOffset.y = self.tableView.contentSize.height -self.tableView.bounds.size.height
    CGFloat offsetY = self.tableView.contentSize.height -self.tableView.bounds.size.height;
    if (scrollView.contentOffset.y >= offsetY) {
       
    }
}
#pragma mark - 刷新
- (void)YJSetupRefresh{
    FootRefreshView *footer = [[FootRefreshView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 35)];
    self.tableView.tableFooterView = footer;
    
}
@end
