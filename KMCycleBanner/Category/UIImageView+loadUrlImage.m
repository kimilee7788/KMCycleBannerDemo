//
//  UIImageView+loadUrlImage.m
//  Oc_runTimeTest
//
//  Created by kimilee on 2018/1/2.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import "UIImageView+loadUrlImage.h"

@implementation UIImageView (loadUrlImage)

- (void)loadImageWithUrl:(NSURL *)url
{
    
    dispatch_queue_t  q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(q, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.image = image;
            
        });
        
    });
}

@end
