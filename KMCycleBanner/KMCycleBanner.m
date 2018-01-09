//
//  KMCycleBanner.m
//  Oc_runTimeTest
//
//  Created by kimilee on 2018/1/2.
//  Copyright © 2018年 kimilee. All rights reserved.
//

#import "KMCycleBanner.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define DEFAULT_DURATION 3.0f

@interface KMCycleBanner()<UIScrollViewDelegate,KMCycleBannerDelegate>

@property (nonatomic ,strong) UIScrollView * scrollView;
@property (nonatomic ,strong) UIImageView * leftImageView;
@property (nonatomic ,strong) UIImageView * rightImageView;
@property (nonatomic ,strong) UIImageView * centerImageView;
@property (nonatomic ,strong) UIPageControl * pageControl;

@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic ,weak) NSTimer * timer;

@end

@implementation KMCycleBanner

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images{
    
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
        //监听是否自动滚动
        [self addObserver:self forKeyPath:AUTOMATIC_SROLL_CHANGEKEY options:NSKeyValueObservingOptionNew context:nil];
        //设置默认滚动间隔
        _timerDuration = DEFAULT_DURATION;
        
    }
    
    return self;
}

- (void)setImages:(NSArray *)images{
    _images = [[NSArray alloc]initWithArray:images];
    [self loadData];
}

- (void)loadData{
    [_scrollView setContentSize:CGSizeMake(self.width*self.images.count, 0)];
    [_pageControl setNumberOfPages:self.images.count];
    [self setImageWithIndex:_currentIndex animated:NO];
}

//设置移动到中间
- (void)moveScrollViewToCenter{
    [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
}

- (void)setImageWithIndex:(NSInteger)index animated:(BOOL)animated{
    if (index>self.images.count||self.images.count==0) {
        return;
    }
    //设置前后数据索引
    NSInteger leftIndex = (unsigned long)((index - 1 + self.images.count) % self.images.count);
    NSInteger rightIndex = (unsigned long)((index + 1) % self.images.count);
    
    //重新加载图片
    [_centerImageView loadImageWithUrl:[NSURL URLWithString:self.images[index]]];
    [_leftImageView loadImageWithUrl:[NSURL URLWithString:self.images[leftIndex]]];
    [_rightImageView loadImageWithUrl:[NSURL URLWithString:self.images[rightIndex]]];

    [_pageControl setCurrentPage:index];
    [self moveScrollViewToCenter];
}

#pragma mark UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //往右边滑动
    if (scrollView.contentOffset.x >= scrollView.width*2){
        _currentIndex = (_currentIndex +1)%self.images.count;
        [self setImageWithIndex:_currentIndex animated:NO];
    }
    
    //往左滑动
    else if (scrollView.contentOffset.x == 0){
        _currentIndex = (_currentIndex -1 + self.images.count)%self.images.count;
        [self setImageWithIndex:_currentIndex animated:NO];
    }
}

#pragma mark UI

- (void)layoutSubviews
{
    //设置轮播视图布局
    _scrollView.frame = self.bounds;
    _leftImageView.frame = _centerImageView.frame = _rightImageView.frame = _scrollView.bounds;
    _leftImageView.right = _centerImageView.left;
    _rightImageView.left = _centerImageView.right;
    
    //设置pageControl布局
    _pageControl.width = self.width/2;
    _pageControl.centerX = self.centerX;
    _pageControl.bottom = self.height -20;
}

- (void)setupView{
    
    [self.scrollView addSubview:self.rightImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.leftImageView];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageWithIndex:)];
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView addGestureRecognizer:tap];
        
    }
    
    return _scrollView;
}

- (UIImageView *)leftImageView{
    
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _leftImageView.contentMode = UIViewContentModeScaleToFill;
        [_leftImageView setBackgroundColor:[UIColor redColor]];
    }
    
    return _leftImageView;
}

- (UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _rightImageView.contentMode = UIViewContentModeScaleToFill;
        [_rightImageView setBackgroundColor:[UIColor blueColor]];
    }
    return _rightImageView;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _centerImageView.contentMode = UIViewContentModeScaleToFill;
        [_centerImageView setBackgroundColor:[UIColor yellowColor]];
    }
    return _centerImageView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        
        //todo 添加pageControl点击事件
    }
    return _pageControl;
}

#pragma mark action

//设置图片点击事件
- (void)clickImageWithIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(clickImageWithIndex:)]) {
        [_delegate clickImageWithIndex:_currentIndex];
    }
}

#pragma mark KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:AUTOMATIC_SROLL_CHANGEKEY]) {
     
        BOOL isAutoScroll = [change objectForKey:@"new"];
        if (isAutoScroll) {
            if (!_timer) {
                WS(wself)
                _timer = [NSTimer timerWithTimeInterval:_timerDuration target:wself selector:@selector(timerAction) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }
        }
        else{
            if (_timer)
                [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)timerAction
{
    NSLog(@"自动翻页");
    dispatch_async(dispatch_get_main_queue(), ^{
        //翻页动画可以自定义
        [UIView animateWithDuration:0.5f animations:^{
            [_scrollView setContentOffset:CGPointMake(_scrollView.width*2, 0)];
        } completion:^(BOOL finished) {
            _currentIndex = (_currentIndex +1)%self.images.count;
            [self setImageWithIndex:_currentIndex animated:YES];
        }];
    });
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:AUTOMATIC_SROLL_CHANGEKEY];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)removeFromSuperview
{
    //销毁Timer防止循环引用
    
    [super removeFromSuperview];

    [_timer invalidate];
    _timer = nil;
}

@end
