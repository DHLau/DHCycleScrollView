//
//  DHTestModel.h
//  DHCycleScrollView
//
//  Created by LDH on 17/5/16.
//  Copyright © 2017年 DHLau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHCycleScrollViewProtocol.h"

@interface DHTestModel : NSObject<DHCycleScrollViewProtocol>

@property (nonatomic, copy) NSURL *adImgURL;

@property (nonatomic, copy) void(^clickBlock)();

@end
