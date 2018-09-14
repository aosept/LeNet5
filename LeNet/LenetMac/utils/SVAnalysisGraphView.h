//
//  SVAnalysisGraphView.h
//  JustPlay
//
//  Created by 沈威 on 15/1/23.
//  Copyright (c) 2015年 Shen Wei. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, SVGraphViewStyle) {
    SVGraphViewKline,
    SVGraphViewReal,
    SVGraphViewZline,
    SVGraphViewAppleWatch
};
typedef NS_ENUM(NSInteger, SVGraphViewDataSourceFormat) {
    SVGraphViewDataSourceFormatDictionary,
    SVGraphViewDataSourceFormatArray,
    SVGraphViewDataSourceFormatUnknown
};

typedef NS_ENUM(NSInteger, SVGraphViewInterativeMode) {
    SVGraphViewInterativeModeToggle,
    SVGraphViewInterativeModeScroll
};

@protocol SVGraphViewDelegate <NSObject>

- (void)dosomething;
- (void)reloadDataForSymbol;
@optional
- (void)requestStockMinute:(NSString*)StockName;
- (void)selectedIndexData:(id)data;
- (void)finished;
@end


@interface IHCoordinate : NSObject
@property(nonatomic,assign)CGFloat coordinateX;
@property(nonatomic,assign)CGFloat coordinateY;
@property(nonatomic,assign)CGFloat stepy;
@property(nonatomic,assign)CGFloat stepx;
@property(nonatomic,assign)CGFloat west;
@property(nonatomic,assign)CGFloat east;
@property(nonatomic,assign)CGFloat north;
@property(nonatomic,assign)CGFloat south;
@property(nonatomic,assign) CGFloat maxy;
@property(nonatomic,assign) CGFloat miny;

@end

@interface SVGraphView : NSView
@property(nonatomic,strong)IHCoordinate* extentCoorinate;
@property(nonatomic,assign)CGFloat descriptAreaHeight;
@property(nonatomic,assign)CGFloat descriptDateHeight;
@property(nonatomic,assign)CGFloat gapHeight;
@property(nonatomic,assign)CGFloat coordinateX;
@property(nonatomic,assign)CGFloat coordinateY;
@property(nonatomic,assign)CGFloat stepy;
@property(nonatomic,assign)CGFloat stepx;
@property(nonatomic,assign)CGFloat west;
@property(nonatomic,assign)CGFloat east;
@property(nonatomic,assign)CGFloat north;
@property(nonatomic,assign)CGFloat south;
@property(nonatomic,assign) BOOL up;
@property(nonatomic,assign) BOOL fingerDown;
@property(nonatomic,assign)__block CGFloat maxy;
@property(nonatomic,assign)__block CGFloat miny;
@property(nonatomic,assign)CGFloat contentWidth;
@property(nonatomic,assign)__block CGFloat contentOffsetValue;
@property(nonatomic,assign)CGFloat touchY;
@property(nonatomic,assign)CGFloat displayRate;
@property(nonatomic,assign)CGFloat vOffset;
@property(nonatomic,assign)CGFloat yesterdayPrice;
@property(nonatomic) NSUInteger countOfRecord;
@property(nonatomic,weak) id <SVGraphViewDelegate> delegate;
@property(nonatomic,assign) SVGraphViewStyle style;
@property(nonatomic,assign) SVGraphViewDataSourceFormat dataSourceFormat;
@property(nonatomic,assign) BOOL beTouched;
@property(nonatomic,assign) double currentValueY;
@property(nonatomic,assign) double buy1Price;
@property(nonatomic,assign) double buy2Price;
@property(nonatomic,assign) double buy3Price;
@property(nonatomic,strong) NSString* tradeDate;
@property(nonatomic,strong) NSString* buysell;
@property(nonatomic,assign) int tradeIndex;
@property (nonatomic,assign) CGFloat widthRate;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger offsetIndex;
@property(nonatomic)BOOL loadingMore;
@property(nonatomic) BOOL autoAdjust;
@property(nonatomic) CGFloat fontScale;
@property(nonatomic,strong) NSArray* stockArray;
@property(nonatomic,strong) NSMutableArray* maArray5;
@property(nonatomic,strong) NSMutableArray* maArray10;
@property(nonatomic,strong) NSMutableArray* maArray20;
@property(nonatomic,strong) NSMutableArray* maArray60;
@property(nonatomic,strong) NSMutableArray* maArray120;
@property(nonatomic,assign) CGFloat macount5;
@property(nonatomic,assign) CGFloat macount10;
@property(nonatomic,assign) CGFloat macount20;
@property(nonatomic,assign) CGFloat macount60;
@property(nonatomic,assign) CGFloat macount120;
//@property(nonatomic,assign) CGFloat fontScale;
- (id)initWithScale:(CGFloat)ftScale;
-(void)drawPoint:(CGPoint)point;
- (void)drawLogcalPoint:(CGPoint)point;

-(void)drawLineFrom:(CGPoint)point1 to:(CGPoint)point2;
- (void)drawLogicalLineFrom:(CGPoint)p1 to:(CGPoint)p2;
- (void)coculateAllValue;
- (CGFloat)mostRightPosition;
- (void)setContentOffset;
- (void) drawYline;
- (void) drawXline;
- (void)drawPath;

- (NSInteger)screenTouchPointIndex;
- (BOOL)moved;
- (void)coculateAllMA;
- (void)coculateA;
@end
@protocol SVAnalysisControlDelegate <NSObject>

-(void)feedbackToUi:(id)data;
-(void)touchPrice:(NSString*)prictString;

@end
@interface SVAnalysisGraphView : SVGraphView

- (void)updateGraphview;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* symbol;
-(void)dataCoculate;
-(void)dataCoculateWithPosition:(NSInteger)p;
-(void)refreshValue:(NSString*)price forPriod:(NSInteger)minites;
@property(nonatomic,strong)NSString* currentValue;
@property(nonatomic,strong)NSString* openPrice;
@property(nonatomic,strong)NSString* lastTime;
@property(nonatomic,strong)NSDictionary* tradeinfo;
@property(nonatomic,weak) id <SVAnalysisControlDelegate> callback;
@end
