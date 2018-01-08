//
//  ViewController.m
//  KMCycleBannerDemo
//
//  Created by kimilee on 2018/1/3.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import "ViewController.h"
#import "KMCycleBanner.h"

@interface ViewController ()<KMCycleBannerDelegate>
@property (nonatomic ,strong) KMCycleBanner * banner;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.banner];

    NSArray * images = @[@"1.jpg",@"2.jpg",@"3.jpg"];
    
    NSMutableArray * imgArr = [[NSMutableArray alloc]init];
    
            [imgArr addObject:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=534858419,2528258774&fm=200&gp=0.jpg"];
            [imgArr addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514955973136&di=da338a23521bf415ff7e933db4a0848f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fbf096b63f6246b60553a62a0e1f81a4c510fa22a.jpg"];
            [imgArr addObject:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1436948145,4270509323&fm=200&gp=0.jpg"];

    
    _banner.images = imgArr;
    
}


- (void)clickImageWithIndex:(NSInteger)index
{

}

- (KMCycleBanner *)banner
{
    if (!_banner) {
        _banner = [[KMCycleBanner alloc]init];
        _banner.width = [UIScreen mainScreen].bounds.size.width;
        _banner.height = 200;
        _banner.top = self.navigationController.navigationBar.height+20;
        _banner.delegate = self;
        _banner.enabledAutoScroll = YES;
    }
    return _banner;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


