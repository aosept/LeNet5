//
//  SVAnalysisGraphView.m
//  JustPlay
//
//  Created by 沈威 on 15/1/23.
//  Copyright (c) 2015年 Shen Wei. All rights reserved.
//

#import "SVAnalysisGraphView.h"


#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

#define RefTime  0.02

#define DescriptAreaHight 100

#define upColor [NSColor colorWithRed:246.0/255.0 green:80.0/255.0 blue:77.0/255.0 alpha:1.0]
#define downColor [NSColor colorWithRed:63.0/255.0 green:217.0/255.0 blue:163.0/255.0 alpha:1.0]


#define upColorCGColor [NSColor colorWithRed:246.0/255.0 green:80.0/255.0 blue:77.0/255.0 alpha:1.0].CGColor
#define downColorCGColor [NSColor colorWithRed:62.0/255.0 green:217.0/255.0 blue:163.0/255.0 alpha:1.0].CGColor

#define lineColorCGColor [NSColor colorWithRed:92.0/255.0 green:75.0/255.0 blue:118.0/255.0 alpha:1.0].CGColor

#define fillDownColor2 CGContextSetRGBFillColor(myContext, 62.0/255.0, 217.0/255.0, 163.0/255.0, 0)

#define fillUpColor2 CGContextSetRGBFillColor(myContext, 246.0/255.0, 80.0/255.0, 77.0/255.0, 0)
#define fillUpColor CGContextSetRGBFillColor(myContext, 246.0/255.0, 80.0/255.0, 77.0/255.0, 1)
#define fillSelectedColor CGContextSetRGBFillColor(myContext, 244.0/255.0, 230.0/255.0, 227.0/255.0, 1)
#define fillDownColor CGContextSetRGBFillColor(myContext, 62.0/255.0, 217.0/255.0, 163.0/255.0, 1)
#define fillRectBorderColor CGContextSetRGBFillColor(myContext, 53.0/255.0, 50.0/255.0, 58.0/255.0, 1)
#define fillLineColor CGContextSetRGBFillColor(myContext, 114.0/255.0, 126.0/255.0, 190.0/255.0, 1)
#define watchColor [NSColor whiteColor]
#define fillOpenPriceColor CGContextSetRGBFillColor(myContext, 150.0/255.0, 126.0/255.0, 217.0/255.0, 1)
#define fillWhiteColor CGContextSetRGBFillColor(myContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1)
#define fillBlueColor CGContextSetRGBFillColor(myContext, 0.0/255.0, 0.0/255.0, 255.0/255.0, 1)


#define spaceHeight (100)

@interface SVGraphView ()
{
    CGPoint touchBeginPoint;
    CGPoint touchEndPoint;
    NSTimeInterval beginTimeinterval;
    NSTimeInterval endTimeinterval;
    __block CGFloat v;
    __block BOOL moved;
    
    CGFloat indexValue;
    SVGraphViewInterativeMode status;
    
    CGFloat touchX;
    
    
}
@property (nonatomic,strong) NSTimer* timer;


@end



@implementation IHCoordinate


- (id)init
{
    self = [super init];
    if (self) {
        _stepx = 40;
        _stepy = 1;
        
        _maxy = 100;
        _miny = 0;
    
        
    }
    return self;
}
- (void)configCoordinateWithOffsetPoint:(CGPoint)offsetPoint
{
    _coordinateX = offsetPoint.x;
    _coordinateY = 0;
    
}
- (void)coculateAllValue
{
    
    
    self.west = 0-self.coordinateX/self.stepx;
    //    self.east = (self.contentSize.width - self.coordinateX)/self.stepx;
    //    east需要人为设置
    self.stepy = self.maxy/self.north; //north需要认为设置
    //    self.south = (self.coordinateY - self.contentSize.height)/self.stepy;
}
@end


@implementation SVGraphView

- (void)setStockArray:(NSArray *)stockArray
{
    _stockArray = stockArray;
    _maArray5 = [NSMutableArray arrayWithArray:stockArray];
    _maArray10 = [NSMutableArray arrayWithArray:stockArray];
    _maArray20 = [NSMutableArray arrayWithArray:stockArray];
    _maArray60 = [NSMutableArray arrayWithArray:stockArray];
    _maArray120 = [NSMutableArray arrayWithArray:stockArray];
    
}
- (void)coculateA
{

    CGFloat m = 0;
    CGFloat allVolume = 0;
    CGFloat mm = 0;
    
    for (int i = 0; i< [self.stockArray count]; i++) {
        
        if (self.style == SVGraphViewReal)
        {
            id a = self.stockArray[i];
            
            
            
            NSString* o =[NSString stringWithFormat:@"%@",a];
            
            NSArray* ta = [o componentsSeparatedByString:@" "];
            
            CGFloat price = [ta[1] floatValue];
            
            CGFloat volume = [ta[2] floatValue];
            
            m = m + price*volume;
            mm = mm + price*price;
            
//            NSLog(@"price:%f",price);
            allVolume = allVolume + volume;
        }
        
        
        
//                NSLog(@"m:%f",m/(i+1));
        self.maArray5[i] = [NSNumber numberWithFloat:m/allVolume];
//        self.maArray10[i] = [NSNumber numberWithFloat:sqrt(mm/(i+1))];
    }
}
- (void)coculateAllMA
{
    [self coculateMA5];
    [self coculateMA10];
    [self coculateMA20];
    [self coculateMA60];
    [self coculateMA120];
}
- (void)coculateMA5
{
    int days = 5;
    CGFloat m = 0;
    _macount5 = days;
    
    for (int i = days; i< [self.stockArray count]; i++) {
        m = 0;
        for (int j = 0; j<days; j++) {
            NSArray* a = self.stockArray[i-j];
            m += [a[2] floatValue];
//            NSLog(@"a:%@",a[2]);
            
        }
        m = m/_macount5;
//        NSLog(@"m:%f",m);
        self.maArray5[i] = [NSNumber numberWithFloat:m];
    }
//    NSLog(@"");
}
- (void)coculateMA10
{
    int days = 10;
    CGFloat m = 0;
    _macount10 = days;
    
    for (int i = days; i< [self.stockArray count]; i++) {
        m = 0;
        for (int j = 0; j<days; j++) {
            NSArray* a = self.stockArray[i-j];
            m += [a[2] floatValue];
//            NSLog(@"a:%@",a[2]);
            
        }
        m = m/_macount10;
//        NSLog(@"m:%f",m);
        self.maArray10[i] = [NSNumber numberWithFloat:m];
    }
//    NSLog(@"");
}
- (void)coculateMA20
{
    int days = 20;
    CGFloat m = 0;
    _macount20 = days;
    
    for (int i = days; i< [self.stockArray count]; i++) {
        m = 0;
        for (int j = 0; j<days; j++) {
            NSArray* a = self.stockArray[i-j];
            m += [a[2] floatValue];
//            NSLog(@"a:%@",a[2]);
            
        }
        m = m/_macount20;
//        NSLog(@"m:%f",m);
        self.maArray20[i] = [NSNumber numberWithFloat:m];
    }
//    NSLog(@"");
}
- (void)coculateMA60
{
    int days = 60;
    CGFloat m = 0;
    _macount60 = days;
    
    for (int i = days; i< [self.stockArray count]; i++) {
        m = 0;
        for (int j = 0; j<days; j++) {
            NSArray* a = self.stockArray[i-j];
            m += [a[2] floatValue];
            //            NSLog(@"a:%@",a[2]);
            
        }
        m = m/_macount60;
        //        NSLog(@"m:%f",m);
        self.maArray60[i] = [NSNumber numberWithFloat:m];
    }
    //    NSLog(@"");
}
- (void)coculateMA120
{
    int days = 120;
    CGFloat m = 0;
    _macount120= days;
    
    for (int i = days; i< [self.stockArray count]; i++) {
        m = 0;
        for (int j = 0; j<days; j++) {
            NSArray* a = self.stockArray[i-j];
            m += [a[2] floatValue];
            //            NSLog(@"a:%@",a[2]);
            
        }
        m = m/_macount120;
        //        NSLog(@"m:%f",m);
        self.maArray120[i] = [NSNumber numberWithFloat:m];
    }
    //    NSLog(@"");
}
-(NSString *)transf:(NSString *)price{
    NSString *realprice;
    NSArray *num = [price componentsSeparatedByString:@"."];
    
    
    if ([num count] > 0) {
        realprice = num[0];
    }
    else
        realprice = nil;
    //    NSLog(@"sizeof:%lu",sizeof(num[0]));
    if (realprice.length >= 2) {
        realprice = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    }else {
        realprice = [NSString stringWithFormat:@"%.4f",[price floatValue]];
    }
    return realprice;
}
-(NSString *)transf2:(NSString *)price{
    NSString *realprice;
    NSArray *num = [price componentsSeparatedByString:@"."];
    
    
    if ([num count] > 0) {
        realprice = num[0];
    }
    else
        realprice = nil;
    //    NSLog(@"sizeof:%lu",sizeof(num[0]));
    if (realprice.length >= 2) {
        realprice = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    }else {
        realprice = [NSString stringWithFormat:@"%.5f",[price floatValue]];
    }
    return realprice;
}
- (id)initWithScale:(CGFloat)ftScale
{
    self = [super init];
    if (self) {
        _coordinateX = 0;
        _coordinateY = 0;
        _fontScale = ftScale;
        _contentOffsetValue = 0;
        _stepx = 5;
        _stepy = 5;
        _up = YES;
        self.maxy = 0;
        self.miny = 0;
        moved = YES;
        indexValue = 0;
        _touchY=0.0;
        status = SVGraphViewInterativeModeScroll;
        _displayRate = 1;
        _style = SVGraphViewKline;
        
        _descriptAreaHeight = 34.0*_fontScale;
        
        _gapHeight = 12;
        _startIndex = 0;
        _offsetIndex = self.frame.size.width/self.stepx;
        _autoAdjust = YES;
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coordinateX = self.frame.size.width*0.5;
        _coordinateY = self.frame.size.height*0.5;
        _fontScale = 1;
        _contentOffsetValue = 0;
        _stepx = 5;
        _stepy = 5;
        _up = YES;
        self.maxy = 0;
        self.miny = 0;
        moved = YES;
        indexValue = 0;
        _touchY=0.0;
        status = SVGraphViewInterativeModeScroll;
        _displayRate = 1;
        _style = SVGraphViewKline;
        _macount5 = 5;
        _macount10 = 10;
        _macount20 = 20;
        _macount60 = 60;
        _macount120 = 120;
        _descriptAreaHeight = 34.0*_fontScale;
        
        _gapHeight = 2;
        _startIndex = 0;
        _offsetIndex = self.frame.size.width/self.stepx;
        _autoAdjust = YES;
        
    }
    return self;
}

- (CGFloat)widthRate
{
    if (_widthRate <=0) {
        _widthRate = self.frame.size.width/320.0;
    }
    return _widthRate;
}
- (IHCoordinate*)extentCoorinate
{
    if (_extentCoorinate == nil) {
        _extentCoorinate = [[IHCoordinate alloc] init];
    }
    return _extentCoorinate;
}
- (void)drawBackGround:(CGContextRef) myContext rect:(CGRect)rect
{
    CGFloat x,y,w,h;
    x = 0;
    y = 0;
    w = rect.size.width;
    h = rect.size.height;
    
    CGContextSaveGState(myContext);
    if (self.style == SVGraphViewZline) {
        CGContextSetRGBFillColor(myContext, 0.0/255.0, 0.0/255.0, 0.0/255.0, 1);
    }
    else
        CGContextSetRGBFillColor(myContext, 26.0/255.0, 17.0/255.0, 38.0/255.0, 1);
    CGContextFillRect(myContext, CGRectMake(x, y, w, h));
    
    //    CGContextSetRGBFillColor(myContext, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
    //    CGContextFillRect(myContext, CGRectMake(0.5, 0.5, w - 1,h -1));
}
- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    NSRect bounds = [self bounds] ;
    
    [[NSColor colorWithCalibratedRed:26.0/255.0 green:17.0/255.0 blue:38.0/255.0 alpha:1.0] set] ;
    
    [NSBezierPath fillRect: bounds] ;
    
    [self coculateAllValue];
    //    NSLog(@"%s",__func__);
    
    
    
    
    
    
}
- (void)setContentOffset
{
    CGFloat position = [self mostRightPosition];
    if(position > self.frame.size.width)
        _contentOffsetValue = position - self.frame.size.width;
    else
        _contentOffsetValue = 0;
    //    if (_contentOffsetValue < -200)
    //        NSLog(@"dd");
    //    NSLog(@"%s,%f",__func__,_contentOffsetValue);
}
- (CGFloat)mostRightPosition
{
    [self coculateAllValue];
    return self.east*self.stepx;
}
-(CGFloat)fontScale
{
    if(_fontScale == 0)
    {
        
        _fontScale =1;
    }
    return _fontScale;
}
- (void)coculateAllValue
{
    self.coordinateX = 0;
    if (self.style == SVGraphViewKline) {
        self.coordinateY = spaceHeight*self.fontScale; //上下比例
        self.descriptAreaHeight = 34*self.fontScale;
    }
    else
    {
        self.coordinateY = spaceHeight*self.fontScale; //上下比例
        self.descriptAreaHeight = 20*self.fontScale;
        
    }
    
    
    if (self.maxy > 0) {
        
        if ((self.maxy-self.miny) != 0) {
            CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY+spaceHeight);
            self.stepy = (dataGraphHight)/(self.maxy-self.miny);
        }
        else
        {
            
        }
        
    }
    else
    {
        //        NSLog(@"wrong");
        self.maxy = 100;
        self.miny = 0;
    }
    
    self.west = 0-self.coordinateX/self.stepx;
    self.east = 100;
    
    self.north = (self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY))/self.stepy;
    self.south = (self.coordinateY)/self.stepy;
    
    CGPoint ppp;
    ppp.x = self.coordinateX;
    ppp.y = self.coordinateY;
//    [self.extentCoorinate configCoordinateWithOffsetPoint:ppp];
    self.extentCoorinate.east = self.east;
    self.extentCoorinate.coordinateX = self.coordinateX;
    
//    self.extentCoorinate.maxy = self.coordinateY;
    self.extentCoorinate.north = self.extentCoorinate.maxy;
    [self.extentCoorinate coculateAllValue];
    
    
    self.extentCoorinate.stepy = (ppp.y-self.coordinateY)/self.extentCoorinate.maxy;
    
}
- (CGFloat)transY:(CGFloat)oy
{
    return (_coordinateY + oy);
}

- (CGFloat)transX:(CGFloat)ox   //逻辑
{
    return (_coordinateX + ox) - self.contentOffsetValue;
}
- (CGFloat)StaticTransX:(CGFloat)ox // 屏幕
{
    return (_coordinateX + ox);
}

- (CGFloat)transExCooY:(CGFloat)oy
{
    return (self.extentCoorinate.coordinateY + oy);
}

- (CGFloat)transExCooX:(CGFloat)ox   //逻辑
{
    return (self.extentCoorinate.coordinateX + ox) - self.contentOffsetValue;
}
- (CGFloat)StaticTransExCooX:(CGFloat)ox // 屏幕
{
    return (self.extentCoorinate.coordinateX + ox) - self.contentOffsetValue;
}

- (void)drawPoint:(CGPoint)point
{
    
    CGFloat radius = 5.0;
    CGMutablePathRef cgPath = CGPathCreateMutable();
    
    CGFloat x,y,w,h;
    x = point.x-radius/2.0;
    y = point.y+radius/2.0;
    w = radius;
    h = radius;
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake([self transX:x],[self transY:y],w,h));
    x++;
    y--;
    w = w -2;
    h = h -2;

    NSBezierPath *aPath = [NSBezierPath bezierPath];

    [aPath appendBezierPathWithRoundedRect:NSMakeRect(x, y, w, h) xRadius:radius yRadius:radius];
    
    [aPath fill];
    
    CGPathRelease(cgPath);
}
- (CGFloat)screenXtoX:(CGFloat)x
{
    return x - _coordinateX +_contentOffsetValue;
}
- (CGFloat)screenYtoY:(CGFloat)y
{
//    if (y < self.descriptAreaHeight+self.gapHeight) {
//        y = self.descriptAreaHeight+self.gapHeight;
//    }
//    if (y > self.coordinateY) {
//        y = self.coordinateY;
//    }
    return y - _coordinateY;
}

- (void)drawSpecialLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    if (from.y > dataGraphHight) {
        from.y = dataGraphHight;
    }
    
    if (to.y > dataGraphHight) {
        to.y = dataGraphHight;
    }
    
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [NSColor yellowColor].CGColor);
    if (self.style == SVGraphViewKline) {
        CGContextSetLineWidth(myContext, .5);
    }
    else
        CGContextSetLineWidth(myContext, .5);
    
    if (self.style == SVGraphViewKline) {
        
        CGContextSetStrokeColorWithColor(myContext, lineColorCGColor);
        
        
    }
    else if(self.style == SVGraphViewAppleWatch)
    {
        CGContextSetLineJoin(myContext,kCGLineJoinRound);
        CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:226.0/255.0 blue:147.0/255.0 alpha:1.0].CGColor);
    }
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);

}
- (void)drawLineSelectedFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    if (from.y > dataGraphHight) {
        from.y = dataGraphHight;
    }
    
    if (to.y > dataGraphHight) {
        to.y = dataGraphHight;
    }
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];//UIGraphicsGetCurrentContext();
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
    if (self.style == SVGraphViewKline) {
        CGContextSetLineWidth(myContext, 1);
    }
    else
        CGContextSetLineWidth(myContext, 0.5);
    
    if (self.style == SVGraphViewKline) {
        
        CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
        
        
    }
    else if(self.style == SVGraphViewAppleWatch)
    {
        CGContextSetLineJoin(myContext,kCGLineJoinRound);
        CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    }
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}
- (void)drawLineForMaFrom:(CGPoint)point1 to:(CGPoint)point2 withColor:(NSColor*) theColor
{
    
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    if (from.y > dataGraphHight) {
        from.y = dataGraphHight;
    }
    
    if (to.y > dataGraphHight) {
        to.y = dataGraphHight;
    }
    
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    CGContextSetLineWidth(myContext, 0.5);
    CGContextSetStrokeColorWithColor(myContext,theColor.CGColor);
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}

- (void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    if (from.y > dataGraphHight) {
        from.y = dataGraphHight;
    }
    
    if (to.y > dataGraphHight) {
        to.y = dataGraphHight;
    }
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
    if (self.style == SVGraphViewKline) {
        CGContextSetLineWidth(myContext, 1);
    }
    else
        CGContextSetLineWidth(myContext, 0.5);
    
    if (self.style == SVGraphViewKline) {
        if (_up) {
            CGContextSetStrokeColorWithColor(myContext,upColorCGColor);
        }
        else{
            CGContextSetStrokeColorWithColor(myContext, downColorCGColor);
            
        }
    }
    else if(self.style == SVGraphViewAppleWatch)
    {
        CGContextSetLineJoin(myContext,kCGLineJoinRound);
        CGContextSetStrokeColorWithColor(myContext, [NSColor whiteColor].CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    }
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}

- (void)drawLine2From:(CGPoint)point1 to:(CGPoint)point2
{
    
    if (self.style == SVGraphViewKline) {
        
        return;
    }
    CGPoint from,to;
    from.x = [self transX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self transX:point2.x];
    to.y = [self transY:point2.y];
    
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    if (from.y > dataGraphHight) {
        from.y = dataGraphHight;
    }
    
    if (to.y > dataGraphHight) {
        to.y = dataGraphHight;
    }
    [NSGraphicsContext saveGraphicsState];
    NSBezierPath* clipPath = [NSBezierPath bezierPath];
    
    [[NSColor whiteColor] set];
    
    //    CGContextSetStrokeColorWithColor(myContext, [NSColor yellowColor].CGColor);
    if (self.style == SVGraphViewKline) {
        [clipPath setLineWidth:1.0];
    }
    else
        [clipPath setLineWidth:0.5];
    
    if (self.style == SVGraphViewKline) {
        
    }
    else
    {
        [clipPath setLineJoinStyle:NSRoundLineJoinStyle];
        
        CGFloat r,g,b,dr,dg,db;
        NSUInteger countofrecord;
        if (self.stepx != 0) {
            countofrecord  = self.frame.size.width/self.stepx;
        }
        else
        {
            countofrecord  = 1;
        }
        r = 253;
        g = 186;
        b = 0;
        
        dr = 2.0/(double)countofrecord;
        dg = 40.0/(double)countofrecord;
        db = 147.0/(double)countofrecord;
        NSUInteger num;
        num = to.x/self.stepx;
        
        NSColor * color = [NSColor colorWithRed:(r+num*dr)/255.0 green:(g+num*dg)/255.0 blue:(b+num*db)/255.0 alpha:1.0];
        [color set];
        
    }
    
    
    [clipPath moveToPoint:NSMakePoint(from.x, from.y)];
    [clipPath lineToPoint:NSMakePoint(to.x, to.y)];
    [clipPath fill];
    [NSGraphicsContext restoreGraphicsState];
}
- (void)drawLogcalPoint:(CGPoint)point
{
    point.x = point.x*_stepx;
    point.y = point.y*_stepy;
    
    [self drawPoint:point];
}

- (void)drawLogicalLineFromSelected:(CGPoint)p1 to:(CGPoint)p2
{
    p1.x = p1.x*_stepx+0.5;
    p1.y = p1.y*_stepy;
    
    p2.x = p2.x*_stepx+0.5;
    p2.y = p2.y*_stepy;
    
    [self drawLineSelectedFrom:p1 to:p2];
    
}
- (void)drawLogicalLineFrom:(CGPoint)p1 to:(CGPoint)p2
{
    p1.x = p1.x*_stepx+0.5;
    p1.y = p1.y*_stepy;
    
    p2.x = p2.x*_stepx+0.5;
    p2.y = p2.y*_stepy;
    
    [self drawLineFrom:p1 to:p2];
    
    if (self.style != SVGraphViewKline) {
        [self drawLine2From:p1 to:p2];
    }
}
- (void)drawMALineFrom:(CGPoint)p1 to:(CGPoint)p2 withColor:(NSColor*) color
{
    p1.x = p1.x*_stepx+0.5;
    p1.y = p1.y*_stepy;
    
    p2.x = p2.x*_stepx+0.5;
    p2.y = p2.y*_stepy;
    
    
    [self drawLineForMaFrom:p1 to:p2 withColor:color];
}

#pragma mark - 关于触摸操作的处理函数
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateGraphview];
}
- (void)updateGraphview
{
    CGPoint p;
    p.x = 0;
    p.y = 0;
    //    NSLog(@"%s",__func__);
    //    NSLog(@"Move on........");
    
    
        
        CGFloat position = self.east*_stepx;
        
        if (position > self.frame.size.width && self.style == SVGraphViewKline) {
//            _contentOffsetValue = _contentOffsetValue - (p.x - touchBeginPoint.x);
            
            _contentOffsetValue = self.east*_stepx - self.frame.size.width;
            if (_contentOffsetValue < self.west*_stepx) {
                _contentOffsetValue = self.west*_stepx;
                //                NSLog(@"Load more .....");
                if (self.loadingMore) {
                    
                }
                else
                {
                    [self.delegate reloadDataForSymbol];
                    self.loadingMore = YES;
                }
            }
            
            else if (_contentOffsetValue > (self.east*_stepx - self.frame.size.width)) {
                
                CGFloat position = self.east*_stepx;
                if (1) {
                    _contentOffsetValue = (self.east*_stepx - self.frame.size.width);
                }
                
            }
            
            
            double duration;
            duration = [NSDate timeIntervalSinceReferenceDate] - beginTimeinterval;
            
            v = (p.x - touchBeginPoint.x)/duration;
            //            NSLog(@"moving:v:%f",v);
            beginTimeinterval = [NSDate timeIntervalSinceReferenceDate];
        }

    
    //    NSLog(@"--------V:%f,%f",v,duration);
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    
  
    //    NSLog(@"contentOffsetValue:%f",_contentOffsetValue);
    [self setNeedsDisplay:YES];
}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
-(void)mouseDragged:(NSEvent *)event
{
    NSPoint p = event.locationInWindow;
    //    NSLog(@"%s",__func__);
    //    NSLog(@"Move on........");
    
    if (status == SVGraphViewInterativeModeScroll ) {
        
        CGFloat position = self.east*_stepx;
        
        if (position > self.frame.size.width && self.style == SVGraphViewKline) {
            _contentOffsetValue = _contentOffsetValue - (p.x - touchBeginPoint.x);
            
            
            if (_contentOffsetValue < self.west*_stepx) {
                _contentOffsetValue = self.west*_stepx;
//                NSLog(@"Load more .....");
                if (self.loadingMore) {
                    
                }
                else
                {
                    [self.delegate reloadDataForSymbol];
                    self.loadingMore = YES;
                }
            }
            
            else if (_contentOffsetValue > (self.east*_stepx - self.frame.size.width)) {
                
                CGFloat position = self.east*_stepx;
                if (1) {
                    _contentOffsetValue = (self.east*_stepx - self.frame.size.width);
                }
                
            }
            
            
            double duration;
            duration = [NSDate timeIntervalSinceReferenceDate] - beginTimeinterval;
            
            v = (p.x - touchBeginPoint.x)/duration;
            //            NSLog(@"moving:v:%f",v);
            beginTimeinterval = [NSDate timeIntervalSinceReferenceDate];
        }
        
    }
    //    NSLog(@"--------V:%f,%f",v,duration);
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    
    moved = YES;
    //    NSLog(@"contentOffsetValue:%f",_contentOffsetValue);
    [self setNeedsDisplay:YES];
}
- (BOOL)moved
{
    return moved;
}
-(void)mouseDown:(NSEvent *)event
{
    self.fingerDown = YES;
    NSPoint p = event.locationInWindow;
    self.beTouched = YES;
    [self.timer invalidate];
    self.timer = nil;
    
    
    beginTimeinterval = [NSDate timeIntervalSinceReferenceDate];
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    touchX = p.x;
    moved = NO;
    //    NSLog(@"%s",__func__);
    
}
- (NSInteger)screenTouchPointIndex
{
    //    NSString* content;
    NSInteger index = [self screenXtoX:touchBeginPoint.x]/self.stepx;
    index++;
    if (index < 0) {
        return 0;
    }
    return index;
}
- (void) drawlineCrossTouchPoint
{
    
    if (self.fingerDown == NO) {
        return;
    }
    CGPoint p1,p2,p3,p4;
    //    NSInteger index = [self screenTouchPointIndex];
    //    CGFloat x =
    
    
    p1.x = [self screenXtoX: 0];
    p1.y = [self screenYtoY: touchBeginPoint.y];
    p2.x = [self screenXtoX: self.frame.size.width];
    p2.y = [self screenYtoY: touchBeginPoint.y];
    
    p3.y = [self screenYtoY: 0];
    p3.x = [self screenXtoX: touchBeginPoint.x];
    p4.y = [self screenYtoY: self.frame.size.height];
    p4.x = [self screenXtoX: touchBeginPoint.x];
    
    self.touchY = [self screenYtoY:touchBeginPoint.y]/self.stepy;
    [self drawSpecialLineFrom:p1 to:p2];
    //    [self drawLineFrom:p3 to:p4];
    
    CGFloat distance;
    
    
    if (touchX > touchBeginPoint.x) {
        distance = touchX - touchBeginPoint.x;
    }
    else
        distance = touchBeginPoint.x - touchX;
    
    if (distance > self.frame.size.width*0.618) {
        touchX = touchBeginPoint.x;
    }
    
    if (touchX < self.frame.size.width/2) { // show right
        [self drawFloatTouchRect];
    }
    else
    {
        [self drawFloatTouchRect2]; //show left
    }
//    [self drawLineFrom:p1 to:p2];
//    //    [self drawLineFrom:p3 to:p4];
//    [self drawFloatTouchRect];
//    [self drawFloatTouchRect2];
}
- (void)drawFloatTouchRect2
{
    if (self.fingerDown == NO) {
        return;
    }
    
    CGFloat position = self.frame.size.width;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(3*self.stepx);
    if (w2 < 20) {
        w2 = 20;
    }
    
    if (w2 > 50) {
        w2 = 50;
    }
    w = w2*2+1;
    x = position - w2;
    CGFloat y1 = self.touchY*self.stepy;
    y1 = y1+8;
    //    CGFloat y2 = y1 -12;
    
    h = 18;
    
    if(h ==0)
        h = 1;
    if (y1 < h) {
        y1 = h;
    }
    
    x = 40;
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y1 = [self transY:y1];
    
    if(y1 < self.descriptAreaHeight+self.gapHeight)
        y1 = self.descriptAreaHeight+self.gapHeight;
//    CGContextFillRect(myContext, CGRectMake(x,y1, w,h));
    
    fillLineColor;
    
    
    
//    CGContextFillRect(myContext, CGRectMake(x+0.5,y1+0.5, w-1,h-1));
    CGContextStrokePath(myContext);
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    NSString *content = [NSString stringWithFormat:@"%f",self.touchY+self.miny];
    content = [self transf2:content];
    CGSize size = [content  sizeWithAttributes:dic];
    
    x = x + (w - size.width)/2.0;
    y = y1 + (h - size.height)/2.0;
    
    
    w = size.width;
    h = size.height;
    
    
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    
}
- (void)drawFloatTouchRect
{
    if (self.fingerDown == NO) {
        return;
    }
    
    CGFloat position = self.frame.size.width;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(3*self.stepx);
    
    if (w2 < 20) {
        w2 = 20;
    }
    
    if (w2 > 50) {
        w2 = 50;
    }
    
    w = w2*2+1;
    x = position - w2;
    CGFloat y1 = self.touchY*self.stepy;
    y1 = y1+8;
    //    CGFloat y2 = y1 -12;
    
    h = 18;
    
    if(h ==0)
        h = 1;
    if (y1 < h) {
        y1 = h;
    }
    
    x = self.frame.size.width - w -40;
   CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y1 = [self transY:y1];
    
    if(y1 < self.descriptAreaHeight)
        y1 = self.descriptAreaHeight;
//    CGContextFillRect(myContext, CGRectMake(x,y1, w,h));
    
    fillLineColor;
    
    
    
//    CGContextFillRect(myContext, CGRectMake(x+0.5,y1+0.5, w-1,h-1));
    CGContextStrokePath(myContext);
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    NSString *content = [NSString stringWithFormat:@"%f",self.touchY+self.miny];
    content = [self transf2:content];
    CGSize size = [content  sizeWithAttributes:dic];
    
    x = x + (w - size.width)/2.0;
    y = y1 + (h - size.height)/2.0;
    
    
    w = size.width;
    h = size.height;
    
    
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    
}
- (void) drawlineFor:(double)NewPirce
{
    CGPoint p1,p2;
    //    NSInteger index = [self screenTouchPointIndex];
    //    CGFloat x =
    
    
    p1.x = self.west;
    p1.y = NewPirce-self.miny;
    p2.x = self.east;
    p2.y = NewPirce-self.miny;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    
    
    
    CGContextBeginPath (myContext);
    
    fillLineColor;
    CGContextFillRect(myContext, CGRectMake(0,[self transY:(NewPirce-self.miny)*self.stepy], self.frame.size.width,0.5));
    
    CGContextStrokePath(myContext);
    
    
}
- (void) drawlineForNewPirce
{
    CGPoint p1,p2;
    //    NSInteger index = [self screenTouchPointIndex];
    //    CGFloat x =
    
    
    p1.x = self.west;
    p1.y = self.currentValueY-self.miny;
    p2.x = self.east;
    p2.y = self.currentValueY-self.miny;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    
    
    
    CGContextBeginPath (myContext);
    
    if (self.up) {
        fillUpColor;
    }
    else{
        fillDownColor;
    }
    CGContextFillRect(myContext, CGRectMake(0,[self transY:(self.currentValueY-self.miny)*self.stepy], self.frame.size.width,0.5));
    
    CGContextStrokePath(myContext);
    
    
}
- (void) drawlineForOldClosePirce
{
    CGPoint p1,p2;
    //    NSInteger index = [self screenTouchPointIndex];
    //    CGFloat x =
    
    
    p1.x = self.west;
    p1.y = self.currentValueY-self.miny;
    p2.x = self.east;
    p2.y = self.currentValueY-self.miny;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    
    
    
    CGContextBeginPath (myContext);
    
    fillWhiteColor;
    
    CGContextFillRect(myContext, CGRectMake(0,[self transY:(self.yesterdayPrice-self.miny)*self.stepy], self.frame.size.width,0.5));
    
    CGContextStrokePath(myContext);
    
    
}
- (void) timeUpdate
{
    _contentOffsetValue = _contentOffsetValue - v*(RefTime);
    static CGFloat vp = 1.3;
    
    if (v > 0) {
        v = v*0.95;
        if (v <= 10) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
    }
    else
    {
        v = v*0.95;
        if (v >= -10) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
    //    NSLog(@"timeupdate->v:%f",v);
    vp = vp*vp;
    if (_contentOffsetValue < self.west*_stepx) {
        _contentOffsetValue = self.west*_stepx;
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    else if (_contentOffsetValue > (self.east*_stepx - self.frame.size.width)) {
        
        CGFloat position = self.east*_stepx;
        
        if (position > self.frame.size.width) {
            _contentOffsetValue = (self.east*_stepx - self.frame.size.width);
        }
        
        
        [self.timer invalidate];
        self.timer = nil;
        [self callBackForDataUpdate];
    }
    
    //    if ([NSDate timeIntervalSinceReferenceDate] - endTimeinterval > 1) {
    //        [self.timer invalidate];
    //        self.timer = nil;
    //    }
    
    
    [self setNeedsDisplay:YES];
}

- (void)callBackForDataUpdate
{
    NSInteger index = [self screenTouchPointIndex];
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        if (index >= [self.stockArray count]) {
            index = [self.stockArray count]-1;
        }
        NSArray* a= self.stockArray[index];
        
        if ([self.delegate respondsToSelector:@selector(selectedIndexData:)]) {
            [self.delegate selectedIndexData:a];
        }
    }
}
-(void)mouseUp:(NSEvent *)event
{
    //    NSLog(@"%s",__func__);
    NSPoint p = event.locationInWindow;
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
    self.fingerDown = NO;
    if (moved == NO) {
        indexValue = touchEndPoint.x;
        [self setNeedsDisplay:YES];
        status = SVGraphViewInterativeModeToggle;
        
        
    }
    else
    {
        status = SVGraphViewInterativeModeScroll;
        endTimeinterval = [NSDate timeIntervalSinceReferenceDate];
        
        self.timer= [NSTimer timerWithTimeInterval:RefTime target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    [self callBackForDataUpdate];
}
-(void)mouseExited:(NSEvent *)event
{
    NSPoint p = event.locationInWindow;
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
    self.fingerDown = NO;
    if (moved == NO) {
        indexValue = touchEndPoint.x;
        [self setNeedsDisplay:YES];
        status = SVGraphViewInterativeModeToggle;
    }
    else
    {
        status = SVGraphViewInterativeModeScroll;
        endTimeinterval = [NSDate timeIntervalSinceReferenceDate];
        
        self.timer= [NSTimer timerWithTimeInterval:RefTime target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}
//- (CGFloat)
- (void) drawXline
{
    //
    //    CGPoint westPointOfX;
    //    CGPoint easePointOfX;
    //
    //    westPointOfX.y = 0;
    //    westPointOfX.x = self.west;
    //
    //    easePointOfX.y = 0;
    //    easePointOfX.x = self.east;
    //
    //    [self drawLogicalLineFrom:westPointOfX to:easePointOfX];
    
    
    //    for (int i = 0; i<east; i++) {
    //        CGPoint p;
    //        p.y = 0;
    //        p.x = i;
    //        [self drawLogcalPoint:p];
    //    }
    //    for (int i = 0; i>west; i--) {
    //        CGPoint p;
    //        p.y = 0;
    //        p.x = i;
    //        [self drawLogcalPoint:p];
    //    }
    
    
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    fillRectBorderColor;
    CGContextBeginPath (myContext);
    
    int start = [self screenXtoX:0-self.stepx]/self.stepx;
    int yushu = start%10;
    if (yushu != 0) {
        start = start - yushu;
    }
    NSInteger delta;
    if (self.style == SVGraphViewKline) {
        delta = 10;
    } else {
        delta = 60;
    }
    for (int i = start;i < [self screenXtoX:self.frame.size.width]; i+=delta  ) {
        
        
        CGContextFillRect(myContext, CGRectMake([self transX:i*self.stepx],self.descriptAreaHeight, 0.5,self.frame.size.height - self.descriptAreaHeight));
        
        
    }
    CGContextStrokePath(myContext);
}

- (void) drawYline  //其实是画横线
{
    
    //    CGPoint northPointOfY;
    //    CGPoint southPointOfY;
    //
    //    northPointOfY.y = self.north;
    //    northPointOfY.x = 0;
    //
    //    southPointOfY.y = self.south;
    //    southPointOfY.x = 0;
    //
    //    [self drawLogicalLineFrom:northPointOfY to:southPointOfY];
    
    
    double rowheight;
    rowheight = self.north/6.0;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    fillRectBorderColor;
    CGContextBeginPath (myContext);
    for (int i = 0; i <= 6; i++) {
        
        CGFloat floatY;
        NSString* strY;
        floatY = rowheight*self.stepy*i;
        
        strY = [NSString stringWithFormat:@"%f",floatY/self.stepy+self.miny];
        
        strY = [self transf:strY];
        CGContextFillRect(myContext, CGRectMake(0,[self transY:floatY], self.frame.size.width,0.5));
        
        
        if (self.style == SVGraphViewKline) {
            CGFloat x,y,w,h,fontsize;
            NSDictionary* dic;
            CGSize size;
            x = self.frame.size.width;
            y = [self transY:floatY];
            fontsize = 7;
            
            dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor colorWithRed:163.0/255.0 green:160.0/255.0 blue:168.0/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
            size = [strY sizeWithAttributes:dic];
            w = size.width;
            h = size.height;
            
            x = x - w;
            y = y + 1;
            
            [strY drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
            fillRectBorderColor;
        }
        
    }
    CGContextStrokePath(myContext);
    //
    //    for (int i = 0; i<north; i++) {
    //        CGPoint p;
    //        p.y = i;
    //        p.x = 0;
    //        [self drawLogcalPoint:p];
    //    }
    //    for (int i = 0; i>south; i--) {
    //        CGPoint p;
    //        p.y = i;
    //        p.x = 0;
    //        [self drawLogcalPoint:p];
    //    }
    
}
- (NSBezierPath *)createArcPath
{
    
    NSBezierPath* clipPath = [NSBezierPath bezierPath];
    [clipPath appendBezierPathWithRect:NSMakeRect(0.0, 0.0, 100.0, 100.0)];
    [clipPath appendBezierPathWithOvalInRect:NSMakeRect(50.0, 50.0, 100.0,  100.0)];
    [clipPath addClip];
//    [clipPath fill];
    //    [aPath addArcWithCenter:CGPointMake(150, 150) radius:4 startAngle:0 endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    
    return clipPath;
}

- (void)drawPath
{
    NSBezierPath *ap = [self createArcPath];
    
    [NSGraphicsContext saveGraphicsState];
    
    [[NSColor redColor] set];
    
   
    
    ap.lineWidth = 5;
    
    [ap fill];
    [ap stroke];
    [NSGraphicsContext restoreGraphicsState];
}
#pragma mark -
@end


@interface SVAnalysisGraphView()

{
    CGFloat leftx;
}
@end

@implementation SVAnalysisGraphView
//-(NSMutableArray*)stockArray
//{
//    if (_stockArray == nil) {
//        _stockArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    return _stockArray;
//}

-(void)dataCoculateStep1
{
    NSArray* stockData = self.stockArray;
    CGFloat highPrice = 0;
    CGFloat highVolume = 0;
    CGFloat lowPrice = CGFLOAT_MAX;
    
    
    if (self.vOffset > 0 && self.yesterdayPrice > 0) {
        lowPrice = self.yesterdayPrice -self.vOffset;
        highPrice = self.yesterdayPrice+self.vOffset;
    }
    else {
    
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary) {
        NSInteger index = 0;
        for (id b in self.stockArray) {
            
            if ([b isKindOfClass:[NSDictionary class]]) {
                
            }
            else
            {
                self.dataSourceFormat = SVGraphViewDataSourceFormatUnknown;
                break;
            }
            
            NSDictionary* a = b;
            if (self.style == SVGraphViewKline) {
                
                
                if ([a[@"high"] floatValue] > highPrice) {
                    highPrice = [a[@"high"] floatValue];
                }
                if ([a[@"low"] floatValue] < lowPrice) {
                    lowPrice = [a[@"low"] floatValue];
                }
                
                if ([a[@"close"] floatValue] > highVolume) {
                    highVolume = [a[@"close"] floatValue];
                }
                
                if (index == 0) {
                    self.lastTime = a[@"time"];
                }
                
                index ++;
            }
            else
            {
                
                
                if ([a[@"close"] floatValue] < lowPrice) {
                    lowPrice = [a[@"close"] floatValue];
                }
                if ([a[@"close"] floatValue] > highPrice) {
                    highPrice = [a[@"close"] floatValue];
                }
                if ([a[@"close"] floatValue] > highVolume) {
                    highVolume = [a[@"close"] floatValue];
                }
            }
            
            
            
            
        }
    }
    
    
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        for (id b in stockData) {
            if ([b isKindOfClass:[NSArray class]]) {
                
            }
            else
            {
                self.dataSourceFormat = SVGraphViewDataSourceFormatUnknown;
                break;
            }
            NSArray* a = b;
            if (self.style == SVGraphViewKline) {
                for (int i = 1;i<4;i++ ) {
                    if ([a[i] floatValue] > highPrice) {
                        highPrice = [a[i] floatValue];
                    }
                    if ([a[i] floatValue] < lowPrice) {
                        lowPrice = [a[i] floatValue];
                    }
                }
                //                if ([a[5] floatValue] > highVolume) {
                //                    highVolume = [a[5] floatValue];
                //                }
            }
            else
            {
                
                if ([a[1] floatValue] < lowPrice) {
                    lowPrice = [a[1] floatValue];
                }
                if ([a[1] floatValue] > highPrice) {
                    highPrice = [a[1] floatValue];
                }
                if ([a[1] floatValue] > highVolume) {
                    highVolume = [a[1] floatValue];
                }
            }
            
        }
    }
    
    }
    
    //    _stockChartView.stockArray = stockData;
    self.maxy = highPrice;
    self.miny = lowPrice;
    self.extentCoorinate.maxy = highVolume;
    self.extentCoorinate.miny = 0;
}
-(void)dataCoculate
{
    [self dataCoculateStep1];
    [self setContentOffset];
    [self setNeedsDisplay:YES];
    
}
-(void)dataCoculateWithPosition:(NSInteger)p
{
    [self dataCoculateStep1];
    CGFloat position = p*self.stepx;
    if(position > self.frame.size.width)
        self.contentOffsetValue = position - self.frame.size.width;
    else
        self.contentOffsetValue = 0;
    [self setNeedsDisplay:YES];
    
}
//ehlo_8hu

-(void)dataReCoculate
{
    
    NSArray* stockData = self.stockArray;
    CGFloat highPrice = 0;
    CGFloat highVolume = 0;
    CGFloat lowPrice = CGFLOAT_MAX;
    
    self.startIndex = self.contentOffsetValue/self.stepx;
    self.offsetIndex = self.frame.size.width/self.stepx +1;
    NSInteger c = [self.stockArray count];
    
    if (self.startIndex > c) {
        self.startIndex = c-1;
    }
    if (self.offsetIndex >= (c-self.startIndex)) {
        self.offsetIndex = c - self.startIndex;
    }
    if (self.autoAdjust == NO) {
        
        self.startIndex = 0;
        self.offsetIndex = c;
    }
    if (1) {
        NSLog(@"self.startIndex:%ld,self.offsetIndex%ld",(long)self.startIndex,(long)self.offsetIndex);
        for (NSInteger i = self.startIndex; i< self.startIndex+self.offsetIndex ;i++) {
            if (i >= c) {
                return;
            }
            if (i<0) {
                return;
            }
            id b = stockData[i];
            
            
            
            if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary) {
                if ([b isKindOfClass:[NSDictionary class]]) {
                    
                }
                else
                {
                    self.dataSourceFormat = SVGraphViewDataSourceFormatUnknown;
                    break;
                }
                
                NSDictionary* a = b;
                if (self.style == SVGraphViewKline) {
                    
                    
                    if ([a[@"high"] floatValue] > highPrice) {
                        highPrice = [a[@"high"] floatValue];
                    }
                    if ([a[@"low"] floatValue] < lowPrice) {
                        lowPrice = [a[@"low"] floatValue];
                    }
                    
                    if ([a[@"close"] floatValue] > highVolume) {
                        highVolume = [a[@"close"] floatValue];
                    }
                }
            }
            else if(self.dataSourceFormat == SVGraphViewDataSourceFormatArray)
            {
                NSArray* a = b;
                /*
                 start = [dataDic[1] floatValue];
                 end = [dataDic[2] floatValue];
                 
                 fmax = [dataDic[3] floatValue];
                 fmin = [dataDic[4] floatValue];

                 */
                
                
                if (self.style == SVGraphViewKline) {
                    
                    
                    if ([a[3] floatValue] > highPrice) {
                        highPrice = [a[3] floatValue];
                    }
                    if ([a[4] floatValue] < lowPrice) {
                        lowPrice = [a[4] floatValue];
                    }
                    
                    if ([a[2] floatValue] > highVolume) {
                        highVolume = [a[2] floatValue];
                    }
                    
                }
                else if (self.style == SVGraphViewReal)
                {
                    
                    static CGFloat oldVolume = 0;
                    
                    NSString* o =[NSString stringWithFormat:@"%@",a];
                    
                    NSArray* ta = [o componentsSeparatedByString:@" "];
                    
                    if ([ta[1] floatValue] > highPrice) {
                        highPrice = [ta[1] floatValue];
                    }
                    if ([ta[1] floatValue] < lowPrice) {
                        lowPrice = [ta[1] floatValue];
                    }
                    CGFloat currentVlume;
                    currentVlume = [ta[2] floatValue] - oldVolume;
                    
                    if (currentVlume > highVolume) {
                        highVolume = currentVlume;
                    }
                    oldVolume = [ta[2] floatValue];
                    self.extentCoorinate.maxy = highVolume;
                    self.extentCoorinate.miny = 0;
                }
            }
            
            
            
            
            
        }
        if (self.vOffset > 0 && self.yesterdayPrice > 0) {
            lowPrice = self.yesterdayPrice -self.vOffset;
            highPrice = self.yesterdayPrice+self.vOffset;
        }
        else
        {
            
        }
       
        
        if(highPrice == lowPrice)
        {
            highPrice = 100;
            lowPrice = 0;
        }
        if(highPrice >0)
            self.maxy = highPrice;
        
        self.miny = lowPrice;

    }
    
}

- (void) drawXline  //画竖线
{
    
    
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    fillRectBorderColor;
    CGContextBeginPath (myContext);
    
    int start = [self screenXtoX:0-self.stepx]/self.stepx;
    int yushu = start%10;
    if (yushu != 0) {
        start = start - yushu;
    }
    CGFloat h;
    //    h = self.frame.size.width;
    h = self.coordinateY;
    h = self.frame.size.height - self.descriptAreaHeight - self.coordinateY;
    //    if (self.style == IHGraphViewKline) {
    //        h = h - spaceHeight;
    //    }
    NSString* day = nil;
    NSInteger delta;
    if (self.style == SVGraphViewKline) {
        delta = 10;
    } else {
        delta = 60;
    }
    for (int i = start;i < [self screenXtoX:self.frame.size.width]; i+=delta  ) {
        
        CGFloat x,y,w;
        x = [self transX:i*self.stepx];
        y = self.descriptAreaHeight;
        w = 0.5;
        if (((self.frame.size.width - x)> 40 && x >= 0 )|| self.style != SVGraphViewKline) {
            CGContextFillRect(myContext, CGRectMake(x,self.coordinateY, w,h));
            
            if ((self.frame.size.width - x)> 64 && x >= 0) {
                if (i > 0 && i < [self.stockArray count]) {
                    NSDictionary* dataDic = self.stockArray[i];
                    if ([dataDic isKindOfClass:[NSDictionary class]]) {
                        CGFloat fontsize = 7;
                        NSString* Xstr = dataDic[@"time"];
                        NSArray *Xarr = [Xstr componentsSeparatedByString:@" "];
                        if (day == nil) {
                            day = Xarr[0];
                            Xstr = day;
                        }
                        else
                        {
                            NSString* daynew = Xarr[0];
                            if ([daynew isEqualToString:day]) {
                                if ([Xarr count]> 1) {
                                    Xstr = Xarr[1];
                                }
                                else
                                {
                                    Xstr = Xarr[0];
                                }
                            }
                            else
                            {
                                Xstr = Xarr[0];
                            }
                        }
                        
                        NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[CIColor colorWithRed:163.0/255.0 green:160.0/255.0 blue:168.0/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
                        CGSize size = [Xstr sizeWithAttributes:dic];
                        w = size.width;
                        
                        y = y +h;
                        
                        [Xstr drawInRect:CGRectMake(x, y, w, size.height) withAttributes:dic];
                        
                        
                        fillRectBorderColor;
                    }
                    
                }
                
            }
            
            
        }
        
    }
    CGContextStrokePath(myContext);
}


//- (void)setContentOffset
//{
//    CGFloat position = [self mostRightPosition];
//    self.contentOffsetValue = position;
//    NSLog(@"%s,%f",__func__,self.contentOffsetValue);
//}
//- (CGFloat)mostRightPosition
//{
//    [self coculateAllValue];
//    return self.east*self.stepx;
//}

- (void)coculateAllValue
{
    leftx = 100;
    [self dataReCoculate];
    [super coculateAllValue];
    int c = 1;
    if ([self.stockArray count] > 0) {
        self.stepx = self.contentWidth/([self.stockArray count]+2);
        self.east = [self.stockArray count]+2;
        c = [self.stockArray count];
    }
    
    if (self.stepx >= 50*self.fontScale) {
        self.stepx = 8;
        
    }
    else if(self.stepx < 8*self.fontScale)
    {
        self.stepx = 8*self.fontScale;
    }
    if (self.style == SVGraphViewReal) {
        
        self.stepx = self.frame.size.width/242; //320是本日分钟数，因为变量，根据交易品种不同，先只考虑A股
        
    }
    else if (self.style == SVGraphViewZline)
    {
        self.stepx = self.frame.size.width/c;
    }
    //    NSLog(@"self.stepx:%f",self.stepx);
    self.extentCoorinate.stepx = self.stepx; //两个坐标系竖对其
}
- (void)drawRectByExtendCoordinaryFromSelected:(CGFloat)y1 to:(CGFloat)y2 at:(NSInteger)position
{
    position = position*self.extentCoorinate.stepx;
    
    CGFloat x,y,w,h;
    //    self.extentCoorinate.stepy = 0.001;
    self.extentCoorinate.stepy = self.coordinateY/self.extentCoorinate.maxy;
    CGFloat w2;
    w2 = ceil(0.13*self.extentCoorinate.stepx);
    if (self.style == SVGraphViewKline) {
        w = w2*2;
    } else {
        w = 1;
    }
    
    
    
    x = position - w2+1;
    
    if (y1 > y2) {
        y = y1*self.extentCoorinate.stepy;
        h = (y1 - y2)*self.extentCoorinate.stepy;
        //        self.up = NO;
    }
    else
    {
        //        self.up = YES;
        y = y2*self.extentCoorinate.stepy;
        h = (y2 - y1)*self.extentCoorinate.stepy;
    }
    
    if(h ==0)
        h = 1;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    fillSelectedColor;
    
    CGContextBeginPath (myContext);
    CGContextFillRect(myContext, CGRectMake([self transExCooX:x],0, w,h));
    CGContextStrokePath(myContext);
}
- (void)drawRectByExtendCoordinaryFrom:(CGFloat)y1 to:(CGFloat)y2 at:(NSInteger)position
{
    position = position*self.extentCoorinate.stepx;
    self.extentCoorinate.stepy = self.coordinateY/self.extentCoorinate.maxy;
    CGFloat x,y,w,h;
    //    self.extentCoorinate.stepy = 0.001;
    CGFloat w2;
    w2 = ceil(0.13*self.extentCoorinate.stepx);
    if (self.style == SVGraphViewKline) {
        w = w2*2;
    } else {
        w = 1;
    }

    
    
    x = position - w2;
    
    if (y1 > y2) {
        y = y1*self.extentCoorinate.stepy;
        h = (y1 - y2)*self.extentCoorinate.stepy;
        //        self.up = NO;
    }
    else
    {
        //        self.up = YES;
        y = y2*self.extentCoorinate.stepy;
        h = (y2 - y1)*self.extentCoorinate.stepy;
    }
    
    if(h ==0)
        h = 1;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    if (self.up) {
        fillUpColor;
    }
    else{
        fillDownColor;
    }
    
    CGContextBeginPath (myContext);
    CGContextFillRect(myContext, CGRectMake([self transExCooX:x],0, w,h));
    CGContextStrokePath(myContext);
}
- (void)drawRectFrom2:(CGFloat)y1 to:(CGFloat)y2 at:(NSInteger)position
{
    
    //    if (self.fingerDown == NO) {
    //        return;
    //    }
    position = position*self.stepx;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(0.13*self.stepx);
    w = w2*2+1;
    x = position - w2;
    
    if (y1 > y2) {
        y = y1*self.stepy;
        h = (y1 - y2)*self.stepy;
        self.up = NO;
    }
    else
    {
        self.up = YES;
        y = y2*self.stepy;
        h = (y2 - y1)*self.stepy;
    }
    
    if(h ==0)
        h = 1;
    h = self.coordinateY;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    if (self.up) {
        fillUpColor;
    }
    else{
        
        fillDownColor;
    }
    
    x = [self transX:x]+w*0.5-0.5;
    CGContextBeginPath (myContext);
    CGFloat delta = 0;
    if (self.style == SVGraphViewKline) {
        delta = spaceHeight;
    }
    CGFloat dataGraphHight = self.frame.size.height -(self.descriptAreaHeight+self.gapHeight+self.coordinateY);
    y = spaceHeight;
    h = dataGraphHight;
    CGContextFillRect(myContext, CGRectMake(x,y, 1,h));
    //    CGContextFillRect(myContext, CGRectMake(0,[self transY:y2*self.stepy], self.frame.size.width,1));
    CGContextStrokePath(myContext);
    
}
- (void)drawSelectedRectFrom:(CGFloat)y1 to:(CGFloat)y2 at:(NSInteger)position
{
    position = position*self.stepx;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(0.13*self.stepx);
    w = w2*2+1;
    x = position - w2;
    
    if (y1 > y2) {
        y = y1*self.stepy;
        h = (y1 - y2)*self.stepy;
        self.up = NO;
    }
    else
    {
        self.up = YES;
        y = y2*self.stepy;
        h = (y2 - y1)*self.stepy;
    }
    
    if(h ==0)
        h = 1;
    
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    fillSelectedColor;
    
    
    CGContextBeginPath (myContext);
    CGContextFillRect(myContext, CGRectMake([self transX:x],[self transY:y]-h, w,h));
    CGContextStrokePath(myContext);
}
- (void)drawRectFrom:(CGFloat)y1 to:(CGFloat)y2 at:(NSInteger)position
{
    position = position*self.stepx;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(0.13*self.stepx);
    w = w2*2+1;
    x = position - w2;
    
    if (y1 > y2) {
        y = y1*self.stepy;
        h = (y1 - y2)*self.stepy;
        self.up = NO;
    }
    else
    {
        self.up = YES;
        y = y2*self.stepy;
        h = (y2 - y1)*self.stepy;
    }
    
    if(h ==0)
        h = 1;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    if (self.up) {
        fillUpColor;
    }
    else{
        
        fillDownColor;
    }
    
    CGFloat tx,ty;
    tx = [self transX:x];
    ty = [self transY:y];
    
    CGContextBeginPath (myContext);
    CGContextFillRect(myContext, CGRectMake(tx,ty-h, w,h));
    CGContextStrokePath(myContext);
}
- (void)drawFloatRectWithPrice:(double)newprice
{
    CGFloat position = leftx;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    NSString *content = [NSString stringWithFormat:@"%.2f",newprice];//格式化正确小数点位
        
    if(self.buysell)
        content = [NSString stringWithFormat:@"[%@]%.2f",self.buysell,newprice];
    
    
    CGSize size = [content  sizeWithAttributes:dic];
    
    w2 = ceil(3*self.stepx);
    w = size.width+1;
    x = position - w2;
    CGFloat y1 = (newprice - self.miny)*self.stepy;
    y1 = y1+5;
    //    CGFloat y2 = y1 -12;
    
    h = size.height;
    
    if(h ==0)
        h = 1;
    if (y1 < h) {
        y1 = h;
    }
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y1 = [self transY:y1];
    
    if(y1 < self.descriptAreaHeight+self.gapHeight)
        y1 = self.descriptAreaHeight+self.gapHeight;
//    CGContextFillRect(myContext, CGRectMake(x,y1, w,h));
    
    if (self.up) {
        fillUpColor2;
    }
    else{
        fillDownColor2;
    }
    
    
    
//    CGContextFillRect(myContext, CGRectMake(x+0.5,y1+0.5, w-1,h-1));
    CGContextStrokePath(myContext);
    
    
    
    x = x + (w - size.width)/2.0;
    y = y1 + (h - size.height)/2.0;
    
    
    w = size.width;
    h = size.height;
    
    
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    
    leftx = leftx+2*w+10;
    
}
- (void)drawFloatRect
{
    CGFloat position = self.frame.size.width/2.0;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(3*self.stepx);
    w = w2*2+1;
    x = position - w2;
    CGFloat y1 = (self.currentValueY - self.miny)*self.stepy;
    y1 = y1+5;
    //    CGFloat y2 = y1 -12;
    
    h = 18;
    
    if(h ==0)
        h = 1;
    if (y1 < h) {
        y1 = h;
    }
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y1 = [self transY:y1];
    
    if(y1 < self.descriptAreaHeight+self.gapHeight)
        y1 = self.descriptAreaHeight+self.gapHeight;
//    CGContextFillRect(myContext, CGRectMake(x,y1, w,h));
    
    if (self.up) {
        fillUpColor;
    }
    else{
        fillDownColor;
    }
    
    
    
//    CGContextFillRect(myContext, CGRectMake(x+0.5,y1+0.5, w-1,h-1));
    CGContextStrokePath(myContext);
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    NSString *content = self.currentValue;//格式化正确小数点位
    
    CGSize size = [content  sizeWithAttributes:dic];
    
    x = x + (w - size.width)/2.0;
    y = y1 + (h - size.height)/2.0;
    
    
    w = size.width;
    h = size.height;
    
    
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    
}
- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    [self drawXline];
    
    
    [self drawYline];
    [self drawStock];

    if ([self beTouched]) {
        [self drawlineCrossTouchPoint];
        
    }
    
    
    [self drawDescript];
    
    if (self.style == SVGraphViewKline) {
        if (self.currentValue != nil) {
            [self drawlineForNewPirce];
            [self drawFloatRect];
            
            if (self.buy1Price > 0) {
                [self drawlineFor:self.buy1Price];
                [self drawFloatRectWithPrice:self.buy1Price];
            }
            if (self.buy2Price > 0) {
                [self drawlineFor:self.buy2Price];
                [self drawFloatRectWithPrice:self.buy2Price];
            }
            if (self.buy3Price > 0) {
                [self drawlineFor:self.buy3Price];
                [self drawFloatRectWithPrice:self.buy3Price];
            }
        }
        [self drawMa5LinePrice];
        [self drawMa10LinePrice];
        [self drawMa20LinePrice];
        [self drawMa60LinePrice];
        [self drawMa120LinePrice];
    }
    else if(self.style == SVGraphViewReal)
    {
        [self drawlineForOldClosePirce];
        [self drawMa5LinePrice];
    }
}

- (CGPoint)pointOfMA:(NSNumber*)data at:(NSInteger)position
{
    CGPoint p;
    
    CGFloat start;
    start = [data floatValue];
    
    p.x = position;
    p.y = start-self.miny;
    
    return p;
    
}
- (void)drawMa60LinePrice
{
    if (self.style != SVGraphViewKline) {
        return;
    }
    if (self.stockArray == nil || [self.stockArray count] < self.macount60+1) {
        return;
    }
    NSNumber *olda;
    for (int i = self.macount60;i < [self.maArray60 count];i++) {
        
        NSNumber *a = [self.maArray60 objectAtIndex:i];
        
        
        
        CGPoint p1,p2;
        if (i == self.macount60) {
            p1  = [self pointOfMA:a at:i];
            p2 = p1;
            olda =a;
            
        }
        else
        {
            p1  = [self pointOfMA:olda at:i-1];
            p2  = [self pointOfMA:a at:i];
            olda = a;
            
        }
        [[NSColor yellowColor] set];
        [self drawMALineFrom:p1 to:p2 withColor:[NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:186.0/255.0 alpha:1.0]];
        
        
        
    }
    
}
- (void)drawMa120LinePrice
{
    if (self.style != SVGraphViewKline) {
        return;
    }
    if (self.stockArray == nil || [self.stockArray count] < self.macount120+1) {
        return;
    }
    NSNumber *olda;
    for (int i = self.macount120;i < [self.maArray120 count];i++) {
        
        NSNumber *a = [self.maArray120 objectAtIndex:i];
        
        
        
        CGPoint p1,p2;
        if (i == self.macount120) {
            p1  = [self pointOfMA:a at:i];
            p2 = p1;
            olda =a;
            
        }
        else
        {
            p1  = [self pointOfMA:olda at:i-1];
            p2  = [self pointOfMA:a at:i];
            olda = a;
            
        }
        [[NSColor yellowColor] set];
        [self drawMALineFrom:p1 to:p2 withColor:[NSColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:186.0/255.0 alpha:1.0]];
        
        
        
    }
    
}
- (void)drawMa20LinePrice
{
    if (self.style != SVGraphViewKline) {
        return;
    }
    if (self.stockArray == nil || [self.stockArray count] < self.macount20+1) {
        return;
    }
    NSNumber *olda;
    for (int i = self.macount20;i < [self.maArray20 count];i++) {
        
        NSNumber *a = [self.maArray20 objectAtIndex:i];
        
        
        
        CGPoint p1,p2;
        if (i == self.macount20) {
            p1  = [self pointOfMA:a at:i];
            p2 = p1;
            olda =a;
            
        }
        else
        {
            p1  = [self pointOfMA:olda at:i-1];
            p2  = [self pointOfMA:a at:i];
            olda = a;
            
        }
        [[NSColor yellowColor] set];
        [self drawMALineFrom:p1 to:p2 withColor:[NSColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1.0]];
        
        
        
    }
    
}
- (void)drawMa5LinePrice
{
    
//    if (self.style != SVGraphViewKline) {
//        return;
//    }
    if (self.stockArray == nil || [self.stockArray count] < self.macount5+1) {
        return;
    }
    NSNumber *olda;
    for (int i = self.macount5;i < [self.maArray5 count];i++) {
        
        NSNumber *a = [self.maArray5 objectAtIndex:i];
        
        
        
        CGPoint p1,p2;
        if (i == self.macount5) {
            p1  = [self pointOfMA:a at:i];
            p2 = p1;
            olda =a;
            
        }
        else
        {
            p1  = [self pointOfMA:olda at:i-1];
            p2  = [self pointOfMA:a at:i];
            olda = a;
            
        }
        [[NSColor yellowColor] set];
         [self drawMALineFrom:p1 to:p2 withColor:[NSColor colorWithRed:182.0/255.0 green:252.0/255.0 blue:36.0/255.0 alpha:1.0]];
        
        
        
    }
    
}
- (void)drawMa10LinePrice
{
    if (self.style != SVGraphViewKline) {
        
    }
    if (self.stockArray == nil || [self.stockArray count] < self.macount10+1) {
        return;
    }
    NSNumber *olda;
    for (int i = self.macount10;i < [self.maArray10 count];i++) {
        
        NSNumber *a = [self.maArray10 objectAtIndex:i];
        
        
        
            CGPoint p1,p2;
            if (i == self.macount10) {
                p1  = [self pointOfMA:a at:i];
                p2 = p1;
                olda =a;
                
            }
            else
            {
                p1  = [self pointOfMA:olda at:i-1];
                p2  = [self pointOfMA:a at:i];
                olda = a;
                
            }
            [[NSColor yellowColor] set];
           [self drawMALineFrom:p1 to:p2 withColor:[NSColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:236.0/255.0 alpha:1.0]];
        
        
        
    }

}
- (void)drawFloatRectOpenPrice //当前价格的方块
{
    CGFloat position = 40;//self.frame.size.width/2.0;
    
    CGFloat x,y,w,h;
    
    CGFloat w2;
    w2 = ceil(3*self.stepx);
    w = w2*2+1;
    x = position - w2;
    
    double doubleopenPrice;
    doubleopenPrice = [self.openPrice doubleValue];
    //    doubleopenPrice = 1.09908;
    if (doubleopenPrice == 0) {
        return;
    }
    
    if (doubleopenPrice > self.maxy) {
        doubleopenPrice = self.maxy;
    }
    
    if (doubleopenPrice < self.miny) {
        doubleopenPrice = self.miny;
    }
    
    CGFloat y1 = (doubleopenPrice - self.miny)*self.stepy;
    y1 = y1+5;
    //    CGFloat y2 = y1 -12;
    
    h = 18;
    
    if(h ==0)
        h = 1;
    if (y1 < h) {
        y1 = h;
    }
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    
    fillRectBorderColor;
    y1 = [self transY:y1];
    
    if(y1 < self.descriptAreaHeight+self.gapHeight)
        y1 = self.descriptAreaHeight+self.gapHeight;
    
    
    
    
    
    
    CGFloat fontsize = 9;
    NSDictionary* dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    NSString *content = @"开盘价";//格式化正确小数点位
    content = [NSString stringWithFormat:@"开仓价:%@",content];
    CGSize size = [content  sizeWithAttributes:dic];
    
    x = x + (w - size.width)/2.0;
    y = y1 + (h - size.height)/2.0;
    
    
    
    w = size.width+2;
    
    CGContextFillRect(myContext, CGRectMake(x,y1, w,h));
    
    if (self.up) {
        fillOpenPriceColor;
    }
    else{
        fillOpenPriceColor;
    }
    x = x -1;
    CGContextFillRect(myContext, CGRectMake(x+0.5,y1+0.5, w-1,h-1));
    CGContextStrokePath(myContext);
    w = size.width;
    h = size.height;
    x= x+1;
    [content drawInRect:CGRectMake(x,y, w, h) withAttributes:dic];
    
}
- (void) drawlineForOpenPirce
{
    CGPoint p1,p2;
    //    NSInteger index = [self screenTouchPointIndex];
    //    CGFloat x =
    double doubleopenPrice;
    doubleopenPrice = [self.openPrice doubleValue];
    //    doubleopenPrice = 1.09908;
    if (doubleopenPrice == 0) {
        return;
    }
    
    p1.x = self.west;
    if (doubleopenPrice < self.miny) {
        p1.y = 0;
    }
    else
        p1.y = doubleopenPrice-self.miny;
    p2.x = self.east;
    
    if (doubleopenPrice > self.maxy) {
        doubleopenPrice = self.maxy;
    }
    p2.y = doubleopenPrice-self.miny;
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    
    
    
    CGContextBeginPath (myContext);
    
    if (self.up) {
        fillOpenPriceColor;
    }
    else{
        fillOpenPriceColor;
    }
    CGContextFillRect(myContext, CGRectMake(0,[self transY:(doubleopenPrice-self.miny)*self.stepy], self.frame.size.width,1));
    
    CGContextStrokePath(myContext);
    
    
}
- (void)drawOpenPrice
{
    [self drawlineForOpenPirce];
    [self drawFloatRectOpenPrice];
}
#pragma mark- 内部计算之函数
- (void)drawStaticLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    from.x = [self StaticTransX:point1.x];
    from.y = [self transY:point1.y];
    
    to.x = [self StaticTransX:point2.x];
    to.y = [self transY:point2.y];
    
    
    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    CGContextSetStrokeColorWithColor(myContext, [NSColor yellowColor].CGColor);
    CGContextSetLineWidth(myContext, .5);
    if (self.up) {
        CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor);
    }
    else{
        CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor);
    }
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}
- (void)drawStaticLogicalLineFrom:(CGPoint)p1 to:(CGPoint)p2
{
    p1.x = p1.x*self.stepx;
    p1.y = p1.y*self.stepy;
    
    p2.x = p2.x*self.stepx;
    p2.y = p2.y*self.stepy;
    
    [self drawStaticLineFrom:p1 to:p2];
}

- (void) drawYFlaotline
{
    
    CGPoint northPointOfY;
    CGPoint southPointOfY;
    
    northPointOfY.y = self.north;
    northPointOfY.x = 100;
    
    southPointOfY.y = self.south;
    southPointOfY.x = 100;
    
    [self drawStaticLogicalLineFrom:northPointOfY to:southPointOfY];
    
    //
    //    for (int i = 0; i<north; i++) {
    //        CGPoint p;
    //        p.y = i;
    //        p.x = 0;
    //        [self drawLogcalPoint:p];
    //    }
    //    for (int i = 0; i>south; i--) {
    //        CGPoint p;
    //        p.y = i;
    //        p.x = 0;
    //        [self drawLogcalPoint:p];
    //    }
    
}


#pragma mark- 测试函数
- (void)drawFuntion
{
    for (CGFloat i = self.west;i < self.east;(i = i+0.1)) {
        CGPoint p;
        p.x =i;
        p.y = i*i;
        [self drawLogcalPoint:p];
    }
}
- (void)drawVolumeRectSelected:(NSArray*)dataArray at:(NSInteger)position
{
    
    CGFloat start,end;
    
    
    if (self.style == SVGraphViewReal)
    {
        NSString* o =[NSString stringWithFormat:@"%@",dataArray];
        static CGFloat oldv = 0;
        static CGFloat oldPrice;
        NSArray* ta = [o componentsSeparatedByString:@" "];
        start = [ta[2] floatValue] - oldv;
        oldv = [ta[2] floatValue];
        end = 0;
        CGFloat price = [ta[1] floatValue];
        if (price >oldPrice) {
            self.up = YES;
        }
        else
            self.up = NO;
        oldPrice = price;
    }
    else
    {
        start = [dataArray[5] floatValue];
        end = 0;
    }
    [self drawRectByExtendCoordinaryFromSelected:start to:end at:position]; // 在第二坐标上画成交量
    
    
}
- (void)drawVolumeRect:(NSArray*)dataArray at:(NSInteger)position
{

    CGFloat start,end;
    
    
    if (self.style == SVGraphViewReal)
    {
        NSString* o =[NSString stringWithFormat:@"%@",dataArray];
        static CGFloat oldv = 0;
        static CGFloat oldPrice;
        NSArray* ta = [o componentsSeparatedByString:@" "];
        start = [ta[2] floatValue] - oldv;
        oldv = [ta[2] floatValue];
            end = 0;
        CGFloat price = [ta[1] floatValue];
        if (price >oldPrice) {
            self.up = YES;
        }
        else
            self.up = NO;
        oldPrice = price;
    }
    else
    {
        start = [dataArray[5] floatValue];
        end = 0;
    }
    [self drawRectByExtendCoordinaryFrom:start to:end at:position]; // 在第二坐标上画成交量
    
    
}
- (void)setCurrentValue:(NSString *)currentValue
{
    _currentValue = currentValue;
    self.currentValueY = [_currentValue doubleValue];
}
- (CGPoint)pointOfData:(id)dataArray at:(NSInteger)position
{
    CGPoint p;
    
    CGFloat start;
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        
        if (self.style == SVGraphViewReal) {
            NSString* o =[NSString stringWithFormat:@"%@",dataArray];
            
            NSArray* ta = [o componentsSeparatedByString:@" "];
            start = [ta[1] floatValue];
            if (position+1 == [self.stockArray count]) {
                self.currentValue = ta[1];
            }
            
        }
        else
        {
            start = [dataArray[1] floatValue];
            if (position+1 == [self.stockArray count]) {
                self.currentValue = dataArray[1];
            }
        }
        
        
        
    }
    else if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary) {
        start = [dataArray[@"close"] floatValue];
        
        if (position+1 == [self.stockArray count]) {
            self.currentValue = dataArray[@"close"];
        }
    }
    
    start = start - self.miny;
    
    p.x = position;
    p.y = start;
    
    return p;
    
}
- (void)drawDataPoint:(NSArray*)dataArray at:(NSInteger)position
{
    CGFloat start,end,fmax,fmin;
    
    start = [dataArray[1] floatValue];
    end = [dataArray[1] floatValue];
    
    fmax = [dataArray[1] floatValue];
    fmin = [dataArray[1] floatValue];
    
    
    start = start - self.miny;
    end =  end - self.miny;
    fmax = fmax - self.miny;
    fmin = fmin - self.miny;
    
    
    [self drawRectFrom:start to:end at:position];
    
    CGPoint p1,p2;
    
    p1.x = position;
    p1.y = fmax;
    p2.x = position;
    p2.y = fmin;
    
    [self drawLogicalLineFrom:p1 to:p2];
    
    //
    
    [self drawVolumeRect:dataArray at:position]; // 成交量的方块，扩展坐标系
}
- (void)drawStockRecordSelected:(id)dataArray at:(NSInteger)position
{
    CGFloat start,end,fmax,fmin;
    
    NSArray*dataDic;
    dataDic = dataArray;
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        start = [dataDic[1] floatValue];
        end = [dataDic[2] floatValue];
        
        fmax = [dataDic[3] floatValue];
        fmin = [dataDic[4] floatValue];
    }
    //    else
    //    {
    //    start = [dataDic[@"open"] floatValue];
    //    end = [dataDic[@"close"] floatValue];
    //
    //    fmax = [dataDic[@"high"] floatValue];
    //    fmin = [dataDic[@"low"] floatValue];
    //
    //    }
    start = start - self.miny;
    end =  end - self.miny;
    fmax = fmax - self.miny;
    fmin = fmin - self.miny;
    
    
    [self drawSelectedRectFrom:start to:end at:position];
    
    CGPoint p1,p2;
    
    p1.x = position;
    p1.y = fmax;
    p2.x = position;
    p2.y = fmin;
    
    [self drawLogicalLineFromSelected:p1 to:p2];
    
    //
    
    [self drawVolumeRectSelected:dataArray at:position]; // 成交量的方块，扩展坐标系
    
    if (position+1 == [self.stockArray count]) {
        self.currentValue = dataArray[2];
    }
    
}
- (void)drawStockRecord:(id)dataArray at:(NSInteger)position
{
    CGFloat start,end,fmax,fmin;
    
    NSArray*dataDic;
    dataDic = dataArray;
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        start = [dataDic[1] floatValue];
        end = [dataDic[2] floatValue];
        
        fmax = [dataDic[3] floatValue];
        fmin = [dataDic[4] floatValue];
    }
//    else
//    {
//    start = [dataDic[@"open"] floatValue];
//    end = [dataDic[@"close"] floatValue];
//    
//    fmax = [dataDic[@"high"] floatValue];
//    fmin = [dataDic[@"low"] floatValue];
//    
//    }
    start = start - self.miny;
    end =  end - self.miny;
    fmax = fmax - self.miny;
    fmin = fmin - self.miny;
    
    
    [self drawRectFrom:start to:end at:position];
    
    CGPoint p1,p2;
    
    p1.x = position;
    p1.y = fmax;
    p2.x = position;
    p2.y = fmin;
    
    [self drawLogicalLineFrom:p1 to:p2];
    
    //
    
    [self drawVolumeRect:dataArray at:position]; // 成交量的方块，扩展坐标系
    
    if (position+1 == [self.stockArray count]) {
        self.currentValue = dataArray[2];
    }
    
}

- (void)drawDescRect:(CGRect)rect
{
    //    CGContextRef myContext =(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    //
    //    CGContextSetRGBFillColor(myContext, 1.0, 0.0, 0.0, 1.0);
    //
    //
    //    CGContextBeginPath (myContext);
    //    CGContextFillRect(myContext,rect);
    //    CGContextStrokePath(myContext);
    NSImage *image;
    if (self.up) {
        image = [NSImage imageNamed:@"upbg"];
    }
    else
    {
        image = [NSImage imageNamed:@"downbg"];
    }
    [image drawInRect:rect];
}

- (CGSize)drawText:(NSString*)text atPoint:(CGPoint)point andAttribute:(NSDictionary*)dic
{
    
    CGFloat x,y,w,h;
    CGSize size;
    
    
    x = point.x;
    y = point.y;
    
    size = [text sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    
    
    [text drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    
    return size;
}
- (void)drawDescriptText:(NSString*)dateTime andOpenPrice:(NSString*)openPrice touchPrice:(NSString*)touchPrice hightPrice:(NSString*)highPrice and:(NSString*)lowPrice and:(NSString*)closePrice
{
    
    
   
    CGFloat x,y,w,h;
    CGSize size;
    NSDictionary *dic;
    CGPoint p;
    
    CGFloat topY = self.frame.size.height - self.descriptAreaHeight;
    
    x = 10;
    y = topY +  4*self.fontScale;
    
    p.x = x;
    p.y = y;
    CGFloat fontsize = 11*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    size = [self drawText:dateTime atPoint:p andAttribute:dic];
    w = size.width;
    h = size.height;
    
    
    
    //    x = 105*self.widthRate;
    y = topY +19*self.fontScale;
    fontsize = 9*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [@"现:" sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    
    [@"现:" drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    x = x + w +5;
    y = y+h + 2;
    fontsize = 14*self.fontScale;//[NSColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:94.0/255.0 alpha:1.0]
    
    NSColor* fontColor;
    if (self.up) {
        fontColor = [NSColor whiteColor];
    }
    else
    {
        fontColor = [NSColor whiteColor];
    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [touchPrice sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    y = y - h;
    [touchPrice drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
#pragma mark 高
    x = 135*self.widthRate;
    y = topY + 4*self.fontScale;
    fontsize = 12*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:@"高" atPoint:p andAttribute:dic];
    
    
    x = x+size.width;
    //    y = y;
    p.x = x+1;
    p.y = y+1;
    //    if (self.up) {
    fontColor = [NSColor whiteColor];
    //    }
    //    else
    //    {
    //        fontColor = [NSColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:94.0/255.0 alpha:1.0];
    //    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    [self drawText:highPrice atPoint:p andAttribute:dic];
    
#pragma mark 低
    
    x = 135*self.widthRate;
    y = topY + self.descriptAreaHeight - 4*self.fontScale - fontsize;
    //    fontsize = 12;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:@"低" atPoint:p andAttribute:dic];
    
    
    x = x+size.width;
    //    y = y;
    p.x = x+1;
    p.y = y+1;
    //    if (self.up) {
    //        fontColor = [NSColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    //    }
    //    else
    //    {
    fontColor = [NSColor whiteColor];
    //    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    [self drawText:lowPrice atPoint:p andAttribute:dic];
    
#pragma mark 开
    x = 236*self.widthRate;
    y = topY + 4*self.fontScale;
    fontsize = 12*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:@"开" atPoint:p andAttribute:dic];
    
    
    x = x+size.width;
    //    y = y;
    p.x = x+1;
    p.y = y+1;
    if (closePrice.floatValue > openPrice.floatValue) {
        fontColor = [NSColor whiteColor];
    }
    else
    {
        fontColor = [NSColor whiteColor];
    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    [self drawText:openPrice atPoint:p andAttribute:dic];
    
#pragma mark 收
    x = 236*self.widthRate;
    y = topY + self.descriptAreaHeight - 4*self.fontScale - fontsize;
    //    fontsize = 12;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:@"收" atPoint:p andAttribute:dic];
    
    
    x = x+size.width;
    //    y = y;
    p.x = x+1;
    p.y = y+1;
    if (closePrice.floatValue > openPrice.floatValue) {
        fontColor = [NSColor whiteColor];
    }
    else
    {
        
        fontColor = [NSColor whiteColor];
    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    [self drawText:closePrice atPoint:p andAttribute:dic];
    
    x = 10;
    y = topY + self.descriptAreaHeight;
    
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:dateTime atPoint:p andAttribute:dic];

}
#pragma mark 折线说明
- (void)drawDescriptText:(NSString*)dateTime andPrice:(NSString*)currentPrice touchPrice:(NSString*)touchPrice;
{
    [[NSColor whiteColor] set];

    
    CGFloat x,y,w,h;
    CGSize size;
    NSDictionary *dic;
    CGPoint p;
    
    NSString* symbledate = [NSString stringWithFormat:@"%@",self.symbol];
    CGFloat topY = self.frame.size.height - self.descriptAreaHeight;
    x = 0;
    y = topY + 0*self.fontScale;
    
    p.x = x;
    p.y = y;
    CGFloat fontsize = 15*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    
    size = [self drawText:symbledate atPoint:p andAttribute:dic];
    w = size.width;
    h = size.height;
    
    
    
    x = 90*self.widthRate;
    y = y+h;
    fontsize = 13*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [@":" sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    y = y - h;
    //    [@"价:" drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    x = x + w +5;
    y = y+h;
    fontsize = 18*self.fontScale;//[NSColor colorWithRed:234.0/255.0 green:51.0/255.0 blue:94.0/255.0 alpha:1.0]
    
    NSColor* fontColor;
    if (self.up) {
        fontColor = [NSColor whiteColor];
    }
    else
    {
        fontColor = [NSColor whiteColor];
    }
    dic = @{(NSString *)NSForegroundColorAttributeName:fontColor,NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [touchPrice sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    y = y - h+2;
    [touchPrice drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    
    x = 180*self.widthRate;
    y = y+h-2;
    fontsize = 12*self.fontScale;
    
    CGFloat oldPrice = (self.maxy+self.miny)/2.0;
    NSString* kaiStr = [NSString stringWithFormat:@"%@,%.2f%%",
                        currentPrice,
                        100*((self.currentValueY - oldPrice)/oldPrice)];
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [@"" sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    y = y - h;
    [@"" drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    x = x + w +5;
    y = y+h+2*self.fontScale;
    fontsize = 12*self.fontScale;
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    size = [kaiStr sizeWithAttributes:dic];
    w = size.width;
    h = size.height;
    y = y - h;
    [kaiStr drawInRect:CGRectMake(x, y, w, h) withAttributes:dic];
    
    x = 10;
    y = topY + self.descriptAreaHeight;
    
    dic = @{(NSString *)NSForegroundColorAttributeName:[NSColor whiteColor],NSFontAttributeName:[NSFont systemFontOfSize:fontsize]};
    p.x = x;
    p.y = y;
    
    size = [self drawText:dateTime atPoint:p andAttribute:dic];
}
- (void)drawDescript
{
    NSInteger index = [self screenTouchPointIndex];
    
    if ([self.stockArray count] == 0) {
        return;
    }
    if (index >= [self.stockArray count]) {
        index = [self.stockArray count]-1;
    }
    id data = self.stockArray[index];
    NSDictionary* dataDic;
    NSArray*dataArray;
    CGFloat start,end,fmax,fmin;
    NSString *content;
    dataDic = data;
    dataArray = data;
    
    
    
    if ([self beTouched])
    {
        if (self.descriptAreaHeight < 10) {
            return;
        }
        
        if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary) {
            start = [data[@"open"] floatValue];
            end = [data[@"close"] floatValue];
            
            fmax = [data[@"high"] floatValue];
            fmin = [data[@"low"] floatValue];
        }
        else
        {
            NSString* o =[NSString stringWithFormat:@"%@",dataArray];
            
            NSArray* ta = [o componentsSeparatedByString:@" "];
            
            start = [ta[1] floatValue];
            end = [ta[1] floatValue];
            
            fmax = [ta[1] floatValue];
            fmin = [ta[1] floatValue];
        }
        
        
        start = start - self.miny;
        end =  end - self.miny;
        fmax = fmax - self.miny;
        fmin = fmin - self.miny;
#pragma mark - touch竖线
        if (self.fingerDown) {
            [self drawRectFrom2:start to:end at:index]; //竖线
        }
        
#pragma mark -
        
        //        [self drawRectFrom2:start to:end at:index]; //横线
    }
    
    if (self.descriptAreaHeight < 10) {
        return;
    }
    
    //    [[NSColor blackColor] set];
    
    
    CGFloat x,y,w,h;
    
    x = 0;
    y = 0; w = self.frame.size.width; h = self.descriptAreaHeight;
    CGFloat fontsize = 20*self.fontScale;
    
    
    if ([self.callback respondsToSelector:@selector(feedbackToUi:)]) {
        [self.callback feedbackToUi:data];
    }
    if ([self.callback respondsToSelector:@selector(touchPrice:)]) {
        [self.callback touchPrice:[NSString stringWithFormat:@"%.2f",self.touchY+self.miny]];
    }
    [self drawDescRect:CGRectMake(x,y, w,h)];
    
    if (self.style == SVGraphViewKline) {
        
        if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary) {
            content = [NSString stringWithFormat:@"%@,开:%@,\n收：%@，高：%@，低%@",data[@"beijing_time"],data[@"open"],data[@"close"],data[@"high"],data[@"low"]];
            
            NSString* dateTime  = [NSString stringWithFormat:@"%@",data[@"beijing_time"]];
            NSString* closePrice = [NSString stringWithFormat:@"%@",data[@"close"]];
            NSString* touchPrice = [NSString stringWithFormat:@"%@",self.currentValue];
            NSString* highPrice = [NSString stringWithFormat:@"%@",data[@"high"]];
            NSString* lowPrice = [NSString stringWithFormat:@"%@",data[@"low"]];
            NSString* openPrice = [NSString stringWithFormat:@"%@",data[@"open"]];
            
            [self drawDescriptText:dateTime andOpenPrice:openPrice touchPrice:touchPrice hightPrice:highPrice and:lowPrice and:closePrice];
        }
        else if(self.dataSourceFormat == SVGraphViewDataSourceFormatArray)
        {
            //            content = [NSString stringWithFormat:@"%@,%@",data[0],data[1]];
            content = [NSString stringWithFormat:@"%@,开:%@,\n收：%@，高：%@，低%@",data[0],data[1],data[2],data[3],data[4]];
            
            NSString* dateTime;
            if (self.fontScale< 1) {
                dateTime = [NSString stringWithFormat:@"%@/%@",self.symbol,data[0]];
            } else {
                dateTime = [NSString stringWithFormat:@"%@/%@",self.symbol,data[0]];
            }
            
            NSString* closePrice = [NSString stringWithFormat:@"%@",data[2]];
            NSString* touchPrice = [NSString stringWithFormat:@"%@",self.currentValue];
            NSString* highPrice = [NSString stringWithFormat:@"%@",data[3]];
            NSString* lowPrice = [NSString stringWithFormat:@"%@",data[4]];
            NSString* openPrice = [NSString stringWithFormat:@"%@",data[1]];
            
            [self drawDescriptText:dateTime andOpenPrice:openPrice touchPrice:touchPrice hightPrice:highPrice and:lowPrice and:closePrice];
        }
    }
    else
        
    {
        //        dataArray = data;
        if(self.dataSourceFormat == SVGraphViewDataSourceFormatArray)
        {
            
            NSString* o =[NSString stringWithFormat:@"%@",dataArray];
            
            NSArray* ta = [o componentsSeparatedByString:@" "];
            NSString* dateTime  = [NSString stringWithFormat:@"%@",ta[0]];
            NSString* currentPrice = [NSString stringWithFormat:@"%@",ta[1]];
            NSString* touchPrice = self.currentValue;
            
            [self drawDescriptText:dateTime andPrice:currentPrice touchPrice:touchPrice];
        }
//        else if(self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary)
//        {
//            
//            NSString* dateTime  = [NSString stringWithFormat:@"%@",data[@"beijing_time"]];
//            NSString* currentPrice = [NSString stringWithFormat:@"%@",data[@"close"]];
//            NSString* touchPrice = [NSString stringWithFormat:@"%@",self.currentValue];
//            
//            [self drawDescriptText:dateTime andPrice:currentPrice touchPrice:touchPrice];
//        }
        
    }
    // draw date
    // draw kai
    // draw shou
    // current price
    // draw high
    // draw low
    
}
- (void)drawStock
{
    if (self.stockArray == nil || [self.stockArray count] < 1) {
        return;
    }
    NSArray *olda;
    for (int i = 0;i < [self.stockArray count];i++) {
        
        NSArray *a = [self.stockArray objectAtIndex:i];
        
        
        if (self.style == SVGraphViewKline) {
            
            
            NSString* dateStr =  [NSString stringWithFormat:@"%@",a[0]];
            
            //    [self drawLogicalLineFrom:p1 to:p2];
            
            if([dateStr isEqualToString:self.tradeDate])
            {
                [self drawStockRecordSelected:a at:i];
            }
            else
            {
                NSInteger index = [self screenTouchPointIndex];
                
                if (index == i) {
                    [self drawStockRecordSelected:a at:i];
                }
                else
                    [self drawStockRecord:a at:i];
            }

            
            
        }
        else if (self.style == SVGraphViewReal) {
            CGPoint p1,p2;
            if (i == 0) {
                p1  = [self pointOfData:a at:i];
                p2 = p1;
                olda =a;
                
            }
            else
            {
                p1  = [self pointOfData:olda at:i-1];
                p2  = [self pointOfData:a at:i];
                olda = a;
                
            }
            [[NSColor yellowColor] set];
            [self drawLogicalLineFrom:p1 to:p2];
            
            [self drawVolumeRect:a at:i]; // 成交量的方块，扩展坐标系
        }
        else if (self.style == SVGraphViewZline) {
            CGPoint p1,p2;
            if (i == 0) {
                p1  = [self pointOfData:a at:i];
                p2 = p1;
                olda =a;
                
            }
            else
            {
                p1  = [self pointOfData:olda at:i-1];
                p2  = [self pointOfData:a at:i];
                olda = a;
                
            }
            [[NSColor yellowColor] set];
            [self drawLogicalLineFrom:p1 to:p2];
        }
        
        
    }
}
- (NSDate*) dateFromString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate * nsDate = [dateFormatter dateFromString:date];
    return nsDate;
}
- (NSString*) stringFromDate:(NSDate*)date {
    
    if (date == nil) {
        return @"---";
    }
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}
-(void)refreshValue:(NSString*)price forPriod:(NSInteger)minites
{
    if ([self.stockArray count] < 1) {
        return;
    }
    CGFloat pricevalue;
    //    self.currentValue = [NSString stringWithFormat:@"%@",price];
    pricevalue = [price floatValue];
    if (self.maxy < pricevalue) {
        self.maxy = pricevalue;
    }
    
    if (self.miny > pricevalue) {
        self.miny = pricevalue;
    }
    if (self.dataSourceFormat == SVGraphViewDataSourceFormatArray) {
        NSArray* a = [self.stockArray lastObject];
        NSString* lastTime;
        NSInteger length;
        lastTime = a[0];
        length = [self.stockArray count];
        if (lastTime == nil) {
            return;
        }
        else
        {
            //比对时间
            //            NSString* nowtime;
            NSDate *stockDate;
            stockDate = [self dateFromString:lastTime];
            
            NSTimeInterval secondsBetweenDates= [[NSDate date] timeIntervalSinceDate:stockDate];
            NSArray* b;
            
            if (secondsBetweenDates > minites*60) {
                NSString* nowString = [self stringFromDate:[NSDate date]];
                //new record
                b =  @[nowString,price];
            }
            else
            {
                length--;
                b = @[lastTime,price];
            }
            
            NSArray* c;
            NSRange r;
            r.location = 0;
            r.length = length;
            c = [self.stockArray subarrayWithRange:r];
            self.stockArray = [c arrayByAddingObject:b];
        }
        
        
    }
    else if (self.dataSourceFormat == SVGraphViewDataSourceFormatDictionary)
    {
        NSDictionary* a = [self.stockArray lastObject];
        NSString* lastTime;
        NSNumber* close,*high,*low,*open;
        
        close = a[@"close"];
        high = a[@"high"];
        low = a[@"low"];
        open = a[@"open"];
        
        
        lastTime = a[@"beijing_time"];
        
        NSInteger length = [self.stockArray count];
        
        if (lastTime == nil) {
            return;
        }
        else
        {
            //比对时间
            //            NSString* nowtime;
            NSDate *stockDate;
            stockDate = [self dateFromString:lastTime];
            
            NSTimeInterval secondsBetweenDates= [[NSDate date] timeIntervalSinceDate:stockDate];
            NSDictionary* b;
            
            NSString* nowString;
            if (secondsBetweenDates > minites*60) {
                nowString = [self stringFromDate:[NSDate date]];
                close = [NSNumber numberWithFloat:[price floatValue]];
                low = [NSNumber numberWithFloat:[price floatValue]];
                high = [NSNumber numberWithFloat:[price floatValue]];
                open = [NSNumber numberWithFloat:[price floatValue]];
                if(self.style == SVGraphViewKline)
                {
                    self.contentOffsetValue +=self.stepx;
                }
            }
            else
            {
                nowString = lastTime;
                length--;
                close = [NSNumber numberWithFloat:[price floatValue]];
                if ([low floatValue] > [price floatValue]) {
                    low = [NSNumber numberWithFloat:[price floatValue]];
                }
                
                if ([high floatValue] < [price floatValue]) {
                    high = [NSNumber numberWithFloat:[price floatValue]];
                }
                
            }
            
            b = @{@"beijing_time":nowString,@"high":high,@"low":low,@"open":open,@"close":close,@"time":nowString};
            
            NSArray* c;
            NSRange r;
            r.location = 0;
            r.length = length;
            c = [self.stockArray subarrayWithRange:r];
            self.stockArray = [c arrayByAddingObject:b];
            
        }
    }
    else
    {
        return;
    }
    
    [self coculateAllValue];
    [self setNeedsDisplay:YES];
    //    NSLog(@"\n%s,%d\n",__func__,__LINE__);
}

@end
