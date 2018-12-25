//
//  PageContentView.h
//  首页布局
//
//  Created by TP on 2018/8/9.
//  Copyright © 2018年 TP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageContentView;
//协议
@protocol PageContentViewDelegate<NSObject>
@optional
///
- (void)pageContentViewDidScroll:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@end



@interface PageContentView : UIView
//- (instancetype)initWithFrame:(CGRect)frame childVcs :(NSArray<UIViewController*>*)childVcs parentViewController:(UIViewController *)parentViewController;
- (instancetype)initWithFrame:(CGRect)frame childVcs :(NSArray<NSString*>*)childVcs;
//监听到PageTitleView的title的点击，跳转到指定的地方
- (void)YJSetCurrentIndex:(NSInteger)currentIndex;

///代理
@property (nonatomic,weak) id<PageContentViewDelegate> delegate;
@end
