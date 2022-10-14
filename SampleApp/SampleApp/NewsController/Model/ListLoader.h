//
//  ListLoader.h
//  SampleApp
//
//  Created by lizhifm on 2022/5/25.
//

#import <Foundation/Foundation.h>

@class ListItem;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ListLoaderFinishBlock)(BOOL success, NSArray<ListItem*> * dataArray);

/// 列表请求
@interface ListLoader : NSObject

- (void)loadListDataWithFinishBlock:(ListLoaderFinishBlock)finishBlock; 

@end

NS_ASSUME_NONNULL_END
