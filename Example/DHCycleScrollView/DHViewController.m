//
//  DHViewController.m
//  DHCycleScrollView
//
//  Created by DHLau on 05/16/2017.
//  Copyright (c) 2017 DHLau. All rights reserved.
//

#import "DHViewController.h"
#import "DHCycleScrollView.h"
#import "DHTestModel.h"
#import "UIImageView+WebCache.h"

@interface DHViewController ()

@property (nonatomic, strong) DHCycleScrollView *cycleScrollView;

@end

@implementation DHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *urlStrArr = @[
                           @"http://pic11.nipic.com/20101214/213291_155243023914_2.jpg",
                           @"http://pic.58pic.com/58pic/14/27/45/71r58PICmDM_1024.jpg",
                           @"http://scimg.jb51.net/allimg/150629/14-1506291A242927.jpg",
                           @"http://pic.58pic.com/58pic/13/87/72/73t58PICjpT_1024.jpg"
                           ];
    NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:4];
    for (NSString *urlStr in urlStrArr) {
        DHTestModel *testModel = [[DHTestModel alloc] init];
        testModel.adImgURL = [NSURL URLWithString:urlStr];
        [modelArr addObject:testModel];
    }
    
    self.cycleScrollView = [DHCycleScrollView cycleScrollViewWithLoadImageBlock:^(UIImageView *imageView, NSURL *url) {
        [imageView sd_setImageWithURL:url];
    }];
    self.cycleScrollView.frame = CGRectMake(0,
                                            0,
                                            [UIScreen mainScreen].bounds.size.width,
                                            200);
    self.cycleScrollView.picModels = modelArr;
    [self.view addSubview:self.cycleScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
