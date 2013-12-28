//
//  HttpManage.h
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHelper.h"

@protocol HttpManageDelegate <NSObject>

@optional

- (CGFloat)progressNumber:(HttpHelper *)hh;

@end


@interface HttpManage : NSObject <httpHelperDelegate>
{
    NSMutableDictionary *_downloadQueue;
    NSMutableDictionary *_resultDict;
}

@property (nonatomic, strong)NSMutableDictionary *downloadQueue;
@property (nonatomic, strong)NSMutableDictionary *resultDict;
@property (nonatomic, weak)id <HttpManageDelegate> delegate;

+ (HttpManage *)shareManage;

- (void)addDownloadToQueueByGet:(NSString *)url;

- (void)addDownloadToQueueByPost:(NSString *)url dict:(NSDictionary *)dict;
- (void)addRegisterToQueueByPost:(NSString *)url dict:(NSDictionary *)dict;

- (void)addDownloadToQueueByGetWithUserLabel:(NSString *)url;

- (void)addDownloadToQueueByPostWithUserLabel:(NSString *)url dict:(NSDictionary *)dict;

+ (int)dataNetworkTypeFromStatusBar;


@end
