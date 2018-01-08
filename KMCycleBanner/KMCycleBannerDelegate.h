//
//  KMCycleBannerDelegate.h
//  KMCycleBannerDemo
//
//  Created by kimilee on 2018/1/8.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AUTOMATIC_SROLL_CHANGEKEY @"enabledAutoScroll"

@protocol KMCycleBannerDelegate

- (void)clickImageWithIndex:(NSInteger)index;

@end
