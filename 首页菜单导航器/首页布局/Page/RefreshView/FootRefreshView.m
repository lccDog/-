//
//  FootRefreshView.m
//  首页布局
//
//  Created by TP on 2018/8/10.
//  Copyright © 2018年 TP. All rights reserved.
//

#import "FootRefreshView.h"

@implementation FootRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self YJSetupUI];
    }
    return self;
}

- (void)YJSetupUI{
    UILabel *footLabel = [[UILabel alloc]initWithFrame:self.bounds];
    footLabel.text = @"上拉加载更多...";
    footLabel.textColor = [UIColor redColor];
    footLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:footLabel];
}
@end
