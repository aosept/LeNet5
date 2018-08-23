//
//  SVCNNViewController.h
//  MLPractice
//
//  Created by 威 沈 on 07/08/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "CNN.h"

@interface SVCNNViewController : CNN
-(void)dataRecived:(CGFloat)delta;
-(void)imageRecived:(const float**)data withName:(const char*)name;
-(void)dataOfindex:(int)dataIndex;
@end
