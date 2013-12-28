//
//  MainImageView.m
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-22.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import "MainImageView.h"
#import "ProjectCache.h"
#import "NSString+Hashing.h"
#import "UIImage+ScaleImageFitType.h"


@implementation MainImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)imageDownload:(NSString *)url
{
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [self filePath:[newUrl
                                     MD5Hash]];
    
    ProjectCache *cache = [ProjectCache shareCache];
    
    __block NSData *fileData;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fileData)
            {
                [cache setObject:fileData forKey:path];
                UIImage *image = [UIImage imageWithData:fileData];
                if (image != Nil)
                {
                    self.image = image;
                }
            }
            if(!fileData)
            {
                NSLog(@"downLoad");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    YandeAppDelegate * app = APPDELEGATE;
                    app.netNumber ++;
                    if (app.netNumber != 0)
                    {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        
                    }
                    
                    UIImage * image = nil;
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newUrl]];
                    image = [UIImage imageWithData:data];
                    NSData *dd;
                    dd = UIImagePNGRepresentation(image);
                    if (dd == nil) {
                        dd = UIImageJPEGRepresentation(image, 1.0f);
                    }
                    [cache write:dd forKey:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        YandeAppDelegate * app = APPDELEGATE;
                        app.netNumber --;
                        if (app.netNumber == 0)
                        {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        }
                        NSLog(@"last one is %@",self.lastOne);
                        NSLog(@"url is :%@",url);
                        if ([self.lastOne isEqualToString:url])
                        {
                            self.image = image;
                        }
                    });
                });
                
            }
        });
        
    });
    
}



#pragma mark end
#pragma mark -
- (NSString *)filePath:(NSString *)fileName
{
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Library/Caches"];
    if (fileName && [fileName length]!=0)
    {
        path = [path stringByAppendingPathComponent:fileName];
    }
    return path;
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
