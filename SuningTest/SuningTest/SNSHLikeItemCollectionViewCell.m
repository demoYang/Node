//
//  SNSHLikeItemCollectionViewCell.m
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import "SNSHLikeItemCollectionViewCell.h"
#import "DemoObject.h"
#import "SNSHItemCollectionViewCell.h"

#define  kWidth  [UIScreen mainScreen].bounds.size.width
#define  kWidthHalf  ([UIScreen mainScreen].bounds.size.width/2 - 2)
#define  KHeight [UIScreen mainScreen].bounds.size.height

@interface SNSHLikeItemCollectionViewCell () <UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation SNSHLikeItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    [self.contentView addSubview:self.collectionView];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.contentView addConstraints:array];
}
- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidthHalf, kWidthHalf);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[SNSHItemCollectionViewCell class] forCellWithReuseIdentifier:@"Ider"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
- (void)setObject:(DemoWrapObject *)object {
    
    _object = object;
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _object.list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoObject *obj = [_object.list objectAtIndex:indexPath.row];
    SNSHItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Ider" forIndexPath:indexPath];
    cell.ob = obj;
    return cell;
}
@end
