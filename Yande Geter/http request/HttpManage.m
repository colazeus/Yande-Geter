//
//  HttpManage.m
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "HttpManage.h"




static HttpManage *gl_HttpManager = nil;

@implementation HttpManage

@synthesize resultDict = _resultDict,downloadQueue = _downloadQueue;

+ (HttpManage *)shareManage
{
    if (!gl_HttpManager)
    {
        gl_HttpManager = [[HttpManage alloc]init];
    }
    return gl_HttpManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.downloadQueue = [[NSMutableDictionary alloc]init];
        self.resultDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)addDownloadToQueueByGet:(NSString *)url
{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    httphelper.delegate = self;
    httphelper.url = url;
    [httphelper downloadFromUrlByGet:url];
    [_downloadQueue setObject:httphelper forKey:url];
//    if ([_downloadQueue count])
//    {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    }

}
- (void)addRegisterToQueueByPost:(NSString *)url dict:(NSDictionary *)dict
{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    httphelper.delegate = self;
    httphelper.url = url;
    [httphelper registerFromUrlByPost:url dict:dict type:POST_TYPE_TABLE];
    [_downloadQueue setObject:httphelper forKey:url];
}

- (void)addDownloadToQueueByPost:(NSString *)url dict:(NSDictionary *)dict
{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    httphelper.delegate = self;
    httphelper.url = url;
    NSInteger PostType=POST_TYPE_TABLE;
    NSArray *keys= [dict allKeys];
    for(int i=0;i<[keys count];i++)
    {
        NSString *key=[keys objectAtIndex:i];
        if([[dict objectForKey:key] isKindOfClass:[NSData class]])
        {
            PostType=POST_TYPE_FILE;
        }
        //文章传图
        if ([key isEqualToString:@"Filedata"]) {
            PostType=POST_TYPE_PIC_FILE;
        }
    }
    [httphelper downloadFromUrlByPost:url dict:dict type:PostType];
    [_downloadQueue setObject:httphelper forKey:url];
}
#pragma mark -
#pragma mark download with cookie
- (void)addDownloadToQueueByGetWithUserLabel:(NSString *)url
{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    httphelper.delegate = self;
    httphelper.url = url;
    [httphelper downloadFromUrlByGetWithUserLabel:url];
    [_downloadQueue setObject:httphelper forKey:url];
    //    if ([_downloadQueue count])
    //    {
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    }
    
}
- (void)addDownloadToQueueByPostWithUserLabel:(NSString *)url dict:(NSDictionary *)dict
{
    HttpHelper *httphelper = [[HttpHelper alloc]init];
    httphelper.delegate = self;
    httphelper.url = url;
    NSInteger PostType=POST_TYPE_TABLE;
    NSArray *keys= [dict allKeys];
    for(int i=0;i<[keys count];i++)
    {
        NSString *key=[keys objectAtIndex:i];
        if([[dict objectForKey:key] isKindOfClass:[NSData class]])
        {
            PostType=POST_TYPE_FILE;
        }
    }
    [httphelper downloadFromUrlByPostWithUserLabel:url dict:dict type:PostType];
    [_downloadQueue setObject:httphelper forKey:url];
}
#pragma mark end
#pragma mark -

- (void)downloadFinished:(HttpHelper *)hh
{
    [self.resultDict setObject:hh.dataDownload forKey:hh.url];
    [[NSNotificationCenter defaultCenter]postNotificationName:hh.url object:hh.url];
}

+ (int)dataNetworkTypeFromStatusBar {
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil)
    {
        netType = NETWORK_TYPE_NONE;
    }
    else
    {
        int n = [num intValue];
        if (n == 1)
        {
            netType = NETWORK_TYPE_WIFI;
        }
        else if (n == 2)
        {
            netType = NETWORK_TYPE_2G;
        }
        else if (n == 3)
        {
            netType = NETWORK_TYPE_3G;
        }
        else
        {
            netType = NETWORK_TYPE_NONE;
        }
    }
    
    return netType;
}



@end
