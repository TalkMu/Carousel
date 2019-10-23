//
//  ViewController.m
//  Carousel
//
//  Created by Zhuang Yang on 2019/10/23.
//  Copyright © 2019 Zhuang Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;

@property(nonatomic,weak) UIPageControl *pageControl;

@property(nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController



/// 滚动监听事件
/// @param scrollView <#scrollView description#>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint scrollOffSet = scrollView.contentOffset;
    NSInteger index = scrollOffSet.x / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}


/// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
/// @param scrollView <#scrollView description#>
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //这是timer永久的停止, 停止后, 一定要将timer赋空, 否则还是没有释放, 会造成不必要的内存开销
    [self.timer invalidate];
}


/// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
/// @param scrollView <#scrollView description#>
/// @param velocity <#velocity description#>
/// @param targetContentOffset <#targetContentOffset description#>
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    CGFloat scrollH = 640/3;
    CGFloat scrollW = 1024/3;
    
    self.scrollView.frame = CGRectMake((self.view.frame.size.width-scrollW)/2, 50, scrollW, scrollH);
    
    for (int i=0; i<6; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        NSString *path = [NSString stringWithFormat:@"%02d",i+1];
        imgView.image = [UIImage imageNamed:path];
        
        CGFloat imgViewX = i*scrollW;
        
        imgView.frame = CGRectMake(imgViewX, 0, scrollW, scrollH);
        
        [self.scrollView addSubview:imgView];
    }
    
    //设置scrollView内容大小
    [self.scrollView setContentSize:CGSizeMake(scrollW*6, 0)];
    
    [self.view addSubview:scrollView];
    
    //启用分页
    self.scrollView.pagingEnabled = YES;
    
    //创建分页下标控件
    UIPageControl *page = [[UIPageControl alloc]init];
    self.pageControl = page;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 6;
    self.pageControl.frame = CGRectMake((self.view.frame.size.width-scrollW)/2, 240, scrollW, 20);
    
    [self.view addSubview:self.pageControl];
    
    self.scrollView.delegate = self;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    //禁用scrolliview滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    //修改timerx优先级与控件一样
    //j获取当前消息循环对象
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}


/// 翻页方法
-(void) nextPage
{
    CGPoint point = self.scrollView.contentOffset;
    
    int index = point.x/(1024/3);
    if (index>=5) {
        point.x = 0;
    }else{
        point.x += 1024/3;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = point;
    }];
    
    
}


@end
