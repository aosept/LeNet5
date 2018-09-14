//
//  ViewController.h
//  LenetMac
//
//  Created by 威 沈 on 14/09/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
-(void)dataRecived:(CGFloat)delta;
-(void)imageRecived:(const float**)data withName:(const char*)name;
-(void)dataOfindex:(int)dataIndex;
@end

