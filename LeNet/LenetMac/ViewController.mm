//
//  ViewController.m
//  LenetMac
//
//  Created by 威 沈 on 14/09/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "ViewController.h"
#include "SVCNNNetWork.hpp"
#import "MnistDecoder.h"
#import "SVUtils.h"
static void logMessage(const void*callback,const int index,const char *message)
{
    ViewController* vc = (__bridge ViewController*)callback;
    //    [vc dataOfindex:dataIndex];
    
}
static void trainData(const void*callback,const int dataIndex)
{
    ViewController* vc = (__bridge ViewController*)callback;
    [vc dataOfindex:dataIndex];
    
}
static void didRecieveData_t(const void*callback,const char *key, const float** value,float delta);
static void didRecieveData(const void*callback,const char *key, const float** value,float delta)
{
    
    std::thread loop;
    loop = std::thread(didRecieveData_t,callback,key,value,delta);
    if (loop.joinable()) {
        loop.join();
    }
    
}
static void didRecieveData_t(const void*callback,const char *key, const float** value,float delta)
{
    ViewController* vc = (__bridge ViewController*)callback;
    if(value == NULL)
    {
        [vc dataRecived:delta];
        
    }
    else
    {
        [vc imageRecived:value withName:key];
        
    }
}

@interface ViewController ()
{
    SVCNNNetWork* network;
    NSArray* array;
    int trainingCount;
    int trainLoop;
    __block int displayStep;
    
    int index;
    int derrordout;
    int doutdnet;
    int dnetdw;
    int ddelta;
    int dwv;
    
    float *** inputData;
    float **tlist;
    int inpuRow;
    int inpuCol;
}
@property (nonatomic,strong) MnistDecoder* decoder;
@property (nonatomic,strong) NSButton *checkButton;
@end
@implementation ViewController
-(NSButton*)checkButton
{
    if(_checkButton == nil)
    {
        _checkButton = [NSButton new];
        [_checkButton setTitle:@"Start"];
        _checkButton.bezelStyle = NSRoundedBezelStyle;
        [_checkButton setTarget:self];
        
        [_checkButton setAction:@selector(checkButtonClicked)];
        
    }
    return _checkButton;
}
-(void)autoencoderInit
{
    
    inpuRow = 32;
    inpuCol = 32;
    //    int outputCount = 1;
    
    
    int outValue = 10;
    self->network = new SVCNNNetWork();
    self->network->countOfcase = trainingCount;
    self->network->setCountOfcase(trainingCount);
    self->network->didRecieveDataCallback = didRecieveData;
    self->network->trainDataProvider = trainData;
    self->network->loginfo = logMessage;
    self->network->callbackNSObject = (__bridge void*)self;
}
-(void)dealloc
{
    if(network != NULL)
        delete network;
    network = NULL;
}

-(void)checkButtonClicked
{
  
    network->setLayerLog(index, derrordout, doutdnet, dnetdw, ddelta, dwv);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self goNNN];
    });
    NSLog(@"");
    return;
}
-(void)goNNN
{
    
    network->trainWithMultiDataCount(trainLoop, 0.001,0.02);
    network->showResult();
    
    displayStep = 1;
    
}
-(void)dataRecived:(CGFloat)delta
{
    
    if(delta < 5000 && delta > 0)
    {
        @autoreleasepool {
            NSNumber* number = [NSNumber numberWithDouble:delta];
            if ([number isKindOfClass:[NSNumber class]]) {
                array = [array arrayByAddingObject:number];
                runOnMainQueueWithoutDeadlocking(^{
//                    self.logTextView.text = [NSString stringWithFormat:@"%@",number];
                });
//                [self updateGraph:array];
            }
        }
    }
    
}
-(void)clearTrainData
{
    if(inputData != NULL)
    {
        
        for (int i = 0; i < 32; i++) {
            delete [] inputData[0][i];
        }
        delete [] inputData[0];
        delete [] inputData;
        
        inputData = NULL;
    }
    
    
    
    
    if(tlist != NULL)
    {
        delete [] tlist[0];
        delete [] tlist;
        
        tlist = NULL;
    }
}

-(void)dataOfindex:(int)dataIndex
{
    @autoreleasepool {
        [self clearTrainData];
        inputData = new float**[1];
        tlist = new float*[1];
        tlist[0] = new float[10];
        inpuRow = 32;
        inpuCol = 32;
        
        int imagew = 28;
        int imageh = 28;
        int pad = 2;
        
        uint8_t* imagedata = [self.decoder imageDataOfIndex:dataIndex];
        int v = [self.decoder labelDataOfIndex:dataIndex];
        //    NSLog(@"%d\n",v);
        
        
        memset(tlist[0], 0, 10*sizeof(float));
        for (int i = 0; i< 10; i++) {
            if(i == v)
            {
                tlist[0][i] = 0.0;
            }
            else
            {
                tlist[0][i] = 1.0;
            }
        }
        inputData[0] = new float*[inpuRow];
        for (int i = 0; i < inpuRow; i++) {
            inputData[0][i] = new float[inpuCol];
            for (int j = 0; j<inpuCol; j++) {
                
                if(i < pad || j < pad)
                {
                    inputData[0][i][j] = 0;
                }
                else  if(i >= inpuRow - pad || j >= inpuCol - pad)
                {
                    inputData[0][i][j] = 0;
                }
                else
                {
                    inputData[0][i][j] = imagedata[(i-pad)*imagew + (j-pad)]/255.0;
                }
            }
            
            
        }
        
        self->network->dataListSet(inputData,tlist);
    }
    
}
-(void)imageRecived:(const float**)data withName:(const char*)name
{
    @autoreleasepool {
//        NSString* imageName = [NSString stringWithUTF8String:name];
//        NSArray* plist = [imageName componentsSeparatedByString:@"_"];
//        if(plist.count != 4)
//            return;
//        int nameIndex = [plist[0] intValue];
//        NSString* iName = SafeString(plist[1]);
//        int width = [plist[2] intValue];
//        int height = [plist[3] intValue];
//        NSImage* image = [NSImage matrixToImage:data withH:height andW:width];
//        if(nameIndex == 0)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v1GridView viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 1)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v2Gridview viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 2)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v3Gridview viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 3)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v4Gridview viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 4)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v5Gridview viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 5)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v6Gridview viewOfName:iName];
//                imageView.image = image;
//            });
//
//
//        }
//        else if(nameIndex == 6)
//        {
//            runOnMainQueueWithoutDeadlocking(^{
//                NSImageView* imageView = (NSImageView*)[self.v7Gridview viewOfName:iName];
//                imageView.image = image;
//
//                //                NSImage* image = [NSImage floatArrayToImage:data withH:12 andW:7];
//                //
//                //                self.L6ImageView.image = image;
//            });
//
//
//        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.checkButton];
    
    
    inputData = NULL;
    tlist = NULL;
//    self.trainingCountTextField.text = @"10"; // count of training cases
//    //    self.trainingCountTextField.enabled = NO;
//    self.trainLoopTextfield.text = @"1"; // count of loop
//    self.indexTextfield.text = @"-1";//  < 0 means no log
    network = NULL;
//    self.dataChartView.chartView.style = SVStatisticsViewLine;
//    self.dataChartView.chartView.colorArray = @[[UIColor greenColor],[UIColor blueColor],[UIColor redColor]];
//    self.delegate = self;
    array  = @[];
    NSString* fileName = @"train-images";
    self.decoder = [MnistDecoder new];
    [self.decoder decodeMinstImage:fileName];
    
    NSString* labelFileName = @"train-labels";
    [self.decoder decodeMinstLabel:labelFileName];
    
    trainingCount = 1;//[self.trainingCountTextField.text intValue];//self.decoder.count;
    trainLoop =  1;//[self.trainLoopTextfield.text intValue];
    
    index =  0;//[self.indexTextfield.text intValue];
    derrordout = 0;
    doutdnet =0;
    dnetdw = 0;
    ddelta = 0;
    dwv = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self autoencoderInit];
    });
}

-(void)viewDidLayout
{
    [super viewDidLayout];
    CGFloat x,y,w,h;
    x = 0;
    y = 0;
    w = self.view.frame.size.width/2;
    
    if(w < 200)
        w = 200;
    
    h = self.view.frame.size.height;
    
    
    
    x = self.view.frame.origin.x;
    y = self.view.frame.origin.y;
    
    h = 30;
    w = 60;
    
    self.checkButton.frame = CGRectMake(x, y, w, h);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
