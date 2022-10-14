//
//  ListItem.h
//  SampleApp
//
//  Created by lizhifm on 2022/5/30.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// 列表结构化数据
@interface ListItem : NSObject <NSSecureCoding>

@property (nonatomic, copy, readwrite) NSString * category;
@property (nonatomic, copy, readwrite) NSString * picUrl;
@property (nonatomic, copy, readwrite) NSString * uniqueKey;
@property (nonatomic, copy, readwrite) NSString * title;
@property (nonatomic, copy, readwrite) NSString * date;
@property (nonatomic, copy, readwrite) NSString * authorName;
@property (nonatomic, copy, readwrite) NSString * articleUrl;

// 构造函数
- (void)configWithDictionary:(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
