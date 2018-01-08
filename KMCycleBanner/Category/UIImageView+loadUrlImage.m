//
//  UIImageView+loadUrlImage.m
//  Oc_runTimeTest
//
//  Created by kimilee on 2018/1/2.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import "UIImageView+loadUrlImage.h"
#import<CommonCrypto/CommonDigest.h>


@implementation UIImageView (loadUrlImage)

- (void)loadImageWithUrl:(NSURL *)url
{
    
    NSString * cacheKey = [self md5:url.absoluteString];
    NSCache * cache = [[NSCache alloc]init];
    
    NSData * imgData = [cache objectForKey:cacheKey];
    
    //拿取内存缓存
    if (imgData) {
        UIImage *img = [UIImage imageWithData: imgData];
        [self setImage:img];
        return;
    }
    
    dispatch_queue_t  q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(q, ^{

        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (imageData) {
            [cache setObject:imageData forKey:cacheKey];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{

            self.image = image;

        });

    });
    

    
//    NSURLSession *session =[NSURLSession sharedSession];
//    //创建会话
//    NSURLSessionDownloadTask *downLoadTask =[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //打印临时文件
//        NSLog(@"临时文件：%@",location);
//        //根据下载存放到的本地路径的文件来创建data对象
//        NSData *tempData = [NSData dataWithContentsOfURL:location];
//        
//        if (tempData)
//            [cache setObject:tempData forKey:cacheKey];
//        
//        UIImage *image =[UIImage imageWithData:tempData];
//        //刷新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self setImage:image];
//        });
//    }];
//    //启动任务
//    [downLoadTask resume];    
}

- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
