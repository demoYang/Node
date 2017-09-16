//
//  SNSHWrapTypeTableViewCell.h
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemoWrapObject;

@protocol SNSHWrapTypeTableViewCellInterface <NSObject>

@property (nonatomic, assign) NSInteger scopeCount;

@property (nonatomic, assign) CGFloat scopeWidth;

@property (nonatomic, assign) CGFloat itemHeigth;

@end

@protocol SNSHWrapTypeTableViewCellDelegate <NSObject>

- (void)onSwapToIndex:(NSInteger)index;

@end


@interface SNSHWrapTypeTableViewCell : UITableViewCell <SNSHWrapTypeTableViewCellInterface>

@property (nonatomic, weak) id<SNSHWrapTypeTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<DemoWrapObject *> *wrapList;

@property (nonatomic, assign) NSInteger scopeCount;

@property (nonatomic, assign) CGFloat scopeWidth;

- (void)changeOffset:(CGFloat)offsetY;

@end
