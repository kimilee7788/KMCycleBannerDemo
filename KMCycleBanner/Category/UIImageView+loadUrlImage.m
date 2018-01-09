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
    //有本地缓存 拿取本地缓存图片
    NSData * imgData = [self readLocalCacheDataWithKey:[self md5Path:url.absoluteString]];
    
    if (imgData) {
        UIImage *image =[UIImage imageWithData:imgData];
        [self setImage:image];
        return;
    }
    
    //没有本地缓存
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError * error) {
                                        
                                        if (data) {
                                            //写入本地缓存
                                            [self writeLocalCacheData:data withKey:[self md5Path:url.absoluteString]];
                                            UIImage *image =[UIImage imageWithData:data];
                                            //刷新UI
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self setImage:image];
                                            });
                                        }
                                        
                                    }];
    [task resume];
}

- (NSData *)readLocalCacheDataWithKey:(NSString *)key {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 读取缓存数据
        return [NSData dataWithContentsOfFile:cachesPath];
    }
    return nil;
}

- (void)writeLocalCacheData:(NSData *)data withKey:(NSString *)key {
    // 设置存储路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        // 删除旧的缓存数据
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    }
    // 存储新的缓存数据
    [data writeToFile:cachesPath atomically:YES];
}

- (NSString *)md5Path:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [md5Str appendFormat:@"%02x", digest[i]];
    return  md5Str;
}

@end
