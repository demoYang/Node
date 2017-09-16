//
//  DemoObject.h
//  SuningTest
//
//  Created by SomeBoy on 2017/9/15.
//  Copyright © 2017年 SomeBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoObject : NSObject

@property (nonatomic , strong) NSString *title;

@end


@interface DemoWrapObject :NSObject 

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger typeWidth;

@property (nonatomic, assign) NSInteger itemHeight;

@property (nonatomic, strong) NSMutableArray<DemoObject *> *list;

@end


