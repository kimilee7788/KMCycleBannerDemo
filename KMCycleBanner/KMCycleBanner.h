//
//  KMCycleBanner.h
//  Oc_runTimeTest
//
//  Created by kimilee on 2018/1/2.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "UIImageView+loadUrlImage.h"
#import "KMCycleBannerDelegate.h"

@interface KMCycleBanner : UIView

//DataSource
@property (nonatomic ,strong) NSArray * images;
//delegate
@property (nonatomic ,weak) id  delegate;
//是否自动滚动
@property (nonatomic ,assign) BOOL enabledAutoScroll;
//自动滚动图片间隔
@property (nonatomic ,assign) NSTimeInterval timerDuration;

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images;
@end
