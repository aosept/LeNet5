//
//  SVCNNViewController.m
//  MLPractice
//
//  Created by 威 沈 on 07/08/2018.
//  Copyright © 2018 ShenWei. All rights reserved.
//

#import "SVCNNViewController.h"
#import "MSDateUtils.h"
#import "SVChartView.h"
#include "SVCNNNetWork.hpp"
#import "MnistDecoder.h"
#import "SVGridView.h"
#import "UIImage+SV.h"

static void trainData(const void*callback,const int dataIndex)
{
    SVCNNViewController* vc = (__bridge SVCNNViewController*)callback;
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
    SVCNNViewController* vc = (__bridge SVCNNViewController*)callback;
    if(value == NULL)
    {
        [vc dataRecived:delta];
        
    }
    else
    {
        [vc imageRecived:value withName:key];
        
    }
}


@interface SVCNNViewController ()<CNNDelegate>
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

@end

@implementation SVCNNViewController
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
//-()old
//{
//    float *** inputData = new float**[trainingCount];
//    float **tlist = new float*[trainingCount];
//
//
//
//    for (int k = 0; k < trainingCount; k++) {
//
//        tlist[k] = new float[outValue];
//
//        uint8_t* imagedata = [self.decoder imageDataOfIndex:k];
//        int v = [self.decoder labelDataOfIndex:k];
//        NSLog(@"%d\n",v);
//
//
//        memset(tlist[k], 0, 10*sizeof(float));
//        tlist[k][v] = 1.0;
//        inputData[k] = new float*[28];
//        for (int i = 0; i < inpuRow; i++) {
//            inputData[k][i] = new float[28];
//            for (int j = 0; j<inpuCol; j++) {
//                inputData[k][i][j] = imagedata[i*28 + j]/255.0;
//            }
//
//
//        }
//
//    }
//
//}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.v1GridView.delegate = self;
    self.v2Gridview.delegate = self;
    self.v3Gridview.delegate = self;
    self.v4Gridview.delegate = self;
    self.v5Gridview.delegate = self;
    self.v6Gridview.delegate = self;
    self.v7Gridview.delegate = self;
    self.logTextView.editable = NO;
    self.v1GridView.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.v2Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.v3Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    self.v4Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    self.v5Gridview.col = 10;
    self.v5Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                                 @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                 @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                 @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                 @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                 @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",
                                 @"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",
                                 @"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",
                                 @"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",
                                 @"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",
                                 @"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110",
                                 @"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119",];
    self.v6Gridview.col = 7;
    self.v6Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                                 @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                 @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                 @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                 @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                 @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",
                                 @"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",
                                 @"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",
                                 @"81",@"82",@"83"];
    self.v7Gridview.dataList = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",];
    
//    self.v1GridView.backgroundColor = [UIColor redColor];
//    self.v2Gridview.backgroundColor = [UIColor redColor];
//    self.v3Gridview.backgroundColor = [UIColor redColor];
//    self.v4Gridview.backgroundColor = [UIColor redColor];
    
    inputData = NULL;
    tlist = NULL;
    self.trainingCountTextField.text = @"3"; // count of training cases
    self.trainingCountTextField.enabled = NO;
    self.trainLoopTextfield.text = @"1"; // count of loop
    self.indexTextfield.text = @"-1";//  < 0 means no log
    network = NULL;
    self.dataChartView.chartView.style = SVStatisticsViewLine;
    self.dataChartView.chartView.colorArray = @[[UIColor greenColor],[UIColor blueColor],[UIColor redColor]];
    self.delegate = self;
    array  = @[];
    NSString* fileName = @"train-images";
    self.decoder = [MnistDecoder new];
    [self.decoder decodeMinstImage:fileName];
    
    NSString* labelFileName = @"train-labels";
    [self.decoder decodeMinstLabel:labelFileName];
    
    trainingCount = [self.trainingCountTextField.text intValue];//self.decoder.count;
    trainLoop = [self.trainLoopTextfield.text intValue];
    
    index = [self.indexTextfield.text intValue];
    derrordout = 0;
    doutdnet =0;
    dnetdw = 0;
    ddelta = 0;
    dwv = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self autoencoderInit];
    });
    
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
    self->network->callbackNSObject = (__bridge void*)self;
}
-(void)dealloc
{
    if(network != NULL)
        delete network;
    network = NULL;
}


-(void)runButtonClicked
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
    
    network->trainWithMultiDataCount(trainLoop, 0.001,0.5);
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
                    self.logTextView.text = [NSString stringWithFormat:@"%@",number];
                });
                [self updateGraph:array];
            }
        }
    }
    
}
-(void)updateGraph:(NSArray*)array
{
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        runOnMainQueueWithoutDeadlocking(^{
            @autoreleasepool {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.dataChartView.dataDic[@"r"] = array;
                //            strongSelf.dataChartView.dataDic[@"w2"] = w;
                [strongSelf.dataChartView refreshUIAsSheet];
            }
            
        });
        
    });
    
    
}
-(void)imageRecived:(const float**)data withName:(const char*)name
{
    @autoreleasepool {
        NSString* imageName = [NSString stringWithUTF8String:name];
        NSArray* plist = [imageName componentsSeparatedByString:@"_"];
        if(plist.count != 4)
            return;
        int nameIndex = [plist[0] intValue];
        NSString* iName = SafeString(plist[1]);
        int width = [plist[2] intValue];
        int height = [plist[3] intValue];
        UIImage* image = [UIImage matrixToImage:data withH:height andW:width];
        if(nameIndex == 0)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v1GridView viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 1)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v2Gridview viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 2)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v3Gridview viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 3)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v4Gridview viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 4)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v5Gridview viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 5)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v6Gridview viewOfName:iName];
                imageView.image = image;
            });
            
            
        }
        else if(nameIndex == 6)
        {
            runOnMainQueueWithoutDeadlocking(^{
                UIImageView* imageView = (UIImageView*)[self.v7Gridview viewOfName:iName];
                imageView.image = image;
                
//                UIImage* image = [UIImage floatArrayToImage:data withH:12 andW:7];
//
//                self.L6ImageView.image = image;
            });
            
            
        }
        
    }
}
#pragma mark - deletage
-(void)updateSVGridView:(SVGridView*)gridView WithDic:(NSDictionary*)dic
{
    
    return;
}
-(UIView*)uiviewForGridView:(SVGridView*)gridView ByName:(NSString*)name
{
    @autoreleasepool {
        UIImage* image = [UIImage imageNamed:@"jin"];
        UIImageView* imageView = [UIImageView new];
        imageView.image = image;
        return imageView;
    }
    
}
-(CGRect)rectByForGridView:(SVGridView*)gridView Name:(NSString*)name
{
    return CGRectMake(0, 0, 100, 100);
}
-(void)moveToFocus:(SVGridView*)gridView Name:(NSString*)name
{
    return;
}
-(void)stopToFocus:(SVGridView *)gridView Name:(NSString *)name
{
    return;
}
-(CGFloat)rateOfHeight
{
    CGFloat rate = 1;
    return rate;
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardHieght=keyBoardRect.size.height;
    offsetY = 0-keyBoardHieght;
    [self viewDidLayoutSubviews];
    
}

-(void)keyboardHide:(NSNotification *)note
{
    keyBoardHieght = 0;
    offsetY = 0-keyBoardHieght;
    [self viewDidLayoutSubviews];
}
-(void)changeCNN:(CNN*)vc WithName:(NSString*)name andValue:(CGFloat)value
{
    NSLog(@"name:%f",value);
    trainingCount = [self.trainingCountTextField.text intValue];//self.decoder.count;
    trainLoop = [self.trainLoopTextfield.text intValue];
    index = [self.indexTextfield.text intValue];
    derrordout = self.derrdoutSwitch.on;
    doutdnet = self.doutdnetSwitch.on;
    dnetdw = self.dnetdwSwitch.on;
    ddelta = self.deltaruleSwitch.on;
    dwv = self.dwvSwitch.on;
    network->setLayerLog(index, derrordout, doutdnet, dnetdw, ddelta, dwv);
}
-(void)endEditCNN:(CNN *)vc WithName:(NSString *)name andText:(NSString *)text
{
    trainingCount = [self.trainingCountTextField.text intValue];//self.decoder.count;
    trainLoop = [self.trainLoopTextfield.text intValue];
    index = [self.indexTextfield.text intValue];
    derrordout = self.derrdoutSwitch.on;
    doutdnet = self.doutdnetSwitch.on;
    dnetdw = self.dnetdwSwitch.on;
    ddelta = self.deltaruleSwitch.on;
    dwv = self.dwvSwitch.on;
    network->setLayerLog(index, derrordout, doutdnet, dnetdw, ddelta, dwv);
}
@end
