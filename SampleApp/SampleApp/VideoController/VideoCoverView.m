//
//  VideoCoverView.m
//  SampleApp
//
//  Created by lizhifm on 2022/6/2.
//

#import "VideoCoverView.h"
#import "VideoPlayer.h"
#import "VideoToolbar.h"


@interface VideoCoverView()

@property (nonatomic, strong, readwrite) UIImageView * coverView; // 占位图
@property (nonatomic, strong, readwrite) UIImageView * playerButton; // 播放按钮
@property (nonatomic, copy, readwrite) NSString * videoUrl;
@property (nonatomic, strong, readwrite) VideoToolbar * toolbar;

@end

@implementation VideoCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:({
            _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - VideoToolbarHeight)];
            _coverView;
        })];
        
        [_coverView addSubview:({
            _playerButton = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 50)/2, (frame.size.height -50)/2, 50, 50)];
            _playerButton.image = [UIImage imageNamed:@"icon.bundle/videoPlay@3x.png"];
            _playerButton;
        })];
        
        [self addSubview:({
            _toolbar = [[VideoToolbar alloc] initWithFrame:CGRectMake(0, _coverView.bounds.size.height, frame.size.width, VideoToolbarHeight)];
            _toolbar;
        })];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)dealloc {

}

#pragma mark - public method

// 布局逻辑放在layout当中，通过外部的控制改变不同的地址
- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl {
    _coverView.image = [UIImage imageNamed:videoCoverUrl];
    _videoUrl = videoUrl;
    [_toolbar layoutWithModel:nil];
}

#pragma mark - private method
// 响应点击，通过视频url进行播放
- (void)_tapToPlay {    
    [[VideoPlayer Player] playVideoWithUrl:_videoUrl attachView:_coverView];
}

@end

