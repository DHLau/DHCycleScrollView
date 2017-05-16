//
//  DHCycleScrollViewProtocol.h
//  DHCycleScrollView
//
//  Created by LDH on 17/5/16.
//  Copyright © 2017年 DHLau. All rights reserved.
//

@protocol DHCycleScrollViewProtocol <NSObject>

@property (nonatomic, copy, readonly) NSURL *adImgURL;

// Have a higher priority than DHCycleScrollViewDelegate method
@property (nonatomic, copy) void(^clickBlock)();

@end
