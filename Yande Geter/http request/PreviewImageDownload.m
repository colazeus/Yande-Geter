//
//  PreviewImageDownload.m
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-22.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import "PreviewImageDownload.h"
#import "ProjectCache.h"
#import "NSString+Hashing.h"
#import "UIImage+ScaleImageFitType.h"
#import "RootViewController.h"

static dispatch_group_t group = Nil;
static NSInteger semaphore = 0;


@implementation PreviewImageDownload

+(dispatch_group_t)shareGroup
{
    if (group == Nil)
    {
        group = dispatch_group_create();
    }
    return group;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)imageDownloadFromUrlPre:(NSString *)url size:(CGSize)size
{
    semaphore ++;
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
    
    dispatch_group_async([PreviewImageDownload shareGroup], dispatch_get_global_queue(0, 0), ^{
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
//                    [cache write:dd forKey:path];
                    
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
            semaphore --;
            if (semaphore == 0)
            {
                dispatch_group_notify([PreviewImageDownload shareGroup], dispatch_get_main_queue(), ^{
                    NSLog(@"which ");
                    RootViewController *root = (RootViewController *)self.delegate;
                    root.downLoadIsOver = YES;

                });
                [self performSelector:@selector(waitChange) withObject:nil afterDelay:1];
            }
        });
        
    });
    
}

- (void)waitChange
{
    RootViewController *root = (RootViewController *)self.delegate;
    root.wait = YES;
}



- (void)imageDownloadFromUrlCache:(NSString *)url size:(CGSize)size
{
    semaphore ++;
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
    
    dispatch_group_async([PreviewImageDownload shareGroup], dispatch_get_global_queue(0, 0), ^{
        fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(fileData)
            {
                UIImage *image = [UIImage imageWithData:fileData];
                NSLog(@"filedata ");
                [cache write:fileData forKey:path];
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
            semaphore --;
            if (semaphore == 0)
            {
                dispatch_group_notify([PreviewImageDownload shareGroup], dispatch_get_main_queue(), ^{
                    NSLog(@"which ");
                    RootViewController *root = (RootViewController *)self.delegate;
                    root.downLoadIsOver = YES;
                    
                });
                [self performSelector:@selector(waitChange) withObject:nil afterDelay:1];
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
