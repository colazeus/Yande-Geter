//
//  UIImageView+Cache.m
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-6.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "ProjectCache.h"
#import "NSString+Hashing.h"
#import "UIImage+ScaleImageFitType.h"


@implementation UIImageView (Cache)


- (void)imageDownloadFromUrlWithNoBug:(NSString *)url size:(CGSize)size{
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        YandeAppDelegate * app = APPDELEGATE;
        app.netNumber ++;
        if (app.netNumber != 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
        }
        
        UIImage * image = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newUrl]];
        if (data != nil)
        {
            image = [UIImage imageWithData:data];
            image = [image scaleImageToSize:size];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            YandeAppDelegate * app = APPDELEGATE;
            app.netNumber --;
            if (app.netNumber == 0)
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            }
            if (image != nil)
            {
                self.image = image;
            }
        });
    });


}

- (void)imageDownloadFromUrl:(NSString *)url size:(CGSize)size
{
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [self filePath:[newUrl
                                     MD5Hash]];
    
    ProjectCache *cache = [ProjectCache shareCache];
     NSData *data = [cache readForKey:path];
    if (data)
    {
        self.image = [UIImage imageWithData:data];
        return;
    }
    __block NSData *fileData;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fileData)
            {
                UIImage *image = [UIImage imageWithData:fileData];
                self.image = image;
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
                        NSLog(@"download over");
                        YandeAppDelegate * app = APPDELEGATE;
                        app.netNumber --;
                        if (app.netNumber == 0)
                        {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                        }
                        self.image = image;
                    });
                });
                
            }
        });
        
    });
    
}
#pragma mark -
#pragma mark user center
- (void)imageDownloadFromOldUrl:(NSString *)url size:(CGSize)size
{
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [self filePath:[newUrl
                                     MD5Hash]];
    
    ProjectCache *cache = [ProjectCache shareCache];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
            UIImage *image;
            if (fileData != nil)
            {
                image = [UIImage imageWithData:fileData];
                [cache setObject:fileData forKey:path];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image != nil)
                {
                    self.image=image;
                }
                //                [cache setObject:fileData forKey:path];
            });
            
        });
        
    }else{
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
            if (data != nil)
            {
                image = [UIImage imageWithData:data];
                image = [image scaleImageToSize:size];
                //                NSData *dd = UIImagePNGRepresentation(image);
                NSData *dd = UIImageJPEGRepresentation(image, 1);
                [cache write:dd forKey:path];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                YandeAppDelegate * app = APPDELEGATE;
                app.netNumber --;
                if (app.netNumber == 0)
                {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                }
                if (image != nil)
                {
                    self.image = image;
                }
            });
        });
    }
}
- (void)imageDownloadWithSameProportionFromUrl:(NSString *)url 
{
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [self filePath:[newUrl
                                     MD5Hash]];
    
    ProjectCache *cache = [ProjectCache shareCache];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
            UIImage *image;
            if (fileData != nil)
            {
                image = [UIImage imageWithData:fileData];
                [cache setObject:fileData forKey:path];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image != nil)
                {
                    self.image=image;
                }
                //                [cache setObject:fileData forKey:path];
            });
            
        });
        
    }else{
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
            if (data != nil)
            {
                image = [UIImage imageWithData:data];
//                image = [image scaleImageToSize:size];
                NSData *dd = UIImagePNGRepresentation(image);
//                NSData *dd = UIImageJPEGRepresentation(image, 0.5);
                [cache write:dd forKey:path];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                YandeAppDelegate * app = APPDELEGATE;
                app.netNumber --;
                if (app.netNumber == 0)
                {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                }
                if (image != nil)
                {
                    self.image = image;
                }
            });
        });
    }
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


@end
