//
//  KMCycleBanner.m
//  Oc_runTimeTest
//
//  Created by kimilee on 2018/1/2.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import "KMCycleBanner.h"

@interface KMCycleBanner()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView;

@property (nonatomic ,strong) UIImageView * leftImageView;
@property (nonatomic ,strong) UIImageView * rightImageView;
@property (nonatomic ,strong) UIImageView * centerImageView;

@property (nonatomic ,strong) UIPageControl * pageControl;
@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic ,strong) NSTimer * timer;

@end

@implementation KMCycleBanner

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
{
    self = [self initWithFrame:frame];
    if (self) {
        [self setImages:images];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setImages:(NSArray *)images
{
    _images = [[NSArray alloc]initWithArray:images];
    [self loadData];
}


- (void)loadData
{
    [_scrollView setContentSize:CGSizeMake(self.width*self.images.count, 0)];
    [_pageControl setNumberOfPages:self.images.count];
    
    [self setImageWithIndex:_currentIndex];
}

//设置移动到中间
- (void)moveScrollViewToCenter
{
    [_scrollView setContentOffset:CGPointMake(self.width, 0)];
}

- (void)setImageWithIndex:(NSInteger)index
{
    if (index>self.images.count||self.images.count==0) {
        return;
    }
    
    NSInteger leftIndex = (unsigned long)((index - 1 + self.images.count) % self.images.count);
    NSInteger rightIndex = (unsigned long)((index + 1) % self.images.count);
    
    [_centerImageView setImage:[UIImage imageNamed:self.images[index]]];
    [_leftImageView setImage:[UIImage imageNamed:self.images[leftIndex]]];
    [_rightImageView setImage:[UIImage imageNamed:self.images[rightIndex]]];
    
    [_pageControl setCurrentPage:index];
    
    [self moveScrollViewToCenter];
}

#pragma mark UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= scrollView.width*2)
    {
        _currentIndex = (_currentIndex +1)%self.images.count;
        [self setImageWithIndex:_currentIndex];
    }
    else if (scrollView.contentOffset.x == 0)
    {
        _currentIndex = (_currentIndex -1 + self.images.count)%self.images.count;
        [self setImageWithIndex:_currentIndex];
    }
}

#pragma mark UI

- (void)setupView
{
    [self.scrollView addSubview:self.rightImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.leftImageView];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self subImageLayout];
}

- (void)subImageLayout
{
    _centerImageView.left = _leftImageView.right;
    _rightImageView.left = _centerImageView.right;
    
    _pageControl.width = self.width/2;
    _pageControl.centerX = self.centerX;
    _pageControl.bottom = self.height -20;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_leftImageView setBackgroundColor:[UIColor redColor]];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_rightImageView setBackgroundColor:[UIColor blueColor]];
    }
    return _rightImageView;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_centerImageView setBackgroundColor:[UIColor yellowColor]];
    }
    return _centerImageView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}

@end
