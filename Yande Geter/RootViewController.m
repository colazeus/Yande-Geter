//
//  RootViewController.m
//  Yande Geter
//
//  Created by 南 篤良 on 13-12-15.
//  Copyright (c) 2013年 南 篤良. All rights reserved.
//

#import "RootViewController.h"
#import "PreviewImageViewCell.h"
#import "UnderCollectionViewFlowLayout.h"
#import "MainImageView.h"
#import "PreviewImageDownload.h"

@interface RootViewController ()

@end

@implementation RootViewController
{
    MainImageView *mainImageView;
    UICollectionView *underCollectionView;
    NSMutableArray *_dataArray;
    NSInteger currentPage;
    CGFloat image_width;
    CGFloat image_height;
    CGFloat image_y;
    NSInteger select_index;
    NSString *lastOne;
    BOOL isInCache;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        currentPage = 1;
        [self GetIndexInfo:@"all" Page:currentPage];
    }
    select_index = -1;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat temp = EXTRAIOS7;
    mainImageView = [[MainImageView alloc]initWithFrame:CGRectMake(0, 44 + temp, 320, [UIScreen mainScreen].applicationFrame.size.height - 44 - 120)];
    image_height = mainImageView.frame.size.height;
    image_width = mainImageView.frame.size.width;
    image_y = mainImageView.frame.origin.y;
    [self.view addSubview:mainImageView];
    underCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, mainImageView.frame.size.height + mainImageView.frame.origin.y, 320, 120) collectionViewLayout:[[UnderCollectionViewFlowLayout alloc]init]];
    //注册
    [underCollectionView registerClass:[PreviewImageViewCell class] forCellWithReuseIdentifier:@"PreviewImageViewCell"];
    //底部控件背景颜色
    underCollectionView.backgroundColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    underCollectionView.delegate = self;
    underCollectionView.dataSource = self;
    [self.view addSubview:underCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadOnScreen];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PreviewImageViewCell *previewImageViewCell = [underCollectionView dequeueReusableCellWithReuseIdentifier:@"PreviewImageViewCell" forIndexPath:indexPath];
    previewImageViewCell.imageView.delegate = self;
    
    CGFloat preview_width = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_width"]floatValue];
    CGFloat preview_height = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_height"]floatValue];
    CGRect rect = previewImageViewCell.imageView.frame;
    rect.size = CGSizeMake(110*preview_width/preview_height, 110);
    previewImageViewCell.imageView.frame = rect;
    
    
    ProjectCache * cache = [ProjectCache shareCache];
    NSString *url = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"];
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [self filePath:[newUrl
                                     MD5Hash]];
    NSData *data = [cache readForKey:path];
    if (data!= nil)
    {
        previewImageViewCell.imageView.image = [UIImage imageWithData:data];
    }
    else
    {
        NSLog(@"2222");
        
        previewImageViewCell.imageView.image = [UIImage imageNamed:@"SampleImage"];
        if (currentPage == 2)
        {
            [previewImageViewCell.imageView imageDownloadFromUrlPre:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"] size:previewImageViewCell.imageView.frame.size];

        }
//        [previewImageViewCell.imageView imageDownloadFromUrl:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"] size:previewImageViewCell.imageView.frame.size];
    }
    
    return previewImageViewCell;
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



//屏幕个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

//请求Data
- (void)GetIndexInfo:(NSString *)tag  Page:(NSInteger) page{
    NSString *url = [NSString stringWithFormat:@"%@GetPicInfo.php?tag=%@&page=%d",SERVERIP,tag,page];
    [[HttpManage shareManage]addDownloadToQueueByGet:url];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnGetComplete:) name:url object:Nil];
}

//Data下载完成
- (void)OnGetComplete:(NSNotification *)notification
{
    NSString *url = notification.object;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:url object:Nil];
    [[HttpManage shareManage].downloadQueue removeObjectForKey:url];
    NSData *data = [[HttpManage shareManage].resultDict objectForKey:url];
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
    [_dataArray addObjectsFromArray:[resultDictionary objectForKey:@"data"]];
    [underCollectionView reloadData];
    
    currentPage ++;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat preview_width = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_width"]floatValue];
    CGFloat preview_height = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_height"]floatValue];
    return CGSizeMake(110*preview_width/preview_height, 110);
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //mainImageView.image = [UIImage imageNamed:@"SampleImage"];
    if(select_index != indexPath.row)
    {
        CGFloat sample_width = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"sample_width"]floatValue];
        CGFloat sample_height = [[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"sample_height"]floatValue];
        CGRect rect = mainImageView.frame;
        
        //图片比例
        CGFloat original_scale = image_width/image_height;
        CGFloat sample_scale = sample_width/sample_height;
        if(original_scale >= sample_scale)
        {
            rect.size = CGSizeMake(image_height * sample_width/sample_height, image_height);
            rect.origin = CGPointMake(160-rect.size.width/2.0f, image_y);
        }
        else
        {
            rect.size = CGSizeMake(image_width, image_width * sample_height/sample_width);
            rect.origin = CGPointMake(0, image_height/2.0-rect.size.height/2.0 + image_y);
        }
        
        mainImageView.frame = rect;
        
        ProjectCache * cache = [ProjectCache shareCache];
        NSString *url = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"sample_url"];
        NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *path = [self filePath:[newUrl
                                         MD5Hash]];
        NSData *data = [cache readForKey:path];
        if (data!= nil)
        {
            
            NSLog(@"222 cache");
            
            mainImageView.image = [UIImage imageWithData:data];
        }
        else
        {
            [mainImageView imageDownload:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"]];
            [mainImageView imageDownload:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"sample_url"]];
            mainImageView.lastOne = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"sample_url"];
        }

        
        select_index = indexPath.row;
    }
    
}


- (void)loadOnScreen
{
    NSLog(@"1111");
    
    ProjectCache * cache = [ProjectCache shareCache];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[underCollectionView indexPathsForVisibleItems]];
    
    if ([array count]!=0)
    {
        
        int number = 0;
        
        for (NSIndexPath *indexPath in array)
        {
            NSString *url = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"];
            NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *path = [self filePath:[newUrl
                                             MD5Hash]];
            
            NSData *data = [cache readForKey:path];
            if (data == nil)
            {
                number ++;
            }
        }
        if (number == [array count])
        {
            NSLog(@"remove all");
            [cache removeAllObjects];
        }
        

        
        
        
        NSIndexPath *firstPath = [array objectAtIndex:0];
        
        NSLog(@"firstpath:%d",firstPath.row);
        
        NSIndexPath *lastPath = [array lastObject];
        if (firstPath.row > 10)
        {
            for (int i = 1; i < 11; i ++)
            {
                NSLog(@"add first");
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:(firstPath.row - i) inSection:0];
                [array addObject:indexpath];
                if ((lastPath.row + i)+1<[_dataArray count])
                {
                    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:(lastPath.row + i) inSection:0];
                    [array addObject:indexPath2];
                }
            }
            
        }
        else
        {
            for (int i = 1; i < 11; i ++)
            {
                if ((lastPath.row + i)+1<[_dataArray count])
                {
                    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:(lastPath.row + i) inSection:0];
                    [array addObject:indexPath2];
                }
            }
            
        }
        
    }
    
    
    
    for (NSIndexPath *indexPath in array)
    {
        PreviewImageViewCell *previewImageViewCell = (PreviewImageViewCell *)[underCollectionView cellForItemAtIndexPath:indexPath];
        
        NSLog(@"111  indexpath:%d",indexPath.row);
        
        
        NSString *url = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"];
        NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *path = [self filePath:[newUrl
                                         MD5Hash]];
        NSData *data = [cache readForKey:path];
        if (data!= nil)
        {
            NSLog(@"1111 cache");

            previewImageViewCell.imageView.image = [UIImage imageWithData:data];
        }
        else
        {
            [previewImageViewCell.imageView imageDownloadFromUrlCache:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"preview_url"] size:previewImageViewCell.imageView.frame.size];
        }

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"end");
    
    [self loadOnScreen];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"decelerate");
        [self loadOnScreen];
    
}


//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.wait == YES)
    {
        NSLog(@"???");
        if(scrollView.contentOffset.x + 320 >= scrollView.contentSize.width && self.downLoadIsOver == YES)
        {
            [self GetIndexInfo:@"all" Page:currentPage];
            self.downLoadIsOver = NO;
        }
        self.wait = NO;
    }
    
}

@end
