//
//  MainImageView.h
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-22.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainImageView : UIImageView
@property (nonatomic,strong)NSString *lastOne;
- (void)imageDownload:(NSString *)url;

- (void)readImageFromData:(NSString *)url;

@end
