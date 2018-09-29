//
//  TestClass.m
//  InvocationTest
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

//- (NSString *)saySomething:(NSString *)a
//                         b:(NSString *)b
//                         c:(NSString *)c {
//    return [NSString stringWithFormat:@"%@ and %@ and %@",
//            a, b, c];
//}

- (NSDictionary *)saySomething:(NSString *)a
                             b:(NSString *)b
                             c:(NSString *)c {
    return @{
             @"a": a,
             @"b": b,
             @"c": c
             };
}


@end
