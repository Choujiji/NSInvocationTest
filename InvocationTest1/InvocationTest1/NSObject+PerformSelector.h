//
//  NSObject+PerformSelector.h
//  InvocationTest1
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)

- (id)performSelector:(SEL)aSelector
        withArguments:(NSArray *)arguments;

@end
