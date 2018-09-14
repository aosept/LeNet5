//
//  SVUtils.h
//  LenetMac
//
//  Created by 威 沈 on 14/09/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SafeString(text)            [NSString stringWithFormat:@"%@", text]
#define SafeStringExt(text,ext)     [NSString stringWithFormat:@"%@.%@", text,ext]
#define SafeStringJoin(text,ext)    [NSString stringWithFormat:@"%@%@", text,ext]
#define SafeStringLog(text,ext)     [NSString stringWithFormat:@"%@\n%@", text,ext]
#define SafeStringConfig(text)      [NSString stringWithFormat:@"%@.Config", text]
#define DailyContentFont @"Helvetica" //@"CTXingKaiSJ"//@"TrebuchetMS" ///@"AaWanWan" //
#define DailyTitleFont @"Arial-BoldMT"// @"AaWanWan"//
#define _mDatilContentWidth 355.0

#define kaipan 1
#define shoupan 2
#define zuidi 4
#define zuigao 3
#define huanshou 5


//#define helpForUIDesignAlways @"helpForUIDesignAlways"
#define debug_function_and_line_info NSLog(@"%s:%d",__func__,__LINE__)
#ifdef DEBUG
#define SVLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define SVLog(format, ...)
#endif


static void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@interface SVUtils : NSObject

@end
