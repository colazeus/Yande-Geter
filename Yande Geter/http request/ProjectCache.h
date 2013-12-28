//
//  ProjectCache.h
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectCache : NSCache

+ (ProjectCache *)shareCache;

- (void)write:(NSData*)data forKey:(NSString*)path;

- (NSData *)readForKey:(NSString*)path;

@end
