//
//  PageTitleView.m
//  首页布局
//
//  Created by TP on 2018/8/9.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "PageTitleView.h"

#define selectorColor  TPColor(255, 0, 0)
#define NormalColor  TPColor(85, 85, 85)
#define kScreenH [UIScreen mainScreen].bounds.size.height //屏幕高度
#define kScreenW [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define TPColor(r,g,b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
///滚动条的高度
static CGFloat const kScrollLineH = 2.0;
//标题右边距
static CGFloat const kLeftMargin = 30.0;
//选中颜色 -》255，0，0
//普通颜色 -》85，85，85
static CGFloat RedcolorDelta = 170;
static CGFloat GreencolorDelta = -85;
static CGFloat BluecolorDelta = -85;

@interface PageTitleView()
///标题文字数组
@property (nonatomic,strong) NSArray<NSString *> *titles;
///覆盖整个视图的scrollView
@property (nonatomic,strong) UIScrollView *scrollView;
///定义一个数组，记录UILabel
@property (nonatomic,strong) NSMutableArray<UILabel *> *titleLabels;
///滚动条
@property (nonatomic,strong) UIView *scrollLine;
///上一个label的下标值
@property (nonatomic,assign) NSInteger currentIndex;
@end
@implementation PageTitleView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles{
    _titles = titles;
    self = [super initWithFrame:frame];
    if (self) {
        [self YJSetupUI];
    }
    return self;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGRect rect = self.bounds;
        rect.size.width -= kLeftMargin;
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rect];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.pagingEnabled = NO;
        scrollView.bounces = NO;
        _scrollView = scrollView;
    }
    return _scrollView;
}
- (NSMutableArray<UILabel *> *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [[NSMutableArray alloc]init];
    }
    return _titleLabels;
}

- (UIView *)scrollLine{
    if (!_scrollLine) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor redColor];
        _scrollLine = line;
    }
    return _scrollLine;
}
#pragma mark - UI
- (void)YJSetupUI{
    //添加UIScrollView
    [self addSubview:self.scrollView];
    //添加title对应的label
    [self YJSetupTitleLabel];
    //设置标题的位置
    [self YJsetupTitleLabelsFrame];
    //设置底线和滚动的滑块
    [self YJsetupBottonMenuAndScrollLine];
}

#pragma mark - 点击事件

///标题点击
- (void)titleLableClick:(UITapGestureRecognizer *)tapGes{
    
    if ([tapGes.view isKindOfClass:[UILabel class]]) {
        //1.获取当前label
        UILabel *currentLabel = (UILabel *)tapGes.view;
        if (currentLabel.tag == _currentIndex) {
            return;
        }
        //2.获取当前label
        UILabel *oldLabel = _titleLabels[_currentIndex];
        
        //3.切换颜色
        currentLabel.textColor = selectorColor;
        oldLabel.textColor = NormalColor;
        //保存下标
        _currentIndex = currentLabel.tag;
        
        
        //4.0让标题居中
        [self YJTitleMiddleWithLabel:currentLabel];
        
        
        //5.0滚动条位置改变
        CGRect scrollLineRect = _scrollLine.frame;
        scrollLineRect.origin.x = currentLabel.frame.origin.x;
        scrollLineRect.size.width = currentLabel.frame.size.width;
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollLine.frame = scrollLineRect;
        }];
        
        //6.0通知代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageTitleViewDidSelectTitle:selectorIndex:)]) {
            [self.delegate pageTitleViewDidSelectTitle:self selectorIndex:_currentIndex];
        }
    }
}

#pragma mark - Other

///添加titleLabel
- (void)YJSetupTitleLabel{
    NSInteger index = 0;
    for (NSString *title in _titles) {
        //创建UILabel
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = NormalColor;
        if (index == 0) {
            label.textColor = selectorColor;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = index;
        label.adjustsFontSizeToFitWidth = YES;
        //添加手势
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLableClick:)];
        [label addGestureRecognizer:tapGes];
        
        index += 1;
        
        [_scrollView addSubview:label];
        [self.titleLabels addObject:label];
    }
}
///设置标题(Label)的位置
- (void)YJsetupTitleLabelsFrame{
    NSInteger index = 0;
    static CGFloat itemMargin = kLeftMargin;
    static CGFloat labelY = 0;
    static CGFloat labelW = 0;
    CGFloat labelH = self.frame.size.height;
    CGSize size = CGSizeMake(MAXFLOAT, 0);
    for (UILabel *label in self.titleLabels) {
        CGFloat labelX = labelW * index;
        //根据文字计算宽度
        NSString *text = _titles[index];
        labelW = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil].size.width;
        
        if (index == 0) {
            labelX = itemMargin * 0.5;
        }else{
            UILabel *prelabel = _titleLabels[index - 1];
            labelX = prelabel.frame.origin.x+prelabel.frame.size.width + itemMargin;
        }
        //设置label位置
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        //设置scrollView滚动范围
        _scrollView.contentSize = CGSizeMake(_titleLabels.lastObject.frame.origin.x+_titleLabels.lastObject.frame.size.width, 0);
        index += 1;
    }
}
///底线和滚动的滑块
- (void)YJsetupBottonMenuAndScrollLine{
    //添加底线
   CGRect rect = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0.5);
    UIView *line = [[UIView alloc]initWithFrame: rect];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    //添加滚动条
    UILabel *firstLabel = _titleLabels.firstObject;
    if (!firstLabel) return;
    
    self.scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - kScrollLineH, firstLabel.frame.size.width, kScrollLineH);
    [self.scrollView addSubview:self.scrollLine];
}

///标题居中
- (void)YJTitleMiddleWithLabel:(UILabel *)label{
    
    CGPoint offset = _scrollView.contentOffset;
    offset.x = label.center.x - kScreenW * 0.5;
    //4.1最大的偏移量 = scrollView的宽度 - 屏幕的宽度
    CGFloat offsetMax = _scrollView.contentSize.width - kScreenW + kLeftMargin;
    //4.2判断label是否要居中。
    //如果偏移量小于0, 就不居中, 而且如果偏移量 > 最大偏移量, 让偏移量 = 最大偏移量, 从而实现不居中
    if (offset.x < 0) { //左边超出处理
        offset.x = 0;
    }else if (offset.x > offsetMax){    //右边超出的处理
        offset.x = offsetMax;
    }
    //4.3.滚动标题，带动画
    [_scrollView setContentOffset:offset animated:YES];
}


#pragma mark - 对外暴露方法
- (void)YJSetTitleWithProgress :(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    ///判断
    if (sourceIndex == targetIndex)return;
    //1.取出progress/ sourceIndex / targetIndex
    UILabel *sourceLabel = _titleLabels[sourceIndex];
    UILabel *targetLabel = _titleLabels[targetIndex];
    
    //2.处理滑块
    //2.1总滑动距离值
    CGFloat MoveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    //2.2总的滑动宽度
    CGFloat daltaTotalWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
    //2.3滑动的x值
    CGFloat moveX = MoveTotalX * progress;
    //2.4需滑动的宽值
    CGFloat deltaW = daltaTotalWidth * progress;
    CGRect scrollLineRect = self.scrollLine.frame;
    scrollLineRect.origin.x = sourceLabel.frame.origin.x + moveX;
    scrollLineRect.size.width = sourceLabel.frame.size.width + deltaW;
    _scrollLine.frame = scrollLineRect;
    
    //3.颜色渐变
    sourceLabel.textColor = TPColor(255-RedcolorDelta * progress, 0 - GreencolorDelta *progress, 0 - BluecolorDelta *progress);
    targetLabel.textColor = TPColor(85+RedcolorDelta *progress, 85+GreencolorDelta *progress, 85+BluecolorDelta *progress);
    
    //4.记录最新的index
    _currentIndex = targetIndex;
    
    //5.标题居中
    [self YJTitleMiddleWithLabel:targetLabel];
}
@end
