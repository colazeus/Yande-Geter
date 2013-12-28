//
//  UnderCollectionViewFlowLayout.m
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-16.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import "UnderCollectionViewFlowLayout.h"

@implementation UnderCollectionViewFlowLayout

- (id)init
{
    self = [super init];
    if(self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(120/16*9, 120);
        //图片间距
        self.minimumInteritemSpacing = 5.0f;
        self.minimumLineSpacing = 0.0f;
    }
    return self;
}

@end
