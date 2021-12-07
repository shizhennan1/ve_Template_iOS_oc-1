//
//  TTViewController.m
//  TTAppUpdateHelper
//
//  Created by Sunhaiyuan on 04/11/2018.
//  Copyright (c) 2018 Bytedance.com All rights reserved.
//

/*
  这里简单的示例，方便业务方接入的时候参考，基本上按照以下方法实现即可
 */

#import "TTViewController.h"
#import <VEAppUpdateHelper/TTAppUpdateHelperDefault.h>
#import <OneKit/OKServiceCenter.h>
#import <OneKit/OKApplicationInfo.h>
#import <OneKit/OKServices.h>
#import <OneKit/OKStartUpFunction.h>

@interface TTViewController ()<TTAppUpdateDelegate>
@property (nonatomic, strong) TTAppUpdateHelperDefault *updateHelper;
@end

@implementation TTViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self update];
}


- (void)update {
    if(!self.updateHelper) {
        __block id<OKDeviceService> deviceService = [[OKServiceCenter sharedInstance] serviceForProtocol:@protocol(OKDeviceService)];
        OKApplicationInfo *info = [OKApplicationInfo sharedInstance];
        TTAppUpdateHelperDefault *defaultHelper = [[TTAppUpdateHelperDefault alloc] initWithDeviceID:deviceService.deviceID
                                                                                                     channel:@"update"
                                                                                                 aid:info.appID delegate:self];
        self.updateHelper = defaultHelper;
        self.updateHelper.callType = @(0);

        self.updateHelper.city = @"Shanghai";
        NSDictionary *params = @{@"user_id" : @"1234501",
                                 @"user_role" : @"00010015",
                                 @"user_department" : @"DP13852"
        };
        self.updateHelper.customData = params;
        [defaultHelper startCheckVersion];
      
      
     };
        
      
      
}

#pragma mark TTAppUpdateDelegate
- (void)updateViewShouldShow:(TTAppUpdateTipView *)tipView model:(TTAppUpdateModel *)model {
    //弹窗开启弹窗，先判断url有效性
    if ([self verifyWebUrlAddress:model.downloadURL]) {
        [tipView show];
    }
    //弹窗关闭业务自己处理数据，不用处理tipView
}

- (void)updateViewShouldClosed:(TTAppUpdateTipView *)tipView {
    [tipView hide];
    self.updateHelper = nil;
}

- (BOOL)verifyWebUrlAddress:(NSString *)webUrl
{
    if (!webUrl) {
          return NO;
      }
    return [UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:webUrl]];
}
@end
