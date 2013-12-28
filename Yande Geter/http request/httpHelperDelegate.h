//
//  httpHelperDelegate.h
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
