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

@interface KMCycleBanner : UIView

@property (nonatomic ,strong) NSArray * images;

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images;
@end
