//
//  DHCycleScrollView.m
//  DHCycleScrollView
//
//  Created by LDH on 17/5/16.
//  Copyright © 2017年 DHLau. All rights reserved.
//

#import "DHCycleScrollView.h"
static NSInteger const radio = 10;
static NSInteger const timeInterval = 3;

@interface DHCycleScrollView()<UIScrollViewDelegate>
{
    NSInteger _currentPage;
}

@property (nonatomic, strong) NSMutableArray <UIImageView *>*adPics;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation DHCycleScrollView

+ (instancetype)cycleScrollViewWithLoadImageBlock:(LoadImageBlock)loadBlock
{
    DHCycleScrollView *cycleScrollView = [DHCycleScrollView new];
    cycleScrollView.loadBlock = loadBlock;
    return cycleScrollView;
}

- (void)setPicModels:(NSArray<id<DHCycleScrollViewProtocol>> *)picModels
{
    _picModels = picModels;
    
    [self.adPics makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.adPics = nil;
    
    NSInteger baseCount = picModels.count;
    NSInteger count = baseCount;
    if (baseCount > 1) {
        count = baseCount * radio;
    }
    for (int i = 0; i < count; i++) {
        id<DHCycleScrollViewProtocol> picM = picModels[i % baseCount];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = self.adPics.count;
        
        if (self.loadBlock) {
            self.loadBlock(imageView, picM.adImgURL);
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLink:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        [self.contentView addSubview:imageView];
        [self.adPics addObject:imageView];
    }
    
    self.pageControl.numberOfPages = picModels.count;
    [self setNeedsLayout];
    
    if (picModels.count > 1) {
        [self.scrollTimer fire];
    } else {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)jumpToLink:(UITapGestureRecognizer *)gesture
{
    UIView *imageView = gesture.view;
    NSInteger tag = imageView.tag % self.picModels.count;
    id<DHCycleScrollViewProtocol> adM = self.picModels[tag];
    
    if (adM.clickBlock != nil) {
        adM.clickBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    
    NSInteger count = self.adPics.count;
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = self.adPics[i];
        imageView.frame = CGRectMake(i * width, 0, width, height);
    }
    self.contentView.contentSize = CGSizeMake(width * count, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}

#pragma mark - <UISCrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.adPics.count > 1) {
        [self scrollTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self caculateCurrentPage:scrollView];
}

#pragma mark - CoreMethod
- (void)caculateCurrentPage:(UIScrollView *)scrollView {
    if (self.picModels.count == 0) {
        return;
    }
    if (self.picModels.count == 1) {
        _currentPage = 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollViewDidClickPicModel:)]) {
            [self.delegate cycleScrollViewDidClickPicModel:self.picModels[self.pageControl.currentPage]];
        }
        return;
    }
    
    // 确认中间区域
    NSInteger min = self.picModels.count * (radio / 2);
    NSInteger max = self.picModels.count * (radio / 2 + 1);
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page % self.picModels.count;
    
    if (page < min || page > max) {
        page = min + page % self.picModels.count;
        [scrollView setContentOffset:CGPointMake(page * scrollView.frame.size.width, 0)];
    }
    
    _currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidClickPicModel:)]) {
        [self.delegate cycleScrollViewDidClickPicModel:self.picModels[self.pageControl.currentPage]];
    }
}

- (void)autoScrollToNextPage {
    NSInteger page = _currentPage + 1;
    [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width * page, 0) animated:YES];
}

#pragma mark - Lazy
- (NSTimer *)scrollTimer {
    if (_scrollTimer == nil) {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoScrollToNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
    return _scrollTimer;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UIScrollView *)contentView
{
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.pagingEnabled = YES;
        contentView.showsHorizontalScrollIndicator = NO;
        _contentView = contentView;
        _contentView.delegate = self;
        [self addSubview:contentView];
    }
    return _contentView;
}

- (NSMutableArray<UIImageView *> *)adPics
{
    if (_adPics == nil) {
        _adPics = [NSMutableArray array];
    }
    return _adPics;
}

@end
