//
//  SNSHWrapTypeTableViewCell.m
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import "SNSHWrapTypeTableViewCell.h"
#import "SNSHLikeItemCollectionViewCell.h"
#import "SNSHFlowLayout.h"
#import "DemoObject.h"

#define  kWidth  [UIScreen mainScreen].bounds.size.width
#define  kWidthHalf  ([UIScreen mainScreen].bounds.size.width/2 )
#define  KHeight [UIScreen mainScreen].bounds.size.height

@interface SNSHWrapTypeTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIScrollView *typeView;

@property (nonatomic, strong) NSLayoutConstraint *constraint;

@property (nonatomic, assign) BOOL lastDir;

@end


@implementation SNSHWrapTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubViews];
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initSubViews {
    
    
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.typeView];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50)-[_collectionView(630)]" options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings( _collectionView)]];
    [array addObject:[_typeView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor]];
    [array addObject:[_typeView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor]];
    [array addObject:[_typeView.heightAnchor constraintEqualToConstant:50]];
    [array addObject:[_typeView.topAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.topAnchor]];
    _constraint = [_typeView.topAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.topAnchor];
    [array addObject:_constraint];
    [self.contentView addConstraints:array];
}

- (void)setWrapList:(NSMutableArray<DemoWrapObject *> *)wrapList{
    
    _wrapList = wrapList;
    [_collectionView reloadData];
    [self conStructTypeView];
}
- (void)conStructTypeView {
    
    UIView *contentView = [_typeView viewWithTag:10];
    if (contentView == nil) {
        
        contentView = [UIView new];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        [_typeView  addSubview:contentView];
    } else {
        
        [_typeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj removeFromSuperview];
        }];
    }
    contentView.frame = CGRectMake(0, 0, 400 * _wrapList.count, 50);
    [_typeView setContentSize:CGSizeMake(400 * _wrapList.count, 0)];
    
    for (int i = 0; i < _wrapList.count; i++) {
        
        UILabel *lbl = [UILabel new];
        lbl.frame = CGRectMake(400 * i, 0, 400, 50);
        lbl.text  = [NSString stringWithFormat:@"title %d", i];
        [contentView addSubview:lbl];
    }
}

- (void)changeOffset:(CGFloat)offsetY {
    
    if (offsetY == _constraint.constant) {
        
        return;
    }
    _constraint.constant = offsetY;
    [_typeView layoutSubviews];
}
- (UIScrollView *)typeView {
    
    if (_typeView == nil) {
        
        _typeView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _typeView.translatesAutoresizingMaskIntoConstraints = NO;
        _typeView.backgroundColor = [UIColor blueColor];
        _typeView.delegate = self;
//        _typeView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return _typeView;
}
- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        SNSHFlowLayout *layout = [[SNSHFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Ider"];
        [_collectionView registerClass:[SNSHLikeItemCollectionViewCell class] forCellWithReuseIdentifier:@"Ider2"];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor redColor];
        
        
    }
    return _collectionView;
}

#pragma mark - delegate && dataSource for collectionView


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.scopeCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoWrapObject *obj = _wrapList[indexPath.row];
    SNSHLikeItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Ider2" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor grayColor];
    [cell setObject:obj];
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _collectionView) {
        
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSwapToIndex:)]) {
            
            [self.delegate onSwapToIndex:index];
        }
        [_typeView setContentOffset:CGPointMake(index * self.scopeWidth, 0) animated:NO];
    } else if(scrollView == _typeView){
        
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / self.scopeWidth);
        NSLog(@"===%zd",index);
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSwapToIndex:)]) {
            
            [self.delegate onSwapToIndex:index];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoWrapObject *object = _wrapList[indexPath.row];
    return CGSizeMake(kWidth, object.list.count / 2 * kWidthHalf -1);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffse {
    
    if (scrollView != _typeView) {
        
        return;
    }
    CGFloat number = (targetContentOffse->x / self.scopeWidth);
    targetContentOffse->x = round(number) * self.scopeWidth;
    if (targetContentOffse->x  >=  scrollView.contentSize.width) {
        targetContentOffse->x = scrollView.contentSize.width;
    }
}

#pragma mark - SNSHWrapTypeTableViewCellInterface

- (NSInteger)scopeCount {
    
    return _wrapList.count;
}

- (CGFloat)scopeWidth {
    
    return 400;
}

- (CGFloat)itemHeigth {
    
    return kWidthHalf;
}
@end
