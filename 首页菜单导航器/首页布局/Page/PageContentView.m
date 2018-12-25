//
//  PageContentView.m
//  首页布局
//
//  Created by TP on 2018/8/9.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "PageContentView.h"
#import "ContentViewCell.h"
///随机色
#define TPRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
@interface PageContentView()<UICollectionViewDataSource,UICollectionViewDelegate>
///子控制器
@property (nonatomic,strong) NSArray<NSString *> *childVcs;
/////父控制器
//@property (nonatomic,weak) UIViewController *parentViewController;
///存放控制器view
@property (nonatomic,strong) UICollectionView *collectionView;
///开始偏移量
@property (nonatomic,assign) NSInteger startOffset;
///判断是否要通知代理执行方法
@property (nonatomic,assign,getter=isForbidScrollDelegate) BOOL isForbidScrollDelegate;
@end
@implementation PageContentView
static NSString *contextCellId = @"contextCellId";

- (instancetype)initWithFrame:(CGRect)frame childVcs :(NSArray<NSString*>*)childVcs{
    _childVcs = childVcs;
    self = [super initWithFrame:frame];
    if (self) {
        [self YJSetupUI];
    }
    return self;
}
#pragma mark - 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView  *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.bounces = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        //注册cell
        [collectionView registerClass:[ContentViewCell class] forCellWithReuseIdentifier:contextCellId];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (BOOL)isForbidScrollDelegate{
    if (!_isForbidScrollDelegate) {
        _isForbidScrollDelegate = NO;
    }
    return _isForbidScrollDelegate;
}
#pragma mark - UI
- (void)YJSetupUI{
    //添加UICollectionView,用于在cell中存放控制器view
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ContentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contextCellId forIndexPath:indexPath];
    cell.backgroundColor = TPRandomColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;
    self.startOffset = scrollView.contentOffset.x;
}
//监听ContentView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //0.判断是否点击事件
    if (self.isForbidScrollDelegate)return;
    //1.定义获取数据
    CGFloat progress;   //进度
    NSInteger sourceIndex;  //目前 titleViewIndex
    NSInteger targetIndex;  //目标 titleViewIndex
    
    //2.判断滑动方向
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > _startOffset) {    //左滑
        //1.计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        //2.计算sourceIndex
        sourceIndex = currentOffsetX / scrollViewW;
        
        //3.计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= _childVcs.count) {
            targetIndex = _childVcs.count - 1;
        }
        //4.完全滑过去了
        if (currentOffsetX - _startOffset == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else{  //右滑
        //1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        //2.计算targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        
        //3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= _childVcs.count) {
            sourceIndex = _childVcs.count - 1;
        }
    }
    
    //3.0传递progress/sourceIndex/targetIndex值给titleView
    //通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentViewDidScroll:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentViewDidScroll:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}
//结束滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //1.拿出当前cell
    ContentViewCell *cell = self.collectionView.visibleCells.firstObject;
    
}
#pragma mark - 对外界暴露方法

- (void)YJSetCurrentIndex:(NSInteger)currentIndex{
    //1.记录需要禁止代理
    self.isForbidScrollDelegate = YES;
    
    CGFloat offsetX = currentIndex * _collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}
@end
