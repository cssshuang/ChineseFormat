//
//  AppDelegate.m
//  ChineseFormat
//
//  Created by chengshuangshuang on 2018/11/29.
//  Copyright © 2018 css. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

@interface AppDelegate () <NSWindowDelegate>

@property (nonatomic, strong) NSWindow   *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    _window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 600, 400) styleMask:style backing:NSBackingStoreBuffered defer:NO];
    _window.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    _window.delegate = self;
    _window.title = @"中文简繁体转换";
    // 窗口显示
    [_window makeKeyAndOrderFront:self];
    // 窗口居中
    [_window center];
    // 设置最小缩放
    _window.minSize = self.window.contentMinSize = CGSizeMake(600, 400);
//    // 设置窗口颜色
//    _window.backgroundColor = [NSColor whiteColor];
    // 设置内容视图
    _window.contentViewController = [[HomeViewController alloc] init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


@end
