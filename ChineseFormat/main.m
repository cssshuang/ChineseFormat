//
//  main.m
//  ChineseFormat
//
//  Created by chengshuangshuang on 2018/11/29.
//  Copyright © 2018 css. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    // 初始化方法
    NSApplication *application = [NSApplication sharedApplication];
    
    id delegate = [[AppDelegate alloc] init];
    
    application.delegate = delegate;
    
    return NSApplicationMain(argc, argv);
}
