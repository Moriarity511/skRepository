//
//  VideoPlayer.m
//  SampleApp
//
//  Created by lizhifm on 2022/6/3.
//

#import "VideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayer()

@property (nonatomic, strong, readwrite) AVPlayerItem * videoItem;
@property (nonatomic, strong, readwrite) AVPlayer * avPlayer;
@property (nonatomic, strong, readwrite) AVPlayerLayer * playerLayer;

@end

@implementation VideoPlayer

+ (VideoPlayer *)Player {
    // 使用GCD中的dispatch_once 实现单例
    static VideoPlayer * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[VideoPlayer alloc] init];
    });
    return player;
}

- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)attachView {
    // 销毁之前的播放器
    [self _stopPlay];
    
    // 资源创建 -> controller创建 -> view创建 -> 播放
//    NSURL * videoURL = [NSURL URLWithString:videoUrl];
    NSURL * videoURL = [NSURL fileURLWithPath:@"/Users/lizhifm/Desktop/极客时间OC/SampleApp-代码重构 20220525/big_buck_bunny.mp4"];
    
    AVAsset * asset = [AVAsset assetWithURL:videoURL];
    // 可以根据URL直接生成AVPlayerItem
    _videoItem = [AVPlayerItem playerItemWithAsset:asset];
    
    // 使用KVO监听VideoItemPlayer的状态，当系统加载好可以播放资源的时候，再调用AVPlayer进行play操作
    // NSKeyValueObservingOptionNew 当值有新变化的时候来处理
    
    // 对Item进行监听
    // 监听什么时候开始播放
    [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲进度
    [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    CMTime duration = _videoItem.duration;
    CGFloat videoDuration = CMTimeGetSeconds(duration);
    
    // 有了AVPlayerItem就能将视频URL和AVPlayer结合起来。
    // 可以通过URL直接生成Player
    // 系统提供的中间属性，是为了方便自定义的处理
    _avPlayer = [AVPlayer playerWithPlayerItem:_videoItem]; // 执行完这句 AVPlayerLayer就已经存在了。
    // 播放进度 系统提供了block回调
    // 第一个参数为回调时间，1秒回调一次 value / timescale = 1即可， 在主线程回调
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放进度: %@", @(CMTimeGetSeconds(time)));
    }];
    
    
    // 获取AVPlayer中的AVPlayerLayer 并粘贴到view上
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _playerLayer.frame = attachView.bounds;
    [attachView.layer addSublayer:_playerLayer];
    
    // 向Center注册需要监听的事件 Center是一个单例 // 向Center注册自己成为事件的监听者 当广播事件时调用 _handlePlayEnd
    // 监听这个事件的对象self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil]; // 事件没有带参数，也不关注 所以object填nil？
    
    NSLog(@"");
}

- (void)_stopPlay {
    // 当类销毁时，从单例中移除自己，因为单例的生命周期是整个App
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 当播放完成 移除View中播放器视图
    [_playerLayer removeFromSuperlayer];
    
    // 为什么要在_stopPlay时移除监听？
    [_videoItem removeObserver:self forKeyPath:@"status"];
    [_videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _videoItem = nil; // 置为nil 会默认销毁吗？
    
    _avPlayer = nil;
}

- (void)_handlePlayEnd {
    [_avPlayer seekToTime:CMTimeMake(0, 1)];
    [_avPlayer play];
}

#pragma mark - KVO

// 监听AVPlayerItem的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerItemStatusReadyToPlay) {
            // 获取videoItem时长以及一些相关参数，都需要在status变为ReadyToPlay才能获得
            [_avPlayer play];
        } else {
            NSLog(@"");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"缓冲： %@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
}

@end
