//
//  ViewController.m
//  InvocationTest1
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 jiji. All rights reserved.
//

#import "ViewController.h"
#import "TestClass.h"
#import "NSObject+PerformSelector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id result = nil;
    @try {
        TestClass *tc = [[TestClass alloc] init];
        result = [tc performSelector:@selector(saySomething:b:c:) withArguments:@[@"Tom", @"Jim", @"Li Lei"]];
        NSLog(@"result = %@", result);
    } @catch (NSException *exception) {
        NSLog(@"exception - %@", exception.description);
    } @finally {
        NSLog(@"result = %@", result);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
