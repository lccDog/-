//
//  PageTitleView.h
//  首页布局
//
//  Created by TP on 2018/8/9.
//  Copyright © 2018年 TP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageTitleView;
//协议
@protocol PageTitleViewDelegate<NSObject>
@optional
///
- (void)pageTitleViewDidSelectTitle:(PageTitleView *)titleView selectorIndex:(NSInteger)selectorIndex;
@end



@interface PageTitleView : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles;

///监听到PageContentView滚动，改变titleView
- (void)YJSetTitleWithProgress :(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

///代理
@property (nonatomic,weak) id<PageTitleViewDelegate> delegate;
@end
