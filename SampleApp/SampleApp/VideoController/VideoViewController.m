//
//  VideoViewController.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/22.
//

#import "VideoViewController.h"
#import "VideoCoverView.h" // 重写了UICollectionViewCell，用于替换UICollectionViewCell
#import "VideoToolbar.h"


@interface VideoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation VideoViewController

- (instancetype) init{
    if (self = [super init]){
        self.tabBarItem.title = @"视频";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/video@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/video_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Layout定义整个UICollectionView的布局逻辑
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    // minimumInter是一行中每个cell的最小间距，实际值可能会大于这个数值
    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width - 10)/2, 300);
    // 视频播放器Cell大小
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 9 / 16 + VideoToolbarHeight);
    
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    // 设置为不需要系统自动进行设置
    collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    // 注册重用类型
    // 系统会在复用回收池中找不到时，自动创建一个（重用类型？）
    [collectionView registerClass:[VideoCoverView class] forCellWithReuseIdentifier:@"VideoCoverView"];
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

// 显示出 VideoController 中的 VideoCoverView时，会调用该函数
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCoverView" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor systemBlueColor];
    
    if ([cell isKindOfClass:[VideoCoverView class]]) {
        // http://clips.vorwaerts-gmth.de/big_buck_bunny.mp4
        [((VideoCoverView *)cell) layoutWithVideoCoverUrl:@"icon.bundle/videoCover@3x.jpg"
                                                 videoUrl:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.item % 3 == 0) {
//        return CGSizeMake(self.view.frame.size.width, 100);
//    } else {
//        return CGSizeMake((self.view.frame.size.width - 10)/2, 300);
//    }
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
