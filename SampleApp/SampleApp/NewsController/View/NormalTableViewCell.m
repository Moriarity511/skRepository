//
//  NormalTableViewCell.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/22.
//

#import "NormalTableViewCell.h"
#import "ListItem.h"
#import "SDWebImage.h"
#import "Screen.h"

// 创建自己的UILabel

@interface NormalTableViewCell()

@property(nonatomic, strong, readwrite) UILabel * titleLabel;
@property(nonatomic, strong, readwrite) UILabel * sourceLabel;
@property(nonatomic, strong, readwrite) UILabel * commentLabel;
@property(nonatomic, strong, readwrite) UILabel * timeLabel;

@property(nonatomic, strong, readwrite) UIImageView * rightImageView;

@property(nonatomic, strong, readwrite) UIButton * deleteButton;

@end


@implementation NormalTableViewCell

// 重写
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:({
            self.titleLabel = [[UILabel alloc] initWithFrame:UIRect(20, 15, 270, 50)];
//            self.titleLabel.backgroundColor = [UIColor systemGreenColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.numberOfLines = 2; // 显示两行
            self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail; // 截断的末尾显示...
            
            self.titleLabel;
        })];
        
        [self.contentView addSubview:({
            self.sourceLabel = [[UILabel alloc] initWithFrame:UIRect(20, 70, 50, 20)];
//            self.sourceLabel.backgroundColor = [UIColor systemGreenColor];
            self.sourceLabel.font = [UIFont systemFontOfSize:16];
            self.sourceLabel.textColor = [UIColor blackColor];
            self.sourceLabel;
        })];
        
        [self.contentView addSubview:({
            self.commentLabel = [[UILabel alloc] initWithFrame:UIRect(100, 70, 50, 20)];
//            self.commentLabel.backgroundColor = [UIColor systemGreenColor];
            self.commentLabel.font = [UIFont systemFontOfSize:16];
            self.commentLabel.textColor = [UIColor blackColor];
            self.commentLabel;
        })];
        
        [self.contentView addSubview:({
            self.timeLabel = [[UILabel alloc] initWithFrame:UIRect(180, 70, 70, 20)];
//            self.timeLabel.backgroundColor = [UIColor systemGreenColor];
            self.timeLabel.font = [UIFont systemFontOfSize:16];
            self.timeLabel.textColor = [UIColor blackColor];
            self.timeLabel;
        })];
        
        [self.contentView addSubview:({
            self.rightImageView = [[UIImageView alloc] initWithFrame:UIRect(300, 15, 100, 70)];
//            self.rightImageView.backgroundColor = [UIColor systemGreenColor];
            self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightImageView;
        })];
        
        [self.contentView addSubview:({
            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 80, 30, 20)];
            [self.deleteButton setTitle:@"X" forState:UIControlStateNormal];
            [self.deleteButton setTitle:@"V" forState:UIControlStateHighlighted];
            
            // 系统识别到了点击，触发方法，不加这句话也能识别 注册这种事件的监听 实现T-A操作
            [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
//            self.deleteButton.backgroundColor = [UIColor systemBlueColor];
            
            self.deleteButton.layer.cornerRadius = 10;
            self.deleteButton.layer.masksToBounds = YES;
            self.deleteButton.layer.borderColor  = [UIColor lightGrayColor].CGColor;
            self.deleteButton.layer.borderWidth = 2;
            
            self.deleteButton;
        })];
        
    }
    return self;
}

// T-A 实现
- (void)deleteButtonClick{
    NSLog(@"deleteButtonClick");
    
    // 判断Delegate是否实现了可选的函数tableViewCell:clickDelegateButton:
    // 判断对象中是否有这个方法可以执行 - (BOOL)respondsToSelector:(SEL)aSelector;
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDelegateButton:)]) {
        [self.delegate tableViewCell:self clickDelegateButton:self.deleteButton];
    }
}

- (void)layoutTableViewCellWithItem:(ListItem *)item {
    // 判断是否已读 改变字体颜色
    // 此处是为了演示存储方式，
    BOOL hasRead = [[NSUserDefaults standardUserDefaults] boolForKey:item.uniqueKey];
    
    if (hasRead) {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
    self.titleLabel.text = item.title;
    
    self.sourceLabel.text = item.authorName;
    [self.sourceLabel sizeToFit]; // 根据字体自动调整大小
    
    self.commentLabel.text = item.category;
    [self.commentLabel sizeToFit];
    self.commentLabel.frame = CGRectMake(self.sourceLabel.frame.origin.x + self.sourceLabel.frame.size.width + UI(15),
                                         self.sourceLabel.frame.origin.y,
                                         self.commentLabel.frame.size.width,
                                         self.commentLabel.frame.size.height);
    
    self.timeLabel.text = item.date;
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.commentLabel.frame.origin.x + self.commentLabel.frame.size.width + UI(15),
                                      self.commentLabel.frame.origin.y,
                                      self.timeLabel.frame.size.width,
                                      self.timeLabel.frame.size.height);
    
#warning
//    NSThread * downloadImageThread = [[NSThread alloc] initWithBlock:^{
//        // 从网络中获取数据的操作不应放在主线程中。
//        // 等待网络反馈结果，导致主线程停顿，导致UI界面发生卡顿和丢帧
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//        self.rightImageView.image = image;
//    }];
//
//    downloadImageThread.name = @"downloadImageThread";
//    // 执行线程
//    [downloadImageThread start];
    
    
    // 使用GCD执行
    // 获取系统提供的非主队列
//    dispatch_queue_global_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    // 获取主队列
//    dispatch_queue_main_t mainQueue = dispatch_get_main_queue();
//
//    // 在非主线程中异步执行业务逻辑
//    dispatch_async(downloadQueue, ^{
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//        // 在主线程中执行UI操作
//        dispatch_async(mainQueue, ^{
//            self.rightImageView.image = image;
//        });
//    });

    /*
     这句代码执行了两件事：
     传入图片url，先判断磁盘和缓存中是否存在，进行读取。如果没有，会去下载，存储到磁盘当中，继续展示。之后会再调用completed回调。
     */
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:item.picUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"");
    }];
    
    
}

@end
