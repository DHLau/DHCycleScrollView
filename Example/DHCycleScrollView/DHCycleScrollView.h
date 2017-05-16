//
//  DHCycleScrollView.h
//  DHCycleScrollView
//
//  Created by LDH on 17/5/16.
//  Copyright © 2017年 DHLau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHCycleScrollViewProtocol.h"

typedef void (^LoadImageBlock)(UIImageView *imageView, NSURL *url);

@protocol DHCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDidClickPicModel:(id<DHCycleScrollViewProtocol>)picModel;

@end

@interface DHCycleScrollView : UIView

+ (instancetype)cycleScrollViewWithLoadImageBlock:(LoadImageBlock)loadBlock;

@property (nonatomic, copy) LoadImageBlock loadBlock;

@property (nonatomic, strong) id<DHCycleScrollViewDelegate> delegate;

@property (nonatomic, strong) NSArray <id <DHCycleScrollViewProtocol>> *picModels;

@end
