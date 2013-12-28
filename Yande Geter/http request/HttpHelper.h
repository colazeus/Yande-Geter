//
//  HttpHelper.h
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HttpHelper;


@protocol httpHelperDelegate <NSObject>

- (void)downloadFinished:(HttpHelper *)hh;

@end


@interface HttpHelper : NSObject <NSURLConnectionDelegate,NSStreamDelegate>
{
    NSURLConnection *_httpConnection;
    NSMutableData *_dataDownload;
    NSString *_url;
}

@property (nonatomic, strong) NSURLConnection *httpConnection;
@property (nonatomic, strong) NSMutableData *dataDownload;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, weak) id <httpHelperDelegate> delegate;
@property (nonatomic, assign) CGFloat dataTotalLength;
@property (nonatomic, assign) CGFloat progressNum;
@property (nonatomic, strong) NSInputStream *uploadFileInputStream;
@property (nonatomic, strong) NSOutputStream *mediaFileOutputStream;

- (void)downloadFromUrlByGet:(NSString *)url;
- (void)downloadFromUrlByPost:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType;
- (void)registerFromUrlByPost:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType;

- (void)downloadFromUrlByGetWithUserLabel:(NSString *)url;
- (void)downloadFromUrlByPostWithUserLabel:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType;

@end
