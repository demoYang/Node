//
//  ViewController.m
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import "ViewController.h"
#import "SNSHWrapTypeTableViewCell.h"
#import "DemoObject.h"

#define  kWidthHalf  ([UIScreen mainScreen].bounds.size.width/2 )
@interface ViewController () <UITableViewDataSource, UITableViewDelegate, SNSHWrapTypeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *upperView;

@property (nonatomic, assign) NSInteger rowHeigth;

@property (nonatomic, assign) NSInteger showIndex;

@property (nonatomic, strong) NSMutableArray<DemoWrapObject *> *wrapList;

@property (nonatomic, assign) BOOL shouldChange;

@property (nonatomic, assign) NSInteger cellOriginY;

@property (nonatomic, weak) SNSHWrapTypeTableViewCell *weakCell;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    
    [self initSubView];
}

- (void)initData {
    
    DemoObject *item01 = [[DemoObject alloc] init];
    item01.title = @"One";
    
    DemoObject *item02 = [[DemoObject alloc] init];
    item02.title = @"Two";
    
    DemoObject *item03 = [[DemoObject alloc] init];
    item03.title = @"Three";
    
    DemoObject *item04 = [[DemoObject alloc] init];
    item04.title = @"Four";
    
    DemoObject *item05 = [[DemoObject alloc] init];
    item05.title = @"Five";

    DemoObject *item06 = [[DemoObject alloc] init];
    item06.title = @"Six";

    DemoWrapObject *wrapOne = [[DemoWrapObject alloc] init];
    wrapOne.list = @[item01, item02, item03, item04].mutableCopy;
    
    DemoWrapObject *wrapTwo = [[DemoWrapObject alloc] init];
    wrapTwo.list = @[item01, item02, item03, item04, item05, item06].mutableCopy;
    
    _wrapList = [NSMutableArray array];
    [_wrapList addObject:wrapTwo];
    [_wrapList addObject:wrapOne];
    
}

- (void)initSubView {
    
    [self.view addSubview:self.tableView];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:array];
}
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - dataSource && delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_shouldChange && _weakCell) {
        
        CGFloat number = scrollView.contentOffset.y - _weakCell.frame.origin.y + 20;
        if (number > 0) {
            
            [_weakCell changeOffset:number];
        } else {
            
            [_weakCell changeOffset:0];
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        
        
        _shouldChange = YES;
        _cellOriginY = cell.frame.origin.y;
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row == 4) {
        
        _shouldChange = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
 if (indexPath.row == 4) {
        
        SNSHWrapTypeTableViewCell *cell = (SNSHWrapTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            
            cell = [[SNSHWrapTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.delegate = self;
            cell.wrapList = _wrapList;
            cell.layer.masksToBounds = YES;
            _weakCell = cell;
        }
        return cell;
    } else {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.contentView.backgroundColor = [UIColor greenColor];
        cell.layer.masksToBounds = YES;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        
        return (_wrapList[_showIndex].list.count / 2) * kWidthHalf + 50;
    } else {
        
        
        return  50;
    }
}
#pragma mark - SNSHWrapTypeTableViewCell
- (void)onSwapToIndex:(NSInteger)index {
    
    NSLog(@"on swap to index:%zd",index);
    _showIndex = index;
    [_tableView beginUpdates];
    [_tableView endUpdates];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [_tableView setContentOffset:_weakCell.frame.origin animated:NO];
    
}
@end
