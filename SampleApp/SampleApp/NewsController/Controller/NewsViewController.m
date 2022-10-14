//
//  NewsViewController.m
//  SampleApp
//
//  Created by lizhifm on 2022/5/21.
//

#import "NewsViewController.h"
#import "NormalTableViewCell.h"
//#import "DetailViewController.h"
#import "DeleteCellView.h"
#import "ListLoader.h"
#import "ListItem.h"
#import "Mediator.h"

@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate, NormalTableViewCellDelegate>

@property(nonatomic, strong, readwrite) UITableView * tableView;
@property(nonatomic, strong, readwrite) NSArray * dataArray;
@property(nonatomic, strong, readwrite) ListLoader * listLoader;

@end


@implementation NewsViewController

#pragma mark - lefe cycle

- (instancetype)init{
    if (self = [super init])
    {
//        _dataArray = @[].mutableCopy;
//        for (int i = 0; i < 20; i++) {
//            [_dataArray addObject:@(i)];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.listLoader = [[ListLoader alloc] init];
    
    // 解决block中self循环引用的问题
    __weak typeof (self) wself = self;
    // 发送网络请求 获得itemArray 回调block在主线程中处理
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<ListItem *> * _Nonnull dataArray) {
        __strong typeof(wself)strongSelf = wself;
        strongSelf.dataArray = dataArray;
        // 刷新列表
        [strongSelf.tableView reloadData];
    }];
    
}


#pragma mark - UITableViewDelegate

// 父类的delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"viewController: scrollViewDidScroll");
}

// 点击新闻Cell时，创建Cell中item.url的网页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListItem * item = [self.dataArray objectAtIndex:indexPath.row];
//    DetailViewController * controller = [[DetailViewController alloc] initWithUrlString:item.articleUrl];
    /// 解耦方式一
    /* 当前的UITableVIew并不知道具体要跳转的页面（当前类不包含detail页面），也是通过Mediator完成跳转，实现解耦*/
//    __kindof UIViewController * detailController = [Mediator detailViewControllerWithUrl:item.articleUrl];
//    detailController.title = [NSString stringWithFormat:@"%@", @(indexPath.row)];
//    // 这个navigationController是tableView的
//    [self.navigationController pushViewController:detailController animated:YES];
  
    /// 解耦方式二
    /**
     在列表页并不知道底层页是什么，只维护了一个scheme，传递相应的参数。
     在Mediator中也没有维护和相应的底层页
     */
//    [Mediator openUrl:@"detail://" params:@{@"url": item.articleUrl, @"controller": self.navigationController}];
    
    
    /// 解耦方式三
    // 通过底层暴露的protocol获取class
    Class cls = [Mediator classForProtocol:@protocol(DetailViewControllerProtocol)];
    // 可将protocol相应的变成类方法，所有的alloc init函数都在内部来完成，对外就是根据protocol生成一个类，执行protocol就可以了
    [self.navigationController pushViewController:[[cls alloc] detailViewControllerWithUrl:item.articleUrl] animated:YES];
    
    // 文章已读状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:item.uniqueKey];
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 20;
    return _dataArray.count;
}

// 当滚动列表视图的时候，每当有cell进入可视区，系统都会回调cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 使用系统回收池逻辑复用cell
    NormalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        static int i = 1;
        NSLog(@"%d",i++);
        cell = [[NormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    
    // tableView布局时，调用该方法
    // 取到对应的数据显示
    // 当Cell出现在ViewController的可见范围时，赋值信息
    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

// 点击cell的deleteButton时，回调到ViewController类
- (void)tableViewCell:(UITableViewCell *)tableViewCell clickDelegateButton:(UIButton *)deleteButton{
    DeleteCellView * deleteView = [[DeleteCellView alloc] initWithFrame:self.view.bounds];

    // 将Cell的坐标系转换为整个Window的坐标系
    // deletButton的superView时tableViewCell,将deleteButton的坐标系转换到Window的坐标系
    CGRect rect = [tableViewCell convertRect:deleteButton.frame toView:nil];

    // 解决block循环引用的问题
    __weak typeof (self) wself = self;
    [deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
        // 删除Cell
        __strong typeof(wself)strongSelf = wself;
//        [strongSelf.dataArray removeLastObject];
        [strongSelf.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}


//- (void)pushController{
//
//    UIViewController * viewController = [[UIViewController alloc] init];
//    viewController.view.backgroundColor = [UIColor whiteColor];
//    viewController.navigationItem.title = @"内容";
//
//    [self.navigationController pushViewController:viewController animated:YES];
//}

@end

