//
//  ViewController.m
//  首页布局
//
//  Created by TP on 2018/8/9.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "ViewController.h"
#import "Page/PageTitleView.h"
#import "PageContentView.h"
#define kScreenH [UIScreen mainScreen].bounds.size.height //屏幕高度
#define kScreenW [UIScreen mainScreen].bounds.size.width //屏幕宽度
///随机色
#define TPRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
@interface ViewController ()<PageTitleViewDelegate,PageContentViewDelegate>
///标题
@property (nonatomic,strong) PageTitleView *pageTitleView;
///标题数组
@property (nonatomic,strong) NSArray<NSString *> *titleArr;
///内容视图
@property (nonatomic,strong) PageContentView *pageContentView;
///展开按钮
@property (nonatomic,strong) UIButton *OpenTitleBtn;
@end

@implementation ViewController
static CGFloat navH = 64;
static CGFloat titleH = 44;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self SetupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 懒加载
- (NSArray<NSString *> *)titleArr{
    if (!_titleArr) {
        NSArray *arr = [[NSArray alloc]initWithObjects:@"推荐",@"游戏",@"拳王",@"视频",@"要闻",@"新时代",@"倾心一刻", nil];
        _titleArr = arr;
        
    }
    return _titleArr;
}

- (PageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        CGRect rect = CGRectMake(0, navH, kScreenW, titleH);
        PageTitleView *titleView = [[PageTitleView alloc]initWithFrame:rect titles:self.titleArr];
        titleView.backgroundColor = [UIColor whiteColor];
        titleView.delegate = self;
        _pageTitleView = titleView;
        
    }
    return _pageTitleView;
}

- (PageContentView *)pageContentView{
    if (!_pageContentView) {
        CGRect rect = CGRectMake(0, navH + titleH, kScreenW, kScreenH - navH - titleH);
//        //确定子控制器
//        NSMutableArray<UIViewController*> *childVcs = [[NSMutableArray alloc]init];
//        for (NSInteger i = 0; i < self.titleArr.count; i++) {
//            UIViewController *vc = [[UIViewController alloc]init];
//            vc.view.backgroundColor = TPRandomColor;
//            [childVcs addObject:vc];
//        }
//        PageContentView *pageContentV = [[PageContentView alloc]initWithFrame:rect childVcs:childVcs parentViewController:self];
        PageContentView *pageContentV  = [[PageContentView alloc]initWithFrame:rect childVcs:self.titleArr];
        pageContentV.delegate = self;
        _pageContentView = pageContentV;
    }
    return _pageContentView;
}

- (UIButton *)OpenTitleBtn{
    if (!_OpenTitleBtn) {
        CGFloat w = 30;
        CGRect rect = CGRectMake(kScreenW - w, 0, w, titleH);
        UIButton *openBtn = [[UIButton alloc]initWithFrame:rect];
        openBtn.backgroundColor = [UIColor blueColor];
        _OpenTitleBtn = openBtn;
    }
    return _OpenTitleBtn;
}
#pragma mark - UI
- (void)SetupUI{
    //设置标题视图
    [self.view addSubview:self.pageTitleView];
    
    //添加内容view
    [self.view addSubview:self.pageContentView];
    
    //添加展开按钮
    [_pageTitleView addSubview:self.OpenTitleBtn];
}


#pragma mark - PageTitleViewDelegate
- (void)pageTitleViewDidSelectTitle:(PageTitleView *)titleView selectorIndex:(NSInteger)selectorIndex{
    [self.pageContentView YJSetCurrentIndex:selectorIndex];
}

#pragma mark - PageContentViewDelegate
- (void)pageContentViewDidScroll:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView YJSetTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
@end
