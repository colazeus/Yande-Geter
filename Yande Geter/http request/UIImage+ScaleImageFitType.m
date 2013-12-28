//
//  UIImage+ScaleImageFitType.m
//  MYButton
//
//  Created by 班文龙 on 13-8-6.
//  Copyright (c) 2013年 MFWenLong. All rights reserved.
//

#import "UIImage+ScaleImageFitType.h"

@implementation UIImage (ScaleImageFitType)
- (UIImage *)scaleImageFitCenterToSize:(CGSize)newSize
{
    
    CGSize origImageSize = [self size];
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    float ratio = MIN(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = ratio * origImageSize.width;
    
    thumbnailImag.size.height = ratio * origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = (newRect.size.height - thumbnailImag.size.height) / 2.0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
- (UIImage *)scaleImageCenterToSize:(CGSize)newSize
{
    CGSize origImageSize = [self size];
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    thumbnailImag.size.width = origImageSize.width;
    
    thumbnailImag.size.height = origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = (newRect.size.height - thumbnailImag.size.height) / 2.0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return small;
    
}
- (UIImage *)scaleImageCenterCropToSize:(CGSize)newSize
{
    CGSize origImageSize = [self size];
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    float ratio = MAX(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = ratio * origImageSize.width;
    
    thumbnailImag.size.height = ratio * origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = (newRect.size.height - thumbnailImag.size.height) / 2.0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
- (UIImage *)scaleImageCenterInsideToSize:(CGSize)newSize
{
    CGSize origImageSize = [self size];
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    float ratio = MIN(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    if (ratio>1) {
        ratio=1;
    }
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = ratio * origImageSize.width;
    
    thumbnailImag.size.height = ratio * origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = (newRect.size.height - thumbnailImag.size.height) / 2.0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
- (UIImage *)scaleImageFitStartToSize:(CGSize)newSize
{
    CGSize origImageSize = [self size];
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    float ratio = MAX(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = ratio * origImageSize.width;
    
    thumbnailImag.size.height = ratio * origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = 0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
- (UIImage *)scaleImageFitEndToSize:(CGSize)newSize
{
    CGSize origImageSize = [self size];
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    float ratio = MAX(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = ratio * origImageSize.width;
    
    thumbnailImag.size.height = ratio * origImageSize.height;
    
    thumbnailImag.origin.x = (newRect.size.width - thumbnailImag.size.width) / 2.0;
    
    thumbnailImag.origin.y = newRect.size.height-thumbnailImag.size.height;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
-(UIImage*)scaleImageToSize:(CGSize)newSize
{
    
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(newSize.width*2, newSize.height*2);
    
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = newRect.size.width;
    
    thumbnailImag.size.height = newRect.size.height;
    
    thumbnailImag.origin.x = 0;
    
    thumbnailImag.origin.y = 0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
- (UIImage *)scaleImagetoWidth:(NSInteger)width
{
    if (self.size.width<width) {
        return self;
    }
    CGFloat selfHeight=self.size.height*width/self.size.width;
    CGRect newRect;
    newRect.origin=CGPointZero;
    newRect.size=CGSizeMake(width,selfHeight);
    
    
    UIGraphicsBeginImageContext(newRect.size);
    
    CGRect thumbnailImag;
    
    thumbnailImag.size.width = newRect.size.width;
    
    thumbnailImag.size.height = newRect.size.height;
    
    thumbnailImag.origin.x = 0;
    
    thumbnailImag.origin.y = 0;
    
    
    [self drawInRect:thumbnailImag];
    
    UIImage * small = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return small;
}
@end
