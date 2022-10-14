//
//  ListLoader.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/25.
//

#import "ListLoader.h"
#import <AFNetworking.h>
#import "ListItem.h"


@implementation ListLoader

- (void)loadListDataWithFinishBlock:(ListLoaderFinishBlock)finishBlock {

/*
 使用第三方库非常简单，并不需要自己操作NSURL，NSURLRequest，以及将参数拼到项目当中来，以及POST参数等，也不需要设置task回调，不需要调用resume操作。
 只需要调用以下代码就可以完成网络请求。
 请求调到success block当中，response已经自动帮我们解析好了数据，
 */
//    [[AFHTTPSessionManager manager] GET:@"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e" parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            // 下载进度
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"");
//            //AFNetworking 自动解析好了数据
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"");
//        }];

    // 读取上次的数据 展示列表
    NSArray<ListItem *> * listdata = [self _readDataFromLocal];
    if (listdata) {
        // 设置dataArray数组并刷新 Newscv的tableView显示 ，这个block在Newscv中
        finishBlock(YES, listdata);
    }
    
    // 拉取新数据
	NSString * urlString = @"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
	NSURL * listURL = [NSURL URLWithString:urlString];

	// __unused属性 可以消除unused警告
//	__unused NSURLRequest * listRequest = [NSURLRequest requestWithURL:listURL];

	NSURLSession * session = [NSURLSession sharedSession]; // 使用默认Session
	// 使用最基础的dataTask
	//      可以使用dataTaskwithURL，传入url即可
//    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:listRequest]; // dataTask属于session

    __weak typeof(self) weakSelf = self; // 解决block中self循环引用 1
	NSURLSessionDataTask * dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf; // 解决block中self循环引用 2
	                                           NSError * jsonError;

	                                           // 解析出的jsonObj是一个NSDictionary字典对象
	                                           id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

#warning 类型的检查
	                                           NSArray * dataArray = [((NSDictionary *)[((NSDictionary *)jsonObj) objectForKey:@"result"]) objectForKey:@"data"];

	                                           NSMutableArray * listItemArray = @[].mutableCopy;
	                                           for (NSDictionary * info in dataArray) {
                                                   ListItem * listItem = [[ListItem alloc] init];
                                                   [listItem configWithDictionary:info];
                                                   [listItemArray addObject:listItem];
                                               }

	                                           // 存储从网络获得的数据
	                                           [weakSelf _archiveListDataWithArray:listItemArray.copy]; // 解决block中self循环引用 3

	                                           // 让回包在主线程中处理 将回调放到主线程当中
	                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                   if (finishBlock) {
                                                       finishBlock(error == nil, listItemArray.copy);
                                                   }
                                               });

	                                           NSLog(@"");
    }];

	[dataTask resume];
	// po listRequest.HTTPMethod 查看请求方法
	NSLog(@"");
//    [self _getSanBoxPath];
}

#pragma mark - private method
// 创建一个路径使用fileManager读取数据，并且反序列化
- (NSArray<ListItem *> *)_readDataFromLocal {
    NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachePath = [pathArray firstObject];
    NSString * listDataPath = [cachePath stringByAppendingPathComponent:@"Data/list"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];

    NSData * readListData = [fileManager contentsAtPath:listDataPath];
    
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class],[ListItem class], nil] fromData:readListData error:nil];
    
    if ([unarchiveObj isKindOfClass:[NSArray class]] && [unarchiveObj count] > 0) {
        return (NSArray<ListItem*>*)unarchiveObj;
    }
    
    return nil;
}


//- (void)_getSanBoxPath {
- (void)_archiveListDataWithArray:(NSArray<ListItem *> *)array {
	// 取Cache得地址
	NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString * cachePath = [pathArray firstObject];

	NSFileManager * fileManager = [NSFileManager defaultManager];

	// 在Cache目录下创建文件夹
	NSString * dataPath = [cachePath stringByAppendingPathComponent:@"Data"]; // 系统会自动添加/
	NSError * creatError;
	[fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];
	
    // 创建文件 写入数据
	NSString * listDataPath = [dataPath stringByAppendingPathComponent:@"list"];
//	NSData * listData = [@"abc" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 序列化 写入
    NSData * listData = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:nil];

    [fileManager createFileAtPath:listDataPath contents:listData attributes:nil];

    
    
    // 读取写入的文件 反序列化
    NSData * readListData = [fileManager contentsAtPath:listDataPath];
    
    // 此处序列化的Set参数是什么？ 数组 和 数组中的类型
    // 根据NSData和传入的数据进行反序列化
//    id unarchiveObj = [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClasses:[NSSet setWithObjects:[NSArray class],[ListItem class], nil] fromData:readListData error:nil];
    
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"abc" forKey:@"test"];
    // 存入NSUserDefault中序列化的数据、读取出来、反序列化
    [[NSUserDefaults standardUserDefaults] setObject:listData forKey:@"listData"];
    NSData * testListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"listData"];
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class],[ListItem class], nil] fromData:testListData error:nil];
    
//    // 查询文件
//	BOOL fileExist = [fileManager fileExistsAtPath:listDataPath];
//	// 删除
//    if (fileExist) {
//        [fileManager removeItemAtPath:listDataPath error:nil];
//    }
//
//	NSLog(@"");
//	// 追加 对list文件创建一个fileHandle
//	NSFileHandle * fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:listDataPath];
//	[fileHandler seekToEndOfFile];
//	[fileHandler writeData:[@"def" dataUsingEncoding:NSUTF8StringEncoding]];
//	[fileHandler synchronizeFile]; // 刷新文件 将内容立即写入到磁盘当中。 // 如果对实时性要求不高，可以不调用这句话
//	[fileHandler closeFile]; // 如果不调用关闭文件，当fileHandle销毁时，系统会自动关闭。

}


@end
