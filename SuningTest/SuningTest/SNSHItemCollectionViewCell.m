//
//  SNSHItemCollectionViewCell.m
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import "SNSHItemCollectionViewCell.h"
#import "DemoObject.h"

@implementation SNSHItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    _label = [UILabel new];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_label];
    [_label.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
    [_label.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    self.contentView.backgroundColor = [UIColor grayColor];
}
- (void)setOb:(DemoObject *)ob {
    
    _label.text = ob.title;
    
}
@end
