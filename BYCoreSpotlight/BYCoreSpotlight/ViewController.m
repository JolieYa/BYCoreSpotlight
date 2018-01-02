//
//  ViewController.m
//  BYCoreSpotlight
//
//  Created by JolieYa on 2017/12/29.
//  Copyright © 2017年 JolieYa. All rights reserved.
//

#import "ViewController.h"
#import "Friend.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) NSArray *tableDataArray;
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self tableDataArray];
    [self.view addSubview:self.tableView];
    [self saveFriend];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Friend *friend = self.tableDataArray[indexPath.row];
    cell.textLabel.text = friend.name;
    cell.imageView.image = [UIImage imageNamed:friend.image];
    
    return cell;
}


-(UITableView *)tableView{
    if ( !_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)tableDataArray{
    if (!_tableDataArray) {
        _tableDataArray = [[NSMutableArray alloc] init];
        NSArray *array = @[@"aaaa", @"bbbb", @"ccccc",@"abcd"];
        int i = 0;
        for (NSString *item in array) {
            
            Friend *friend = [[Friend alloc] init];
            friend.name = item;
            friend.image = [NSString stringWithFormat:@"%d.jpg", ++i];
            friend.f_id = [NSString stringWithFormat:@"%d", i];
            friend.address = item;
            [_tableDataArray addObject:friend];
        }
    }
    
    return (_tableDataArray != nil)?_tableDataArray : nil;
}

// 创建索引
- (void)saveFriend {
    NSMutableArray <CSSearchableItem*> *searchableItem = [NSMutableArray array];
    
    for (Friend *friend in self.tableDataArray) {
        CSSearchableItemAttributeSet *attritable = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
        attritable.title = friend.name;
        attritable.contentDescription = friend.webUrl;
        attritable.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:friend.image]);
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:friend.f_id domainIdentifier:@"www.imooc.search.friend" attributeSet:attritable];
        [searchableItem addObject:item];
    }
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItem completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error = %@", error);
        }
    }];
}

// 删除索引
//- (void)deleteIndex {
//    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[[_itemToRemove indexPath] ] completionHandler:^(NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
//}

- (void)loadImage:(NSString *)f_id {
    Friend *someFriend = nil;
    for (Friend *item in _tableDataArray) {
        if ([item.f_id isEqualToString:f_id]) {
            someFriend = item;
            break;
        }
    }
    if (someFriend) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){150, 300, 50, 50}];
        imageView.image = [UIImage imageNamed:someFriend.image];
        [self.view addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
