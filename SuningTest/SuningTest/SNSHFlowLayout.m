//
//  SNSHFlowLayout.m
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import "SNSHFlowLayout.h"

@implementation SNSHFlowLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<UICollectionViewLayoutAttributes *> *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect rect = obj.frame;
        rect.origin.y = 0;
        obj.frame = rect;
    }];
    return array;
}
@end
