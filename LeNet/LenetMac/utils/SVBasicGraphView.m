//
//  SVBasicGraphView.m
//  MacApp
//
//  Created by 威 沈 on 17/09/2017.
//  Copyright © 2017 ShenWei. All rights reserved.
//

#import "SVBasicGraphView.h"
#import <simd/simd.h>
#import <simd/vector_types.h>
#include <math.h>
//vector_float3 userAcceleration = {motion.userAcceleration.x, motion.userAcceleration.y, motion.userAcceleration.z};
const double piv  = M_PI;

typedef NS_ENUM(NSInteger, SVGraphViewInterativeMode) {
    SVGraphModeToggle,
    SVGraphModeScroll
};


@interface SVBasicGraphView ()
{
    double east;
    double west;
    double north;
    double south;
    double near;
    double far;
    
    vector_float3 coordinateAngle;
    vector_float3 coordinateDAngle;
    matrix_float3x3 snk;
    CGPoint touchBeginPoint;
    CGPoint touchEndPoint;
    __block BOOL moved;
    
}
@property(nonatomic,assign)CGFloat coordinateX;
@property(nonatomic,assign)CGFloat coordinateY;
@property(nonatomic,assign)__block CGFloat contentOffsetX;
@property(nonatomic,assign)__block CGFloat contentOffsetY;
@property(nonatomic,assign)__block CGFloat contentOffsetZ;
@property(nonatomic,assign)__block CGFloat contentOffsetR;
@end;
@implementation SVBasicGraphView
-(id)init
{
    self = [super init];
    if(self)
    {
        
//        angleY = 0;
//        angleX = 0;
//        angleZ = 0;
//        angledY = 0;
//        angledX = 0;
//        angledZ = 0;
    }
    return self;
}
- (void)coculateAll
{
    coordinateAngle.x = 0;// - (self.contentOffsetY/self.frame.size.height);
    coordinateAngle.y = 0.0;// - (self.contentOffsetX/self.frame.size.width) ;// - (self.contentOffsetX/self.frame.size.width);
    coordinateAngle.z = M_PI/9.0;// + (self.contentOffsetY/self.frame.size.height);
    
    self.coordinateX = self.frame.size.width/2.0;
    self.coordinateY = self.frame.size.height/2.0;
    
    coordinateDAngle.x = piv*(self.contentOffsetY/self.frame.size.height);
    
    east = self.frame.size.width - self.coordinateX;//  +self.contentOffsetX;
    west =  self.coordinateX - self.frame.size.width;//  -self.contentOffsetX;
    
    north =self.frame.size.height - self.coordinateY;//  +self.contentOffsetY;
    south = self.coordinateY - self.frame.size.height;//  -self.contentOffsetY;
    
    double r2 = north*north + east*east;
    r2  = sqrt(r2);
    near = 0-r2;
    far = r2;

}
- (void)drawCoordX
{
    
    
    vector_float3 startp = {east,0,0};
    vector_float3 endp = {west,0,0};
    
    [self draw3DlineFrom:startp to:endp Dash:YES withAngle:coordinateDAngle];
}
- (void)drawCoordY
{

    
    vector_float3 startp = {0,north,0};
    vector_float3 endp = {0,south,0};
    
    [self draw3DlineFrom:startp to:endp Dash:YES withAngle:coordinateDAngle];
}
-(void)drawCoordZ
{
    
    
    vector_float3 startp = {0,0,near};
    vector_float3 endp = {0,0,far};
    
    [self draw3DlineFrom:startp to:endp Dash:YES withAngle:coordinateDAngle];

   
}

-(void)drawCoordZdelta:(CGFloat)rangle
{


    CGFloat x1,y1,z1;
    CGFloat x2,y2,z2;
    
    CGFloat r = far;
    x1 = 0;
    y1 = 0;
    z1 = 100;
    
    x2 = 0;
    y2 = 0;
    z2 = 100;
    
    
    coordinateAngle.z = rangle;
    
    x1= r*sin(rangle);
    y1 = r*cos(rangle);
    z1 = r;
    
    x2= -r*sin(rangle);
    y2 = -r*cos(rangle);
    z2 = -r;
    
    
    vector_float3 startp = {x1,y1,z1};
    vector_float3 endp =  {x2,y2,z2};
    
    [self draw3DlineFrom:startp to:endp Dash:YES withAngle:coordinateDAngle];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self coculateAll];
    
    
    NSRect bounds = [self bounds];
    
    [[NSColor colorWithCalibratedRed:26.0/255.0 green:17.0/255.0 blue:38.0/255.0 alpha:1.0] set] ;
    
    [NSBezierPath fillRect: bounds];
    
    
    

//    CGFloat x,y,z;
//    CGFloat theta = angledX;
//    x = 10;
//    y = 50;
//    z = 55;
//
//
//
//
//    vector_float3 p1 = {x,y,z};
//
//    x = -100;
//    y = 67;
//    z = 27;
////    x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
////    y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
//
////    vector_float3 p2 = {-100,67,27};
//    vector_float3 p2 = {x,y,z};
//    x = 35;
//    y = 67;
//    z = 78;
////    x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
////    y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
//
////    vector_float3 p3 = {35,67,78};
//    vector_float3 p3 = {x,y,z};
////    [self draw3DLineFrom:p1 to:p2 Dash:YES];
//    [self drawPlane:p1 point2:p2 point3:p3];
    
    

    
    vector_float3 sc = {100,100,100};
    [self drawStardCube:sc];
    
//    for (float r = 0; r< piv;r = r+ 0.1) {
//        [self drawCoordZdelta:r];
//    }
    
    
    [self drawCoordX];
    [self drawCoordY];
    [self drawCoordZ];
}
-(void)drawStardCube:(vector_float3) p1
{
    CGFloat x,y,z;
    x = p1.x;
    y = p1.y;
    z = p1.z;
    
    
    vector_float3 po1 = {-x,y,z};
    vector_float3 po2 = {-x,-y,z};
    vector_float3 po3 = {x,y,z};
    
    vector_float3 po4 = {x,-y,z};
    vector_float3 po5 = {x,-y,-z};
    vector_float3 po6 = {x,y, -z};
    vector_float3 po7 = {-x,y,-z};
    vector_float3 po8 = {-x,-y,-z};
    
    [self draw3DlineFrom:po1 to:po2 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po1 to:po3 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po3 to:po4 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po4 to:po2 Dash:YES withAngle:coordinateDAngle];
    
    [self draw3DlineFrom:po4 to:po5 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po5 to:po6 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po6 to:po7 Dash:YES withAngle:coordinateDAngle];
    
    [self draw3DlineFrom:po7 to:po1 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po8 to:po2 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po3 to:po6 Dash:YES withAngle:coordinateDAngle];
    
    [self draw3DlineFrom:po8 to:po5 Dash:YES withAngle:coordinateDAngle];
    [self draw3DlineFrom:po8 to:po7 Dash:YES withAngle:coordinateDAngle];
}
-(void)draw3DlineFrom:(vector_float3)point1  to:(vector_float3)point2 Dash:(BOOL)dash withAngle:(vector_float3)angle
{
    
    CGFloat x,y,z;
    CGFloat theta = angle.x;
    x = point1.x;
    y = point1.y;
    z = point1.z;
    
    
//    x =  x*cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
//    y = y*sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    
    
    
    vector_float3 p1 = {x,y,z};
    x = point2.x;
    y = point2.y;
    z = point2.z;
//    x =  x*cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
//    y = y*sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    vector_float3 p2 = {x,y,z};
    
    [self draw3DLineFrom:p1 to:p2 Dash:dash];
}
-(void)drawPlane:(vector_float3)point1  point2:(vector_float3)point2 point3:(vector_float3)point3
{

    [self draw3DlineFrom:point1 to:point2 Dash:NO withAngle:coordinateDAngle];
    [self draw3DlineFrom:point2 to:point3 Dash:NO withAngle:coordinateDAngle];
    [self draw3DlineFrom:point3 to:point1 Dash:NO withAngle:coordinateDAngle];

}
-(void)mouseExited:(NSEvent *)event
{
    moved = NO;
    NSPoint p = event.locationInWindow;
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
     [self setNeedsDisplay:YES];
    
}
-(void)mouseDown:(NSEvent *)event
{
    moved = YES;
    NSPoint p = event.locationInWindow;
    touchBeginPoint.x = p.x;
    touchBeginPoint.y = p.y;
    [self setNeedsDisplay:YES];
    
}
-(void)mouseUp:(NSEvent *)event
{
     moved = NO;
    NSPoint p = event.locationInWindow;
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
    [self setNeedsDisplay:YES];
}
-(void)mouseDragged:(NSEvent *)event
{
    NSPoint p = event.locationInWindow;
    touchEndPoint.x = p.x;
    touchEndPoint.y = p.y;
    self.contentOffsetX = touchEndPoint.x - touchBeginPoint.x;
    self.contentOffsetY = touchEndPoint.y - touchBeginPoint.y;
    [self setNeedsDisplay:YES];
    
}

-(void)drawFunction
{
    CGFloat x = 0,y = 0,z=0;
    CGFloat oldX = 0,oldY = 0,oldZ = 0;
    BOOL first = YES;
    CGFloat r = sqrt(20000.0);
    
    for (CGFloat i = 0; i<= 8; i=i+piv/12.0) {
        
        if(first)
        {
           
        }
        else
        {
            oldX = x;
            oldY = y;
            oldZ = z;
        }
        x= r*cos(i);
        y =100;
        z = r*sin(i);
        
        
        if(first)
        {
            oldX = x;
            oldY = y;
        }
        else
        {
            
        }

            
    
//        if(first == NO)
//            [self drawDashLine:oldX :oldY :oldZ :x :y :z];
//        else
//        {
//            first = NO;
//        }
    }
   
    
    
}
-(void)drawCircle:(CGFloat)r
{
    CGFloat x = 0,y = 0,z=0;
    CGFloat oldX = 0,oldY = 0,oldZ = 0;
    BOOL first = YES;
   
    
    for (CGFloat i = 0; i<= 8; i=i+piv/8.0) {
        
        if(first)
        {
            
        }
        else
        {
            oldX = x;
            oldY = y;
            oldZ = z;
        }
        x= r*cos(i);
        y = r;
        z = r*sin(i);
        
        
        if(first)
        {
            oldX = x;
            oldY = y;
        }
        else
        {
            
        }
        
        
        vector_float3 p1 ={oldX ,oldY ,oldZ};
        
        vector_float3 p2 ={x,y,z};
        if(first == NO)
            [self draw3DLineFrom:p1 to:p2 Dash:NO];
        else
        {
            first = NO;
        }
    }
    
    
    
}
- (matrix_float3x3)functionSnk:(vector_float3)point withK:(int)k
{
    matrix_float3x3 rs;
    
    double v1 = 1+ (k -1)*pow(point.x, 2);
    rs.columns[0][0] = v1;
    
    v1 = (k -1)*point.x*point.y;
    rs.columns[1][0] = v1;
    
    v1 = (k -1)*point.x*point.z;
    rs.columns[2][0] = v1;
    
    
    v1 = (k -1)*point.x*point.y;
    rs.columns[0][1] = v1;
    
    v1 = 1+ (k -1)*pow(point.y, 2);
    rs.columns[1][1] = v1;
    
    v1 = (k -1)*point.y*point.z;
    rs.columns[2][1] = v1;
    
    
    v1 = (k -1)*point.x*point.z;
    rs.columns[0][2] = v1;
    
    v1 = (k -1)*point.y*point.z;
    rs.columns[1][2] = v1;
    
    v1 = 1+ (k -1)*pow(point.z, 2);
    rs.columns[2][2] = v1;
    
    
    return rs;
}
- (void)draw3DLineFrom:(vector_float3)from to:(vector_float3)to Dash:(BOOL)dash
{
    CGPoint p1,p2;
    CGFloat x1 = from.x;
    CGFloat y1 = from.y;
    CGFloat z1 = from.z;
    CGFloat x2 = to.x;
    CGFloat y2 = to.y;
    CGFloat z2 = to.z;
    
    
    CGFloat rate1 = ((far)-z1)/(far);
    CGFloat rate2 = ((far)-z2)/(far);
    NSLog(@"rate1 %.2f",rate1);
    NSLog(@"rate2 %.2f",rate2);
    
    rate1 = 1;
    rate2 = 1;
#pragma mark - here
    
    /*
     x1 = x cos(b) – y sin(b)    (1.3)
     y1 = x sin(b) + y cos(b)    (1.4)
     
     s =  os = oa + as = x cos(theta) + y sin(theta)
     t =  ot = ay – ab = y cos(theta) – x sin(theta)
     */
    p1.x = x1*cos(coordinateAngle.z) - y1*sin(coordinateAngle.z);
    p1.y = x1*sin(coordinateAngle.z) + y1*cos(coordinateAngle.z);
    
    p2.x = x2*cos(coordinateAngle.z) - y2*sin(coordinateAngle.z);
    p2.y = x2*sin(coordinateAngle.z) + y2*cos(coordinateAngle.z);
    
    
    
    
    if(dash)
    {
        [self drawDashLineFrom:p1 to:p2];
    }
    else
    {
        [self drawLineFrom:p1 to:p2];
    }
}
//- (void)drawLine:(CGFloat)x1 :(CGFloat)y1 :(CGFloat)z1 :(CGFloat)x2 :(CGFloat)y2 :(CGFloat)z2
//{
//    CGPoint p1,p2;
//
//
//
//    CGFloat rate1 = ((far)-z1)/(far);
//    CGFloat rate2 = ((far)-z2)/(far);
//    NSLog(@"rate1 %.2f",rate1);
//    NSLog(@"rate2 %.2f",rate2);
//
//
//    p1.x = cos(angleX)*(x1*rate1 + z1*cos(angleY)*cos(angleX));
//    p1.y = sin(angleY)*(y1*rate1 + z1*cos(angleY)*cos(angleY));
//
//    p2.x = cos(angleX)*(x2*rate2 + z2*cos(angleY)*cos(angleX));
//    p2.y = sin(angleY)*(y2*rate2 + z2*cos(angleY)*cos(angleY));
//
//
//
//    [self drawLineFrom:p1 to:p2];
//}
- (void)drawLine:(CGFloat)x1 :(CGFloat)y1 :(CGFloat)x2 :(CGFloat)y2
{
    CGPoint p1,p2;
    p1.x = x1;
    p1.y = y1;
    
    p2.x = x2;
    p2.y = y2;
    
    
    [self drawLineFrom:p1 to:p2];
}
//- (void)drawDashLine:(CGFloat)x1 :(CGFloat)y1 :(CGFloat)z1 :(CGFloat)x2 :(CGFloat)y2 :(CGFloat)z2
//{
//    CGPoint p1,p2;
//    CGFloat rate1 = ((far)-z1)/(far);
//    CGFloat rate2 = ((far)-z2)/(far);
//    NSLog(@"rate1 %.2f",rate1);
//    NSLog(@"rate2 %.2f",rate2);
//
//    p1.x = cos(angleX)*(x1*rate1 + z1*cos(angleY)*cos(angleX));
//    p1.y = sin(angleY)*(y1*rate1 + z1*cos(angleY)*cos(angleY));
//
//    p2.x = cos(angleX)*(x2*rate2 + z2*cos(angleY)*cos(angleX));
//    p2.y = sin(angleY)*(y2*rate2 + z2*cos(angleY)*cos(angleY));
//
//
//    [self drawDashLineFrom:p1 to:p2];
//}
- (void)drawDashLine:(CGFloat)x1 :(CGFloat)y1 :(CGFloat)x2 :(CGFloat)y2
{
    CGPoint p1,p2;
    p1.x = x1;
    p1.y = y1;
    
    p2.x = x2;
    p2.y = y2;
    
    
    [self drawDashLineFrom:p1 to:p2];
}

- (CGFloat)transY:(CGFloat)oy
{
    return (self.coordinateY + oy);
}

- (CGFloat)transX:(CGFloat)ox   //逻辑
{
    return (self.coordinateX + ox);
}
- (void)drawDashLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    
//    BOOL coor = NO;
    
    CGFloat theta = coordinateAngle.z;
    CGFloat x,y;
    x = point1.x;
    y = point1.y;
    //    x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
    //    y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    from.x = x;
    from.y = y;
    
    x = point2.x;
    y = point2.y;
    //    to.x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
    //    to.y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    to.x = x;
    to.y = y;
    
    
    
    from.x = [self transX:from.x];
    from.y = [self transY:from.y];
    
    to.x = [self transX:to.x];
    to.y = [self transY:to.y];
    
    
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    CGContextSetLineWidth(myContext, 0.5);
    
    CGContextSetLineCap(myContext,kCGLineCapButt);
    //1.3  虚实切换
    CGFloat length[] = {2,2,2};
    CGContextSetLineDash(myContext, 0, length, 3);
    
    CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}
- (void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2
{
    
    CGPoint from,to;
    
    
    CGFloat theta = coordinateAngle.z;
    CGFloat x,y;
    x = point1.x;
    y = point1.y;
//    x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
//    y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    from.x = x;
    from.y = y;
    
    x = point2.x;
    y = point2.y;
//    to.x =  cos(theta) - sin(theta)*x-x*cos(theta)+y*sin(theta);
//    to.y = sin(theta) - cos(theta)*y-x*sin(theta)-y*cos(theta);
    to.x = x;
    to.y = y;
    
    from.x = [self transX:from.x];
    from.y = [self transY:from.y];
    
    to.x = [self transX:to.x];
    to.y = [self transY:to.y];
    
    
    CGContextRef myContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath (myContext);
    
    CGContextSetLineWidth(myContext, 0.5);
    
    CGContextSetLineCap(myContext,kCGLineCapButt);
    CGFloat length[] = {0,0,0};
    CGContextSetLineDash(myContext, 0, length, 0);
    CGContextSetStrokeColorWithColor(myContext, [NSColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    
    CGContextMoveToPoint(myContext,from.x,from.y);
    CGContextAddLineToPoint(myContext,to.x, to.y);
    CGContextStrokePath(myContext);
}

@end
