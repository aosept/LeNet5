
//
//  NSImage+SV.h
//  tripaccounting
//
//  Created by 沈 威 on 15/2/28.
//  Copyright (c) 2015年 Shen Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NSImage (SV)
-(NSImage*)matrixToImage:(NSArray*)matrixArray;
+(NSImage*)floatArrayToImage:(const float*)array withH:(int)imageH andW:(int)imageW;
+(NSImage*)arrayToImage:(uint8_t*)array withH:(int)imageH andW:(int)imageW;
+(NSImage*)matrixToImage:(const float**)array withH:(int)imageH andW:(int)imageW;
+ (NSImage *)getImageWithUrlStringForImage:(NSString *)imageString;
+(NSImage*) GetSavedImageWithName:(NSString*) aFileName;




@property (nonatomic,assign) float transMaxH;
@property (nonatomic,assign) float transMaxV;
@property (nonatomic,assign) float transMinH;
@property (nonatomic,assign) float transMinV;


+(NSString*)imageFileName:(NSString*)aFileName;
//- (NSImage *)fixOrientation;

- (NSImage *) imageBgTransparentWith:(CGFloat)transMaxH :(CGFloat)transMinH :(CGFloat)transMaxV :(CGFloat)transMinV;

- (NSImage *) imageBgTransparentWithRadiur:(int)r;
- (NSDictionary *) imageGridCalcolate;
@end
@protocol MImageViewDelegate <NSObject>
@optional
-(void)locationChanged:(CGPoint)p;
-(void)drawLocation:(CGPoint)p with:(CGPoint)color;
@end
@interface MImageView :NSImageView
@property(nonatomic,weak) id <MImageViewDelegate> delegate;
-(void)leftUpCornerEliminate;
-(void)rightUpCornerEliminate;
-(void)calculateGrid;
@end
