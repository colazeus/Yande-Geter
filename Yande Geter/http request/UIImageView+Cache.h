//
//  UIImageView+Cache.h
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-6.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)

- (void)imageDownloadFromUrl:(NSString *)url size:(CGSize)size;
- (void)imageDownloadFromOldUrl:(NSString *)url size:(CGSize)size;
- (void)imageDownloadWithSameProportionFromUrl:(NSString *)url;
- (void)imageDownloadFromUrlWithNoBug:(NSString *)url size:(CGSize)size;

@end
