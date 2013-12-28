//
//  SampleImageViewCell.m
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-16.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import "PreviewImageViewCell.h"

@implementation PreviewImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[PreviewImageDownload alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_imageView];
        _imageView.image = [UIImage imageNamed:@"SampleImage"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
