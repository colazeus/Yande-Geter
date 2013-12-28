//
//  RootViewController.h
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-15.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,assign)BOOL downLoadIsOver;
@property (nonatomic,assign)BOOL wait;
@end
