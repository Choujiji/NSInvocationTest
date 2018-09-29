//
//  NSObject+PerformSelector.m
//  InvocationTest1
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)

- (id)performSelector:(SEL)aSelector
        withArguments:(NSArray *)arguments {
    if (!aSelector) {
        return nil;
    }
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    
    if ([arguments isKindOfClass:[NSArray class]]) {
        // 减2是因为signature的参数包含固定的self和_cmd
        NSInteger count = MIN(arguments.count, signature.numberOfArguments - 2);
        for (int i = 0; i < count; i++) {
            // 返回指定index的参数类型
            const char *type = [signature getArgumentTypeAtIndex:(i + 2)];
            // 类型是OC对象（本函数的参数为NSArray，所以都是对象）
            if (strcmp(type, "@") == 0) {
                // 取出参数
                id argument = arguments[i];
                // 设置参数（copy到invocation上）
                // 【同样，invocation的参数列表中前两个也是self和_cmd】
                [invocation setArgument:&argument atIndex:(i + 2)];
            }
        }
    }
    
    // 调用函数（此时会动态配置返回值）
    [invocation invoke];
    
    // 取回返回值
    
    // 【注意：1.返回值使用__unsafe_unretained或__weak修饰，原因是由于：invocation的getReturnValue返回的若是OC对象，只是将返回的内容copy到指定地址，但是不对其进行任何内存管理，及returnValue的引用计数为0；由于在ARC模式下，本函数结束后，returnValue会收到release消息，即默认释放；当调用者访问返回值或者返回值也是临时变量被释放时，导致crash】
    
//    id __unsafe_unretained returnValue = @1;
//    if (strcmp(signature.methodReturnType, "@") == 0) {
//        // 返回值是OC对象，取回赋值到指针（这里是给野指针赋值，使其存在内容）
//        [invocation getReturnValue:&returnValue];
//    }
//    return returnValue;
    
    // 【注意：2.由于getReturnValue方式实质上是往buffer内写入内容，使用C指针会更加严谨，而且避免了ARC内存释放导致的crash，返回时桥接转换为对象即可（这种情况也兼容所有数据类型）】
    void *returnValue = NULL;
    if (strcmp(signature.methodReturnType, "@") == 0) {
        // 返回值是OC对象，取回赋值到指针（这里是给野指针赋值，使其存在内容）
        [invocation getReturnValue:&returnValue];
    }
    return (__bridge id)returnValue;
}

@end
