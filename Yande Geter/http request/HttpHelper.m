//
//  HttpHelper.m
//  HttpHelper
//
//  Created by 鲍娟 on 13-8-5.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "HttpHelper.h"
#include <CoreFoundation/CoreFoundation.h>
#import "NSString+PRPURLAdditions.h"
@interface HttpHelper()

@end

@implementation HttpHelper

@synthesize httpConnection = _httpConnection,dataDownload = _dataDownload,url = _url;

- (id)init
{
    if (self = [super init])
    {
        self.dataDownload = [[NSMutableData alloc]init];
    }
    return self;
}


- (void)downloadFromUrlByGet:(NSString *)url
{
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSLog(@"%f",[request timeoutInterval]);
//    request.HTTPShouldHandleCookies=NO;
    self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

-(void)registerFromUrlByPost:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType
{
    NSLog(@"POST_TYPE_TABLE");
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *post = [[NSMutableString alloc]init];
    for (NSString *paramKey in dict)
    {
        if ([paramKey length] > 0)
        {
            NSStringEncoding enc=NSUTF8StringEncoding;
            //                id value;
            id encodedValue;
            NSString*value=[dict objectForKey:paramKey];
            encodedValue = [value prp_URLEncodedFormStringUsingEncoding:enc];
            NSString *paramFormat = @"%@=%@&";
            [post appendFormat:paramFormat,paramKey,encodedValue];
        }
        
    }
    post=[NSMutableString stringWithString:[post substringToIndex:[post length]-1]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
    request.HTTPShouldHandleCookies=NO;
    self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)downloadFromUrlByPost:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType
{
    if (postType == POST_TYPE_TABLE)
    {
        NSLog(@"POST_TYPE_TABLE");
        self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *post = [[NSMutableString alloc]init];
        for (NSString *paramKey in dict)
        {
            if ([paramKey length] > 0)
            {
                NSStringEncoding enc=NSUTF8StringEncoding;
//                id value;
                id encodedValue;
                NSString*value=[dict objectForKey:paramKey];
                encodedValue = [value prp_URLEncodedFormStringUsingEncoding:enc];
                NSString *paramFormat = @"%@=%@&";
                [post appendFormat:paramFormat,paramKey,encodedValue];
            }
            
        }
        post=[NSMutableString stringWithString:[post substringToIndex:[post length]-1]];

//        YandeAppDelegate *app=APPDELEGATE;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
//        NSString *cookiepre=[app._mUserInfoDictionary objectForKey:@"cookiepre"];
//        NSString *cookie_auth=[NSString stringWithFormat:@"%@auth",cookiepre];
//        NSString *cookie_saltkey=[NSString stringWithFormat:@"%@saltkey",cookiepre];
//        NSString *auth=[app._mUserInfoDictionary objectForKey:@"auth"];
//        NSString *saltkey=[app._mUserInfoDictionary objectForKey:@"saltkey"];
//        NSLog(@"auth%@saltkey=%@",auth,saltkey);
//        [request setValue:[NSString stringWithFormat:@"%@=%@;%@=%@",cookie_auth,auth,cookie_saltkey,saltkey] forHTTPHeaderField:@"cookie"];

        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];
        request.HTTPShouldHandleCookies=NO;
        self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
    else if (postType == POST_TYPE_FILE)
    {
        NSLog(@"POST_TYPE_FILE");
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //根据url初始化request
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //得到图片的data
        NSData* data = [dict objectForKey:@"portrait"];
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [dict allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //如果key不是pic，说明value是字符类型，比如name：Boris
            if(![key isEqualToString:@"portrait"])
            {
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",MPboundary];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
            }
        }
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"portrait\"; filename=\"portrait.jpg\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        request.HTTPShouldHandleCookies=NO;
         self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }else if(postType==POST_TYPE_PIC_FILE){
        NSLog(@"POST_TYPE_PIC_FILE");
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //根据url初始化request
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //得到图片的data
        NSData* data = [dict objectForKey:@"Filedata"];
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [dict allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //如果key不是pic，说明value是字符类型，比如name：Boris
            if(![key isEqualToString:@"Filedata"])
            {
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",MPboundary];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
            }
        }
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        //[body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"\r\n"];

        [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"filedata.jpg\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
//        for(int i=0;i<[keys count];i++)
//        {
//            //得到当前key
//            NSString *key=[keys objectAtIndex:i];
//            //如果key不是pic，说明value是字符类型，比如name：Boris
//            if([key isEqualToString:@"Filedata"])
//            {                //添加字段的值
//                [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
//            }
//        }

        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
       // [body appendFormat:@"%@",end];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        request.HTTPShouldHandleCookies=NO;
        self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    }
    
}
#pragma mark -
#pragma mark add urlrequest with cookie
- (void)downloadFromUrlByGetWithUserLabel:(NSString *)url
{
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    NSLog(@"%f",[request timeoutInterval]);
//    YandeAppDelegate *app=APPDELEGATE;
//    if ([app._mUserInfoDictionary objectForKey:@"cookiepre"]&&[app._mUserInfoDictionary objectForKey:@"auth"]&&[app._mUserInfoDictionary objectForKey:@"saltkey"]) {
//        NSLog(@"cookiepre存在 !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//        NSString *cookiepre=[app._mUserInfoDictionary objectForKey:@"cookiepre"];
//        NSString *cookie_auth=[NSString stringWithFormat:@"%@auth",cookiepre];
//        NSString *cookie_saltkey=[NSString stringWithFormat:@"%@saltkey",cookiepre];
//        NSString *auth=[app._mUserInfoDictionary objectForKey:@"auth"];
//        NSString *saltkey=[app._mUserInfoDictionary objectForKey:@"saltkey"];
//        NSLog(@"auth%@saltkey=%@",auth,saltkey);
//        [request setValue:[NSString stringWithFormat:@"%@=%@;%@=%@",cookie_auth,auth,cookie_saltkey,saltkey] forHTTPHeaderField:@"cookie"];
//        NSLog(@"request==%@",request);
//    }
//    request.HTTPShouldHandleCookies=NO;
    self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)downloadFromUrlByPostWithUserLabel:(NSString *)url dict:(NSDictionary *)dict type:(NSInteger)postType
{
    if (postType == POST_TYPE_TABLE)
    {
        NSLog(@"POST_TYPE_TABLE");
        self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *post = [[NSMutableString alloc]init];
        for (NSString *paramKey in dict)
        {
            if ([paramKey length] > 0)
            {
                NSStringEncoding enc=NSUTF8StringEncoding;
                //                id value;
                id encodedValue;
                NSString*value=[dict objectForKey:paramKey];
                encodedValue = [value prp_URLEncodedFormStringUsingEncoding:enc];
                NSString *paramFormat = @"%@=%@&";
                [post appendFormat:paramFormat,paramKey,encodedValue];
            }
            
        }
        post=[NSMutableString stringWithString:[post substringToIndex:[post length]-1]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
//        YandeAppDelegate *app=APPDELEGATE;
//        if ([app._mUserInfoDictionary objectForKey:@"cookiepre"]&&[app._mUserInfoDictionary objectForKey:@"auth"]&&[app._mUserInfoDictionary objectForKey:@"saltkey"]) {
//            NSLog(@"cookiepre !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//        NSString *cookiepre=[app._mUserInfoDictionary objectForKey:@"cookiepre"];
//        NSString *cookie_auth=[NSString stringWithFormat:@"%@auth",cookiepre];
//        NSString *cookie_saltkey=[NSString stringWithFormat:@"%@saltkey",cookiepre];
//        NSString *auth=[app._mUserInfoDictionary objectForKey:@"auth"];
//        NSString *saltkey=[app._mUserInfoDictionary objectForKey:@"saltkey"];
//        NSLog(@"auth%@saltkey=%@",auth,saltkey);
//        [request setValue:[NSString stringWithFormat:@"%@=%@;%@=%@",cookie_auth,auth,cookie_saltkey,saltkey] forHTTPHeaderField:@"cookie"];
//        NSLog(@"request==%@",request);
//        }
//        request.HTTPShouldHandleCookies=NO;
        self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
    else if (postType == POST_TYPE_FILE){
        NSLog(@"POST_TYPE_FILE");
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //根据url初始化request
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//        //得到图片的data
//        NSData* data = [dict objectForKey:@"portrait"];
        NSData *data;
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [dict allKeys];
        NSString *imageKey;
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //如果key不是pic，说明value是字符类型，比如name：Boris
            if(![[dict objectForKey:key] isKindOfClass:[NSData class]])
            {
                //添加分界线，换行
                [body appendFormat:@"%@\r\n",MPboundary];
                //添加字段名称，换2行
                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                //添加字段的值
                [body appendFormat:@"%@\r\n",[dict objectForKey:key]];
            }else{
                imageKey=[NSString stringWithString:key];
            }
        }
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        if (imageKey) {
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",imageKey];
            data=[dict objectForKey:imageKey];
        }else{
        [body appendFormat:@"Content-Disposition: form-data; name=\"portrait\"; filename=\"portrait.jpg\"\r\n"];
        }
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
//        AppDelegate *app=APPDELEGATE;
//        if ([app._mUserInfoDictionary objectForKey:@"cookiepre"]&&[app._mUserInfoDictionary objectForKey:@"auth"]&&[app._mUserInfoDictionary objectForKey:@"saltkey"]) {
//            NSLog(@"cookiepre !!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//            NSString *cookiepre=[app._mUserInfoDictionary objectForKey:@"cookiepre"];
//            NSString *cookie_auth=[NSString stringWithFormat:@"%@auth",cookiepre];
//            NSString *cookie_saltkey=[NSString stringWithFormat:@"%@saltkey",cookiepre];
//            NSString *auth=[app._mUserInfoDictionary objectForKey:@"auth"];
//            NSString *saltkey=[app._mUserInfoDictionary objectForKey:@"saltkey"];
//            NSLog(@"auth%@saltkey=%@",auth,saltkey);
//            [request setValue:[NSString stringWithFormat:@"%@=%@;%@=%@",cookie_auth,auth,cookie_saltkey,saltkey] forHTTPHeaderField:@"cookie"];
//            NSLog(@"request==%@",request);
//        }
//        request.HTTPShouldHandleCookies=NO;
        self.httpConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
}

#pragma mark -
#pragma mark -
- (void)setUploadFile:(NSString *)path contentType:(NSString *)type nameParam:(NSString *)nameParam fileName:(NSString *)fileName
{
    
    NSInputStream *mediaInputStream = [[NSInputStream alloc]initWithFileAtPath:path];
    self.uploadFileInputStream = mediaInputStream;
    [self.uploadFileInputStream setDelegate:self];
    [self.uploadFileInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.uploadFileInputStream open];
    self.mediaFileOutputStream = [NSOutputStream outputStreamToFileAtPath:[self filePath:path] append:YES];
    [self.mediaFileOutputStream open];
    
}

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


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    uint8_t buf[1024];
    unsigned int len = 0;
    switch (eventCode)
    {
        case NSStreamEventHasBytesAvailable:
            len = [self.uploadFileInputStream read:buf maxLength:1024];
            if (len)
            {
                [self.mediaFileOutputStream write:buf maxLength:len];
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Error!");
        case NSStreamEventEndEncountered:
            [self.uploadFileInputStream close];
            [self.uploadFileInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.uploadFileInputStream = nil;
            [self.mediaFileOutputStream close];
            self.mediaFileOutputStream = nil;
        default:
            break;
    }
    
}

- (void)finishMediaInputStream
{
    [self.uploadFileInputStream close];
    [self.uploadFileInputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.uploadFileInputStream = nil;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *newresponse = (NSHTTPURLResponse *)response;
    if (newresponse)
    {
        NSLog(@"statusCode:%d",newresponse.statusCode);
    }
    self.dataTotalLength = response.expectedContentLength;
    [self.dataDownload setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataDownload appendData:data];
    self.progressNum = [self.dataDownload length]*1.0/self.dataTotalLength;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloadFinished:)])
    {
        [self.delegate performSelector:@selector(downloadFinished:) withObject:self];
    }
    else
    {
        NSLog(@"The Delegate Function is not complete");
    }
}





-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.dataDownload setLength:0];
//    if ([HttpHelper dataNetworkTypeFromStatusBar])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"网络不好，等下再试吧" message:nil delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles:nil];
//        [alertView show];
//    }
    if ([self.delegate respondsToSelector:@selector(downloadFinished:)])
    {
        [self.delegate performSelector:@selector(downloadFinished:) withObject:self];
    }
    NSLog(@"down error:%@",error);
}





@end
