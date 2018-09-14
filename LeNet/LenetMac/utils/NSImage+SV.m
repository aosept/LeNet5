//
//  NSImage+SV.m
//  tripaccounting
//
//  Created by 沈 威 on 15/2/28.
//  Copyright (c) 2015年 Shen Wei. All rights reserved.
//

#import "NSImage+SV.h"
#import <math.h>
#import <CommonCrypto/CommonDigest.h>

#define matrix 5
#define matrix2 3
int imageWidth;
int imageHeight;
uint32_t *rgbImageBuf;
uint32_t * rgbImageBuf2;
CGFloat maxtH,mintH,maxtV,mintV;
int matrixV;
typedef struct ColorARGB
{
    uint8_t a;
    uint8_t b;
    uint8_t g;
    uint8_t r;
} ColorARGB;

typedef struct ColorHVS
{
    int h;
    int v;
    int s;
} ColorHVS;
@implementation NSImage (SV)

@dynamic transMaxV,transMaxH,transMinH,transMinV;

static NSString *cache_path()
{
    static NSString *cache_path;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache_path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"image"];
    });
    return cache_path;
}
+(NSString*)imageFileName:(NSString*)aFileName
{
    NSString* tmpStr;
    NSArray *strarray = [aFileName componentsSeparatedByString:@"/"];
    
    if ([strarray  count] >= 1) {
        NSUInteger c = [strarray  count]-1;
        tmpStr = strarray[c];
    }
    else
        tmpStr = aFileName;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString* str = [[NSMutableString alloc] initWithCapacity:300];
    [str appendString:documentsDirectory];
    [str appendString:@"/"];
    [str appendString:tmpStr];
    
    return str;
}
+ (NSString *) md5:(NSString *)str
{
    if(str == nil || str.length < 5)
    {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+ (NSImage *)getImageWithUrlStringForImage:(NSString *)imageString{
    
    
    if ([imageString containsString:@"cdwin"]) {
        return [NSImage imageNamed:@"logo"];
    }
    NSString* fileName = [NSImage md5:imageString];
    fileName = [NSImage imageFileName:fileName];
    
    __block NSImage* image = [NSImage imageFileName:fileName];
    if(image == nil)
    {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
        image= [[NSImage alloc] initWithData:data];
    
        [image savedWithName:fileName];
        NSLog(@"%@",imageString);
        
        
    }
    else
    {
        NSLog(@"read from cache...4");
    }
    
    return image;
}
-(void) savedWithName:(NSString*) aFileName
{
    
    NSString* tmpStr = [NSImage imageFileName:aFileName];
    
    [self lockFocus];

    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, self.size.width, self.size.height)];
    [self unlockFocus];

    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
    
    NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];

    BOOL y = [imageData writeToFile:[[NSString stringWithString:aFileName] stringByExpandingTildeInPath]atomically:YES];
    NSLog(@"Save Image: %d", y);
}
+(NSImage*) GetSavedImageWithName:(NSString*) aFileName
{
    
    NSString* tmpStr;
    NSArray *strarray = [aFileName componentsSeparatedByString:@"/"];
    
    if ([strarray  count] >= 1) {
        NSUInteger c = [strarray  count]-1;
        tmpStr = strarray[c];
    }
    else
        tmpStr = aFileName;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString* str = [[NSMutableString alloc] initWithCapacity:300];
    [str appendString:documentsDirectory];
    [str appendString:@"/"];
    [str appendString:tmpStr];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:str];
    
    NSData *dataToWrite = nil;
    
    NSImage* image = nil;
    
    if(!success)
    {
        return nil;
    }
    else
    {
        dataToWrite = [[NSData alloc] initWithContentsOfFile:str];
        image = [[NSImage alloc] initWithData:dataToWrite];
    }
    return image;
}

+(NSImage *) imageCompressForSize:(NSImage *)sourceImage targetSize:(CGSize)size{
    
   
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: size];
        [smallImage lockFocus];
        [sourceImage setSize: size];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, size.width, size.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
    
}
+(NSImage*)matrixToImage:(const float**)array withH:(int)imageH andW:(int)imageW
{
    size_t      bytesPerRow = imageW * 4;
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    uint32_t *imageBuf;
    imageBuf = (uint32_t *)malloc(imageW * imageH*4);
    
    ColorARGB *ptr;
    for (int row = 0; row < imageH; row++) {
        
        
        
        for (int col =0; col < imageW; col++) {
            
            
            float v = array[row][col]*255;
            
            
            NSInteger pixlPos = row*imageW + col;
            uint32_t *pCurPixel =  &imageBuf[pixlPos];
            ptr = (ColorARGB *)pCurPixel;
            ptr->b = v;
            ptr->g = v;
            ptr->r = v;
            ptr->a = 255;
//            printf("%.2f\t",v);
            
        }
//        printf("\n");
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, imageBuf, bytesPerRow * imageH,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageW, imageH, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageW, imageH)];// [NSImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    //    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return resultNSImage;
}
+(NSImage*)floatArrayToImage:(const float*)array withH:(int)imageH andW:(int)imageW
{
    
    size_t      bytesPerRow = imageW * 4;
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    uint32_t *imageBuf;
    imageBuf = (uint32_t *)malloc(imageW * imageH*4);
    
    ColorARGB *ptr;
    for (int row = 0; row < imageH; row++) {
        
        
        
        for (int col =0; col < imageW; col++) {
            
            
            float v = array[row*imageW+col]*255;
            
            
            NSInteger pixlPos = row*imageW + col;
            uint32_t *pCurPixel =  &imageBuf[pixlPos];
            ptr = (ColorARGB *)pCurPixel;
            ptr->b = v;
            ptr->g = v;
            ptr->r = v;
            ptr->a = 255;
            
            
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, imageBuf, bytesPerRow * imageH,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageW, imageH, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageW, imageH)];// [NSImage
   
    
    // 释放
    CGImageRelease(imageRef);
    //    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return resultNSImage;
}
+(NSImage*)arrayToImage:(uint8_t*)array withH:(int)imageH andW:(int)imageW
{

    size_t      bytesPerRow = imageW * 4;
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   
    uint32_t *imageBuf;
    imageBuf = (uint32_t *)malloc(imageW * imageH*4);
    
    ColorARGB *ptr;
    for (int row = 0; row < imageH; row++) {
        
        
        
        for (int col =0; col < imageW; col++) {
            
            
            uint8_t v = array[row*imageW+col];
          
            
            NSInteger pixlPos = row*imageW + col;
            uint32_t *pCurPixel =  &imageBuf[pixlPos];
            ptr = (ColorARGB *)pCurPixel;
            ptr->b = v;
            ptr->g = v;
            ptr->r = v;
            ptr->a = 255;
            
            
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, imageBuf, bytesPerRow * imageH,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageW, imageH, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageW, imageH)];// [NSImage
    
    
    // 释放
    CGImageRelease(imageRef);
    //    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return resultNSImage;
}
-(NSImage*) matrixToImage:(NSArray*)matrixArray
{
    NSInteger rowNumber;
    NSInteger colNumber;
    
    if([matrixArray count] < 1)
    {
        return nil;
    }
    rowNumber = [matrixArray count];
    
    NSArray* array = [matrixArray firstObject];
    if(array.count < 1)
    {
        return nil;
    }
    
    colNumber = [array count];
    
    uint32_t *imageBuf;
    imageBuf = (uint32_t *)malloc(colNumber * rowNumber*4);
    
    

    NSInteger imageW = colNumber;
    NSInteger imageH = rowNumber;
    size_t      bytesPerRow = imageW * 4;
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(imageBuf, imageW, imageH, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
//    CGContextDrawImage(context, CGRectMake(0, 0, imageW, imageH), self.CGImage);
    

    
    // 遍历像素

    ColorARGB *ptr;
    for (int row = 0; row < imageH; row++) {
        
        NSArray* rowArray = matrixArray[row];
        
        for (int col =0; col < imageW; col++) {
            
            
            CGFloat v;
            if(col < rowArray.count)
            {
                v = [rowArray[col] floatValue]*255;
            }
            else
                v = 0;
            
            NSInteger pixlPos = row*imageW + col;
            uint32_t *pCurPixel =  &imageBuf[pixlPos];
            ptr = (ColorARGB *)pCurPixel;
            ptr->b = v;
            ptr->g = v;
            ptr->r = v;
            ptr->a = 255;
            
            
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, imageBuf, bytesPerRow * imageH,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageW, imageH, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageW, imageH)];// [NSImage
   
    
    // 释放
    CGImageRelease(imageRef);
//    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return resultNSImage;

}

-(void)findColorFieldAt:(int)searchbeginx :(int)searchbeginy :(int)searchStep
{
    int searchendx = searchbeginx + searchStep;
    int searchendy = searchendx + searchStep;
    
    
    maxtH = 0;
    mintV = 255;
    maxtV = 0;
    mintH = 255;
    
    int MaxCount = 6;
    int changeMinhCount = 0;
    int changeMinvCount = 0;
    int changeMaxhCount = 0;
    int changeMaxvCount = 0;
    
    int pixlPos;
    
    for (int row = searchbeginx; row < imageHeight && row < searchendx; row++) {
        for (int col =searchbeginy; col < imageWidth && col < searchendy; col++) {
            
            pixlPos = row*imageWidth + col;
            uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
            
            ColorARGB *ptr = (ColorARGB *)pCurPixel;
            
            
            
            
            float maxv = MAX(ptr->r, MAX(ptr->g, ptr->b));
            float minv = MIN(ptr->r, MIN(ptr->g, ptr->b));
            int hv = 0;
            if(maxv == ptr->r)
            {
                hv = ((float)(ptr->g-ptr->b))/(maxv -minv)*60;
            }
            if(maxv == ptr->g)
            {
                hv =  120 + ((float)(ptr->b - ptr->r))/(maxv -minv)*60;
            }
            if(maxv == ptr->b)
            {
                hv =  240 + ((float)(ptr->r - ptr->g))/(maxv -minv)*60;
            }
            
            if (hv < 0)
                hv = hv+ 360;
            
            if(hv > maxtH)
            {
                changeMaxhCount++;
                if(changeMaxhCount > MaxCount)
                {
                    maxtH = hv;
                    changeMaxhCount = 0;
                }
            }
            else
            {
                if(changeMaxhCount > 0)
                    changeMaxhCount --;
            }
            
            
            if(hv < mintH)
            {
                changeMinhCount++;
                if(changeMinhCount > MaxCount)
                {
                    mintH = hv;
                    changeMinhCount = 0;
                }
            }
            else
            {
                if(changeMinhCount > 0)
                    changeMinhCount --;
            }
            
            if(maxv > maxtV)
            {
                changeMaxvCount++;
                if(changeMaxvCount > MaxCount)
                {
                    maxtV = maxv;
                    changeMaxvCount = 0;
                }
            }
            else
            {
                if(changeMaxvCount > 0)
                    changeMaxvCount --;
            }
            
            
            if(maxv < mintV)
            {
                changeMinvCount++;
                if(changeMinvCount > MaxCount)
                {
                    mintV = maxv;
                    changeMinvCount = 0;
                }
            }
            else
            {
                if(changeMinvCount > 0)
                    changeMinvCount --;
            }
            
        }
    }
}
-(uint32_t *)avgColor:(const int)row :(const int) col
{
    int x,y,xend,yend;
    if(matrixV == 0 || matrixV > 200)
    {
        matrixV = matrix;
    }
    x = col - matrixV/2;
    y = row - matrixV/2;
    xend = x+matrixV;
    yend = y+matrixV;
    
    if(x<0)
        x=0;
    if(y<0)
        y=0;
    if(xend >= imageWidth)
        xend = imageWidth-1;
    
    if(yend >= imageHeight)
        yend = imageHeight-1;
    int count = 0;
    
    ColorARGB *ptr;
    int r,g,b;
    r = 0;
    g = 0;
    b = 0;
    
    for (int i = x; i<xend ; i++) {
        for (int j = y; j<yend; j++) {
            count++;
            
            int pPos = i + j*imageWidth;
            uint32_t *tPixel =  &rgbImageBuf[pPos];
            
            ptr = (ColorARGB *)tPixel;
            r += ptr->r;
            g += ptr->g;
            b += ptr->b;
            
        }
    }
    r = r/count;
    b = b/count;
    g = g/count;
    int pixlPos = row*imageWidth + col;
    uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
    ptr = (ColorARGB *)pCurPixel;
    ptr->b = b;
    ptr->g = g;
    ptr->r = r;
    return pCurPixel;
}
-(void)egdeAvgColor:(const int)row :(const int) col
{
    int x,y,xend,yend;
    
    x = col - matrix2/2;
    y = row - matrix2/2;
    xend = x+matrix2;
    yend = y+matrix2;
    
    if(x<0)
        x=0;
    if(y<0)
        y=0;
    if(xend >= imageWidth)
        xend = imageWidth-1;
    
    if(yend >= imageHeight)
        yend = imageHeight-1;
    int count = 0;
    int r,g,b;
    r = 0;
    g = 0;
    b = 0;
    BOOL findAlpha = NO;
    BOOL findNoAlpha = NO;
    for (int i = x; i<xend ; i++) {
        for (int j = y; j<yend; j++) {
            count++;
            
            int pPos = i + j*imageWidth;
            uint32_t *tPixel =  &rgbImageBuf2[pPos];
            ColorARGB *p = (ColorARGB *)tPixel;
            
            r += p->r;
            g += p->g;
            b += p->b;
            if(p->a == 0)
                findAlpha = YES;
            else
                findNoAlpha = YES;
        }
    }
    
    if(findAlpha)
    {
        r = r/count;
        b = b/count;
        g = g/count;
        int pixlPos = row*imageWidth + col;
        uint32_t *pCurPixel =  &rgbImageBuf2[pixlPos];
        ColorARGB *ptr = (ColorARGB *)pCurPixel;
        ptr->b = b;
        ptr->g = g;
        ptr->r = r;
    }
    
    
}
-(void)partialAlphaEnableWith:(CGFloat)transMaxH :(CGFloat)transMinH :(CGFloat)transMaxV :(CGFloat)transMinV
{
    uint32_t *pCurPtr = rgbImageBuf;
    uint32_t *pCurPtr2 = rgbImageBuf2;
    
    int pixelNum = imageWidth * imageHeight;
    for (int i = 0; i < pixelNum; i++, pCurPtr++,pCurPtr2++){
        
        //        int h =  (i / imageWidth);
        bool shouldFade = false;
        ColorARGB *ptr = (ColorARGB *)pCurPtr;
        ColorARGB *ptr2 = (ColorARGB *)pCurPtr2;
        
        
        
        float maxv = MAX(ptr->r, MAX(ptr->g, ptr->b));
        float minv = MIN(ptr->r, MIN(ptr->g, ptr->b));
        int hv = 0;
        if(maxv == ptr->r)
        {
            hv = ((float)(ptr->g-ptr->b))/(maxv -minv)*60;
        }
        if(maxv == ptr->g)
        {
            hv =  120 + ((float)(ptr->b - ptr->r))/(maxv -minv)*60;
        }
        if(maxv == ptr->b)
        {
            hv =  240 + ((float)(ptr->r - ptr->g))/(maxv -minv)*60;
        }
        
        if (hv < 0)
            hv = hv+ 360;
        
        transMinV = mintV;
        transMinH = mintH;
        transMaxH = maxtH;
        transMaxV = maxtV;
        
        //        if(transMaxH == 0)
        //            transMaxH = 300;
        //
        //        if(transMinH == 0)
        //            transMinH = 180;
        //
        //        if(transMinV == 0)
        //            transMinV = 162;
        //
        //        if(transMaxV == 0)
        //            transMaxV = 255;
        
        if( hv > transMinH && hv < transMaxH && maxv > transMinV)
        {
            shouldFade = true;
        }
        
        if (shouldFade) {
            
            ptr2->a = 0;
            
        }
    }
}
-(NSArray*)mergeNumberArray:(NSArray<NSNumber *>*)array
{
    if (array.count < 1) {
        return array;
    }
    NSArray* oArray = @[array.firstObject];
    
    CGFloat preValue = [array[0] floatValue];
    for (NSInteger i = 1; i< array.count; i++) {
        NSNumber* nValue = array[i];
        
        if (fabs(nValue.floatValue - preValue) > 5) {
            oArray= [oArray arrayByAddingObject:nValue];
            preValue = nValue.floatValue;
        }
        else
        {
            NSInteger j = i+1;
            if(j < array.count)
            {
                NSNumber* nextValue = array[j];
                
                if (fabs(nValue.floatValue - nextValue.floatValue) > 5) {
                    oArray= [oArray arrayByAddingObject:nValue];
                    preValue = nValue.floatValue;
                }
            }
        }
        
    }
    return oArray;
}
-(CGImageRef)CGImage
{
    NSImage* someImage = self;
    // create the image somehow, load from file, draw into it...
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((CFDataRef)[someImage TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    return maskRef;
}
- (NSDictionary *) imageGridCalcolate
{
    
    // 分配内存
    //    int top = 100;
    //    int step = 20;
    imageWidth = self.size.width;
    imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    rgbImageBuf2 = (uint32_t *)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    context = CGBitmapContextCreate(rgbImageBuf2, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    
    //    uint32_t *pCurPtr = rgbImageBuf;
    //    uint32_t *pCurPtr2 = rgbImageBuf2;
    int pixlPos = 0;
    
    int y = 0;
    
    BOOL goThrough = NO;
    BOOL hasObject = NO;
    
    NSArray* yarray = @[];
    int miny =  imageHeight;
    int maxy = 0;
    for (int row = 0; row < imageHeight; row++) {
        
        int xindex = 0;
        for (int col =0; col < imageWidth; col++) {
            
            pixlPos = row*imageWidth + col;
            uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
            
            
            
            ColorARGB *ptr = (ColorARGB *)pCurPixel;
            if (ptr->r == 0 && ptr->b == 0 && ptr->g == 0) {
                xindex++;
            }
            if(col == imageWidth-1)
            {
                if (xindex == col) {
                    
                    y = row;
                    
                    //                    NSLog(@"+Y:%d row:%d",y,row);
                    if(goThrough == NO)
                    {
                        //                        NSLog(@"inert %d",y);
                        yarray = [yarray arrayByAddingObject:[NSNumber numberWithInt:y]];
                        miny = MIN(miny, y);
                        maxy = MAX(maxy, y);
                    }
                    goThrough = YES;
                    hasObject = NO;
                }
                else
                {
                    //                    y = row;
                    if(hasObject == NO)
                    {
                        //                        NSLog(@"inert %d",y);
                        yarray = [yarray arrayByAddingObject:[NSNumber numberWithInt:y]];
                        
                        miny = MIN(miny, y);
                        maxy = MAX(maxy, y);
                    }
                    hasObject = YES;
                    goThrough = NO;
                    //                    NSLog(@"-Y:%d row:%d",y,row);
                }
                
            }
            
        }
    }
    
//    yarray = [self mergeNumberArray:yarray];
    
    
    int fromY = 0;
    int toY = 0;
    
    int x = 0;
    
    goThrough = NO;
    hasObject = NO;
    NSArray* gArray = @[];
    
    
    for (NSNumber* yNumber in yarray) {
        toY =yNumber.intValue;
//        NSLog(@"from:%d to %d",fromY,toY);
        NSArray* xarray = @[];
        for (int col =0; col < imageWidth; col++) {
            
            int yindex = 0;
            int yh =   toY - fromY;
            
            for (int row = fromY; row < toY; row++) {
                
                pixlPos = row*imageWidth + col;
                uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
                
                
                
                ColorARGB *ptr = (ColorARGB *)pCurPixel;
                if (ptr->r == 0 && ptr->b == 0 && ptr->g == 0) {
                    yindex++;
                }
                if(row == toY-1)
                {
                    if (yindex == yh) {
                        x = col;
                        
//                        NSLog(@"+X:%d col:%d",x,col);
                        if(goThrough == NO)
                        {
                            NSLog(@"inert %d",x);
                            xarray = [xarray arrayByAddingObject:[NSNumber numberWithInt:x]];
                        }
                        goThrough = YES;
                        hasObject = NO;
                    }
                    else
                    {
                        //                    y = row;
                        if(hasObject == NO)
                        {
//                            NSLog(@"inert %d",x);
                            xarray = [xarray arrayByAddingObject:[NSNumber numberWithInt:x]];
                        }
                        hasObject = YES;
                        goThrough = NO;
//                        NSLog(@"-X:%d col:%d",x,col);
                    }
                    
                }//if
                
            }//for
        }//for col
        if(xarray.count > 0)
        {
            int i = 0;
            int oldx = 0;
            int oldstepx = 0;
            NSArray* nArray = @[];
            for (NSNumber* xN in xarray) {
                
                if(i>0)
                {
                    int stepx = xN.intValue - oldx;
                    if (oldstepx> stepx && stepx < 3) {
                        
                    }
                    else
                    {
                        if (xN.intValue < imageWidth - 9) {
                            nArray = [nArray arrayByAddingObject:xN];
                        }
                        oldstepx = stepx;
                    }
                    
                }
                else
                {
                    if (xN.intValue < imageWidth - 9) {
                        nArray = [nArray arrayByAddingObject:xN];
                    }
                    
                }
                oldx = xN.intValue;
                i++;
            }
            
            if(nArray.count > 0)
            {
                NSDictionary* subDic =  @{
                                          @"from":[NSNumber numberWithInt:fromY],
                                          @"to":[NSNumber numberWithInt:toY],
                                          @"x":nArray,
                                          };
                
                
                gArray = [gArray arrayByAddingObject:subDic];
            }
            
        }
        
        fromY = toY;
    }
    
    int fromRow = 0;
    int toRow =0;
    
    int fromCol = 0;
    int toCol =0;
    int stepH;
    NSArray* lineObjectsArray = @[];
    for (NSDictionary* xDic in gArray) {
        
        NSArray* xposArray = xDic[@"x"];
        fromRow = [xDic[@"from"] intValue];
        toRow  = [xDic[@"to"] intValue];
        y = fromRow;
        
        NSArray* finalArray = @[];
        
        for (NSNumber* vNumber in xposArray) {
            toCol =vNumber.intValue;
            
            goThrough = NO;
            hasObject = NO;
            
            NSArray* subyarray = @[];
            
            stepH = toCol - fromCol;
            subyarray = [self checkHlineAtRectFrom:fromRow To:toRow From:fromCol to:toCol];
            if (subyarray.count > 1) {
                NSDictionary* tDic = @{
                                       @"fromX":[NSNumber numberWithInt:fromCol],
                                       @"toX":[NSNumber numberWithInt:toCol],
                                       @"fromY":[NSNumber numberWithInt:fromRow],
                                       @"toY":[NSNumber numberWithInt:toRow],
                                       @"lineY":subyarray,
                                       };
                finalArray = [finalArray arrayByAddingObject:tDic];
            }
//            NSLog(@"%@:from:%d to:%d",subyarray,fromCol,toCol);
            fromCol = toCol;
        }//for3
        
        lineObjectsArray = [lineObjectsArray arrayByAddingObject:finalArray];
        
    }
    
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    free(rgbImageBuf);// 创建dataProvider时已提供释放函数，这里不用free
//    NSLog(@"%@",gArray);
    return @{@"h":yarray,
             @"v":gArray,
             @"f":lineObjectsArray,
             };
}

-(NSArray*)checkHlineAtRectFrom:(int)fromRow To:(int)toRow From:(int)fromCol to:(int)toCol
{
    int pixlPos;
    BOOL goThrough = NO;
    BOOL hasObject =NO;
    int stepH = toCol - fromCol;
    int y = fromRow;
    int x = fromCol;
    NSArray* subyarray = @[];
    
    BOOL findFirst = NO;
    for (int row = fromRow; row < toRow+1&&row < imageHeight; row++) {
        
        int xindex = 0;
        int objects = 0;
        for (int col =fromCol; col < toCol; col++) {
            
            pixlPos = row*imageWidth + col;
            uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
            
            
            
            ColorARGB *ptr = (ColorARGB *)pCurPixel;
            if (ptr->r == 0 && ptr->b == 0 && ptr->g == 0) {
                xindex++;
            }
            else
            {
                objects++;
            }
            if(col == toCol-1)
            {
                if (xindex < stepH) {
                    
                    y = row;
                    
                    
                    
//                    NSLog(@"+Y:%d row:%d",y,row);
                    if(goThrough == NO)
                    {
                        //                        NSLog(@"inert %d",y);
                        subyarray = [subyarray arrayByAddingObject:[NSNumber numberWithInt:row]];
                        
                    }
                    else
                    {
                        if(row == toRow-1)
                        {
                            subyarray = [subyarray arrayByAddingObject:[NSNumber numberWithInt:row]];
                        }
                    }
                    goThrough = YES;
                    hasObject = NO;
                    findFirst = YES;
                }
                else
                {
                    
                    if(hasObject == NO)
                    {
                        //                        NSLog(@"inert %d",y);
                        
                        if (findFirst == YES) {
                            subyarray = [subyarray arrayByAddingObject:[NSNumber numberWithInt:row]];
                        }
                        
                    }
                    else
                    {
                        //                                if(row == toRow-1)
                        //                                {
                        //                                    subyarray = [subyarray arrayByAddingObject:[NSNumber numberWithInt:y]];
                        //                                }
                    }
                    
                    hasObject = YES;
                    goThrough = NO;
//                    NSLog(@"-Y:%d row:%d",y,row);
                }
                
            }//if
            
        }//for1
    }//for2
    
    return subyarray;
}
- (NSImage *) imageBgTransparentWith:(CGFloat)transMaxH :(CGFloat)transMinH :(CGFloat)transMaxV :(CGFloat)transMinV
{
    
    // 分配内存
    //    int top = 100;
    //    int step = 20;
    imageWidth = self.size.width;
    imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    rgbImageBuf2 = (uint32_t *)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    context = CGBitmapContextCreate(rgbImageBuf2, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    
    uint32_t *pCurPtr = rgbImageBuf;
    uint32_t *pCurPtr2 = rgbImageBuf2;
    int pixlPos = 0;
    for (int row = 0; row < imageHeight; row++) {
        for (int col =0; col < imageWidth; col++) {
            
            pixlPos = row*imageWidth + col;
            uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
            
            uint8_t *ptr = (uint8_t *)pCurPixel;
            uint32_t *avgP = [self avgColor:row :col];
            
            
        }
    }
    int searchStep = 120;
    int searchbeginx = 0;
    int searchbeginy = 0;
    int searchendx = searchbeginx + searchStep;
    int searchendy = searchendx + searchStep;
    
    //    CGFloat maxtH,mintH,maxtV,mintV;
    maxtH = 0;
    mintV = 255;
    maxtV = 0;
    mintH = 255;
    
    [self findColorFieldAt:searchbeginx :searchbeginy :searchStep];
    
    searchbeginx = imageWidth-searchStep;
    if (searchbeginx < 0) {
        searchbeginx = 0;
    }
    searchbeginy = 0;
    searchendx = searchbeginx+searchStep;
    searchendy = searchbeginy+searchStep;
    //    [self findColorFieldAt:searchbeginx :searchbeginy :searchStep];
    
    [self partialAlphaEnableWith:transMaxH :transMinH :transMaxV :transMinV];
    
    
    for (int row = 0; row < imageHeight; row++) {
        for (int col =0; col < imageWidth; col++) {
            
            [self egdeAvgColor:row :col];
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf2, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageWidth, imageHeight)];
    
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    free(rgbImageBuf);// 创建dataProvider时已提供释放函数，这里不用free
    return resultNSImage;
}
- (ColorHVS) imageWith:(CGPoint)location
{
    
    
    imageWidth = self.size.width;
    imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    int row = location.y;
    int col = location.x;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    context = CGBitmapContextCreate(rgbImageBuf2, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    
    //    CGFloat maxtH,mintH,maxtV,mintV;
    maxtH = 0;
    mintV = 255;
    maxtV = 0;
    mintH = 255;
    
    
    ColorHVS color =  [self hvsColor:row :col];
    
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return color;
    
    
}
-(ColorHVS) hvsColor:(const int)row :(const int) col
{
    
    
    int x,y,xend,yend;
    ColorHVS color;
    color.h = 0;
    color.s = 0;
    color.v = 0;
    
    if(row < 0 || col < 0)
        return color;
    
    if(row > imageHeight || col > imageWidth)
        return color;
    
    
    x = col - matrix2/2;
    y = row - matrix2/2;
    xend = x+matrix2;
    yend = y+matrix2;
    imageWidth = self.size.width;
    imageHeight = self.size.height;
    if(x<0)
        x=0;
    if(y<0)
        y=0;
    if(xend >= imageWidth)
        xend = imageWidth-1;
    
    if(yend >= imageHeight)
        yend = imageHeight-1;
    int count = 0;
    int r,g,b;
    r = 0;
    g = 0;
    b = 0;
    BOOL findAlpha = NO;
    BOOL findNoAlpha = NO;
    for (int i = x; i<xend ; i++) {
        for (int j = y; j<yend; j++) {
            count++;
            
            int pPos = i + j*imageWidth;
            uint32_t *tPixel =  &rgbImageBuf[pPos];
            ColorARGB *p = (ColorARGB *)tPixel;
            
            r += p->r;
            g += p->g;
            b += p->b;
            if(p->a == 0)
                findAlpha = YES;
            else
                findNoAlpha = YES;
        }
    }
    
    
    r = r/count;
    b = b/count;
    g = g/count;
    int pixlPos = row*imageWidth + col;
    uint32_t *pCurPixel =  &rgbImageBuf[pixlPos];
    ColorARGB *ptr = (ColorARGB *)pCurPixel;
    ptr->b = b;
    ptr->g = g;
    ptr->r = r;
    
    float maxv = MAX(ptr->r, MAX(ptr->g, ptr->b));
    float minv = MIN(ptr->r, MIN(ptr->g, ptr->b));
    int hv = 0;
    if(maxv == ptr->r)
    {
        hv = ((float)(ptr->g-ptr->b))/(maxv -minv)*60;
    }
    if(maxv == ptr->g)
    {
        hv =  120 + ((float)(ptr->b - ptr->r))/(maxv -minv)*60;
    }
    if(maxv == ptr->b)
    {
        hv =  240 + ((float)(ptr->r - ptr->g))/(maxv -minv)*60;
    }
    
    if (hv < 0)
        hv = hv+ 360;
    
    color.h = hv;
    color.v = maxv;
    
    
    
    return color;
}
- (NSImage *) imageBgTransparentWithRadiur:(int)r
{
    
    // 分配内存
    //    int top = 100;
    //    int step = 20;
    matrixV = r;
    imageWidth = self.size.width;
    imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    context = CGBitmapContextCreate(rgbImageBuf2, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    
    uint32_t *pCurPtr = rgbImageBuf;
    uint32_t *pCurPtr2 = rgbImageBuf2;
    int pixlPos = 0;
    for (int row = 0; row < imageHeight; row++) {
        for (int col =0; col < imageWidth; col++) {
            
            pixlPos = row*imageWidth + col;
            
            [self avgColor:row :col];
            
            
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
   NSImage* resultNSImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(imageWidth, imageHeight)];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    return resultNSImage;
}

/** 颜色变化 */
static void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void *)data);
}
@end
@interface MImageView ()
{
    CGPoint touchBeginPoint;
    CGPoint touchEndPoint;
    
    __block CGFloat v;
    __block BOOL moved;
    
    CGFloat indexValue;
    
    CGFloat touchX;
}
@end
@implementation MImageView
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint p = [[touches anyObject] locationInView:self];
//    touchBeginPoint.x = p.x;
//    touchBeginPoint.y = p.y;
//}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    //    CGPoint p = [[touches anyObject] locationInView:self];
//    //    CGFloat detx,dety;
//    //    detx = p.x - touchBeginPoint.x;
//    //    dety = p.y - touchBeginPoint.y;
//    //    CGFloat x,y,w,h;
//    //    x = self.frame.origin.x;
//    //    y = self.frame.origin.y;
//    //    w = self.frame.size.width;
//    //    h = self.frame.size.height;
//    //
//    ////    self.frame  = CGRectMake(x+detx, y+dety, w, h);
//    //    //    touchBeginPoint.x = p.x;
//    //    //    touchBeginPoint.y = p.y;
//    //
//    //    CGFloat imagew = self.image.size.width;
//    //    CGFloat ratio;
//    //    CGFloat scale;
//    //    if(imagew == 0)
//    //    {
//    //        ratio = 1.0;
//    //        scale = 1.0;
//    //    }
//    //    else
//    //    {
//    //        ratio = self.image.size.height/self.image.size.width;
//    //        scale = w/imagew;
//    //    }
//    //
//    //    CGPoint location;
//    //    location.x = p.x/scale;
//    //    location.y = p.y/scale;
//
//
//
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    CGPoint p = [[touches anyObject] locationInView:self];
//    CGFloat detx,dety;
//    detx = p.x - touchBeginPoint.x;
//    dety = p.y - touchBeginPoint.y;
//    CGFloat x,y,w,h;
//    x = self.frame.origin.x;
//    y = self.frame.origin.y;
//    w = self.frame.size.width;
//    h = self.frame.size.height;
//
//
//    CGFloat imagew = self.image.size.width;
//    CGFloat ratio;
//    CGFloat scale;
//    if(imagew == 0)
//    {
//        ratio = 1.0;
//        scale = 1.0;
//    }
//    else
//    {
//        ratio = self.image.size.height/self.image.size.width;
//        scale = w/imagew;
//    }
//
//    CGPoint location;
//    location.x = p.x/scale;
//    location.y = p.y/scale;
//    ColorHVS color =  [self.image imageWith:location];
//
//
//
//    if([self.delegate respondsToSelector:@selector(drawLocation:with:)])
//    {
//        CGPoint color_p;
//        color_p.x = color.h;
//        color_p.y = color.v;
//        [self.delegate drawLocation:location with:color_p];
//    }
//
//}
-(void)calculateGrid
{
    
}
-(void)leftUpCornerEliminate
{
    CGPoint p;
    CGFloat x,y,w,h;
    x = self.frame.origin.x;
    y = self.frame.origin.y;
    w = self.frame.size.width;
    h = self.frame.size.height;
    p.x = w/4.0;
    p.y = h/4.0;
    CGFloat detx,dety;
    detx = 0;
    dety = 0;
    
    CGFloat imagew = self.image.size.width;
    CGFloat ratio;
    CGFloat scale;
    if(imagew == 0)
    {
        ratio = 1.0;
        scale = 1.0;
    }
    else
    {
        ratio = self.image.size.height/self.image.size.width;
        scale = w/imagew;
    }
    
    CGPoint location;
    location.x = p.x/scale;
    location.y = p.y/scale;
    ColorHVS color =  [self.image imageWith:location];
    
    if([self.delegate respondsToSelector:@selector(locationChanged:)])
    {
        location.x = color.h;
        location.y = color.v;
        [self.delegate locationChanged:location];
    }
}
-(void)rightUpCornerEliminate
{
    CGPoint p;
    CGFloat x,y,w,h;
    x = self.frame.origin.x;
    y = self.frame.origin.y;
    w = self.frame.size.width;
    h = self.frame.size.height;
    p.x = 3*w/4.0;
    p.y = h/4.0;
    CGFloat detx,dety;
    detx = 0;
    dety = 0;
    
    
    //    self.frame  = CGRectMake(x+detx, y+dety, w, h);
    //    touchBeginPoint.x = p.x;
    //    touchBeginPoint.y = p.y;
    //    if([self.delegate respondsToSelector:@selector(locationChanged:)])
    //    {
    //        [self.delegate locationChanged:p];
    //    }
    CGFloat imagew = self.image.size.width;
    CGFloat ratio;
    CGFloat scale;
    if(imagew == 0)
    {
        ratio = 1.0;
        scale = 1.0;
    }
    else
    {
        ratio = self.image.size.height/self.image.size.width;
        scale = w/imagew;
    }
    
    CGPoint location;
    location.x = p.x/scale;
    location.y = p.y/scale;
    ColorHVS color =  [self.image imageWith:location];
    
    if([self.delegate respondsToSelector:@selector(locationChanged:)])
    {
        location.x = color.h;
        location.y = color.v;
        [self.delegate locationChanged:location];
    }
}
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//}
@end

