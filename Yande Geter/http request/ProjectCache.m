//
//  ProjectCache.m
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "ProjectCache.h"

static ProjectCache *gl_cache = nil;

@implementation ProjectCache

+ (ProjectCache *)shareCache
{
    if (!gl_cache)
    {
        gl_cache = [[self alloc]init];
        [gl_cache setTotalCostLimit:80*1024*1024];
        [gl_cache setCountLimit:80];
    }
    return gl_cache;
}

- (void)write:(NSData *)data forKey:(NSString *)path
{
    if(data==nil){
        return;
    }else{
        [gl_cache setObject:data forKey:path];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
        }); 
    }

}

- (NSData *)readForKey:(NSString*)path
{
    if(path==nil)
    {
        return nil;
    }
    NSData *cacheData = [gl_cache objectForKey:path];
    if(cacheData)
    {
        NSLog(@"get data from cache");
        return cacheData;
    }
    else
    {
        return nil;
    }
//    else
//    {
//        NSLog(@"miss data from cache");
//       __block NSData *fileData;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            fileData =  [[NSFileManager defaultManager] contentsAtPath:path];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(fileData)
//                {
//                    [gl_cache setObject:fileData forKey:path];
//                }
//            });
//
//        });
//        return fileData;
//
//    }
}

@end
