//
//  UIImage+ScaleImageFitType.h
//  MYButton
//
//  Created by 班文龙 on 13-8-6.
//  Copyright (c) 2013年 MFWenLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleImageFitType)
//把图片按比例扩大/缩小到View的宽度/高度，居中显示
- (UIImage *)scaleImageFitCenterToSize:(CGSize)newSize;

//按图片的原来size居中显示，当图片长/宽超过View的长/宽，则截取图片的居中部分显示
- (UIImage *)scaleImageCenterToSize:(CGSize)newSize;

//按比例扩大/缩小图片的size居中显示，使得图片长(宽)等于或大于View的长(宽)
- (UIImage *)scaleImageCenterCropToSize:(CGSize)newSize;

//  将图片的内容完整居中显示，通过按比例缩小或原来的size使得图片长/宽等于或小于View的长/宽
- (UIImage *)scaleImageCenterInsideToSize:(CGSize)newSize;

//把图片按比例扩大/缩小到View的宽度/高度，顶部显示
- (UIImage *)scaleImageFitStartToSize:(CGSize)newSize;

//把图片按比例扩大/缩小到View的宽度/高度，底部显示
- (UIImage *)scaleImageFitEndToSize:(CGSize)newSize;

//按图片缩小到目标长宽
- (UIImage *)scaleImageToSize:(CGSize)newSize;

- (UIImage *)scaleImagetoWidth:(NSInteger)width;
@end
