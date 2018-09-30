//
//  ViewController.m
//  InvocationTest2
//
//  Created by mac on 2018/9/30.
//  Copyright © 2018年 jiji. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *(^sayHelloBlock)(NSString *a, NSString *b, NSString *c) = ^(NSString *a, NSString *b, NSString *c) {
        return [NSString stringWithFormat:@"%@, %@ and %@~", a, b, c];
    };
    
    id result = invokeBlock(sayHelloBlock, @[@"Jim", @"Tom", @"Li Lei"]);
    NSLog(@"result - %@", result);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static id invokeBlock(id block, NSArray *arguments) {
    if (!block) {
        return nil;
    }
    id target = [block copy];
    
    // 声明一个函数指针，类型为字符型，参数为无类型指针
    const char *_Block_signature(void *);
    // 使用target创建字符指针对象
    const char *signature = _Block_signature((__bridge void *)(target));
    
    // 使用字符指针对象（字符串）生成方法签名
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:signature];
    // 生成invocation对象
    NSInvocation *invovcation = [NSInvocation invocationWithMethodSignature:methodSignature];
    // 将block设置成target
    invovcation.target = target;
    
    // 配置参数
    if ([arguments isKindOfClass:[NSArray class]]) {
        // 减1是由于方法签名中只设置了一个参数block，没有id和SEL
        // 且block对象的类型编码为“@?”
        NSInteger count = MIN(arguments.count, methodSignature.numberOfArguments - 1);
        for (int i = 0; i < count; i++) {
            // 取出对应参数的描述类型编码
            const char *type = [methodSignature getArgumentTypeAtIndex:(i + 1)];
            NSString *typeStr = [NSString stringWithUTF8String:type]; // 转成了NSString
            if ([typeStr containsString:@"\""]) {
                // 截取第一个字符
                type = [typeStr substringToIndex:1].UTF8String;
            }
            
            if (strcmp(type, "@") == 0) {
                // 是OC对象，给invocation设置参数
                id argument = arguments[i];
                [invovcation setArgument:&argument atIndex:(i + 1)];
                
            }
        }
    }
    
    // 触发调用
    [invovcation invoke];
    
    // 取回返回值
    void *returnValue = NULL;
    // 取出方法签名设定的返回值类型
    const char *type = methodSignature.methodReturnType;
    NSString *returnType = [NSString stringWithUTF8String:type];
    if ([returnType containsString:@"\""]) {
        type = [returnType substringToIndex:1].UTF8String;
    }
    if (strcmp(type, "@") == 0) {
        // 是OC对象（这里默认设置返回值都为对象）
        // 写入返回值指针的内存中
        [invovcation getReturnValue:&returnValue];
    }
    
    // 返回OC对象
    return (__bridge id)returnValue;
}


@end
