//
//  PreviewImageDownload.h
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-22.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewImageDownload : UIImageView
@property (nonatomic,assign)id delegate;

- (void)imageDownloadFromUrlPre:(NSString *)url size:(CGSize)size;
- (void)imageDownloadFromUrlCache:(NSString *)url size:(CGSize)size;
@end
