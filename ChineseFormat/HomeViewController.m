//
//  HomeViewController.m
//  ChineseFormat
//
//  Created by chengshuangshuang on 2018/11/29.
//  Copyright © 2018 css. All rights reserved.
//

//#define DesktopPath [NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#import "HomeViewController.h"

#import "Masonry.h"
#import "ReactiveObjC.h"

#import "ChineseConvert.h"

@interface HomeViewController ()

@property (weak) IBOutlet NSTextField *inputLab;
@property (weak) IBOutlet NSTextField *inputTextField;
@property (weak) IBOutlet NSButton    *inputBtn;

@property (weak) IBOutlet NSTextField *outputLab;
@property (weak) IBOutlet NSTextField *outputTextField;
@property (weak) IBOutlet NSButton    *outputBtn;

@property (weak) IBOutlet NSButton    *stBtn;

@property (weak) IBOutlet NSButton    *tsBtn;

@property (weak) IBOutlet NSButton    *clearBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    self.view.wantsLayer = YES;
//    self.view.layer.backgroundColor = [NSColor grayColor].CGColor;
    
    [self setupAutoLayout];
    
    [self setupBtnEvent];
}

- (void)setupAutoLayout
{
    [self.inputLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.top.equalTo(@(40));
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    
    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputLab.mas_right).offset(20);
        make.top.equalTo(self.inputLab);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    [self.inputBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextField.mas_right).offset(30);
        make.top.equalTo(self.inputLab);
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
    }];
    
    [self.outputLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.top.equalTo(self.inputLab.mas_bottom).offset(30);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    
    [self.outputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outputLab.mas_right).offset(20);
        make.top.equalTo(self.outputLab);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    [self.outputBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outputTextField.mas_right).offset(30);
        make.top.equalTo(self.outputLab);
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
    }];
    
    [self.stBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.outputLab.mas_bottom).offset(50);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
    
    [self.tsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.stBtn.mas_bottom).offset(50);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
    
    [self.clearBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tsBtn.mas_bottom).offset(50);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
}

- (void)setupBtnEvent
{
    @weakify(self);
    
    self.inputBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        NSWindow *window = self.view.window;
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseFiles:YES];
        [panel setPrompt:@"选择"];
        [panel setMessage:@"请选择要转换的文件"];
        [panel beginSheetModalForWindow:window completionHandler:^(NSModalResponse result) {
            // NSModalResponseOK==1 or NSModalResponseCancel==0
            if (result == NSModalResponseOK) {
                NSURL *theDoc = [[panel URLs] objectAtIndex:0];
                
                NSRange range = [theDoc.description rangeOfString:@"file://"];
                NSString *path = [theDoc.description substringFromIndex:(range.location + range.length)];
                
                self.inputTextField.stringValue = [path stringByRemovingPercentEncoding];
            }
        }];
        
        return [RACSignal empty];
    }];
    
    self.outputBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        NSWindow *window = self.view.window;
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanChooseFiles:NO];
        [panel setPrompt:@"选择"];
        [panel setMessage:@"请选择转换后文件存放的路径"];
        [panel beginSheetModalForWindow:window completionHandler:^(NSModalResponse result) {
            // NSModalResponseOK==1 or NSModalResponseCancel==0
            if (result == NSModalResponseOK) {
                NSURL *theDoc = [[panel URLs] objectAtIndex:0];
                
                NSRange range = [theDoc.description rangeOfString:@"file://"];
                NSString *path = [theDoc.description substringFromIndex:(range.location + range.length)];
                
                self.outputTextField.stringValue = [path stringByRemovingPercentEncoding];
            }
        }];
        
        return [RACSignal empty];
    }];
    
    self.stBtn.rac_command = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self, inputTextField.stringValue), RACObserve(self, outputTextField.stringValue)] reduce:^id(NSString *input, NSString *output) {
        return @(input.length > 0 && output.length > 0);
    }] signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        NSString *inputPath = [self.inputTextField.stringValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        NSLog(@"inputPath = %@", inputPath);
        
//        NSData *tem = [NSData dataWithContentsOfFile:inputPath];
//        NSString *temString = [[NSString alloc] initWithData:tem encoding:NSUTF8StringEncoding];
//        NSLog(@"temString = %@", temString);
        
        // 初始化文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 读取要转换文件内容
        NSData *inputData = [fileManager contentsAtPath:inputPath];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        NSLog(@"inputString = %@", inputString);
        
        // 简体转换为繁体
        NSString *outputString = [ChineseConvert convertSimplifiedToTraditional:inputString];
        NSLog(@"outputString = %@", outputString);
        
        // 输出文件夹目录
        NSString *outputPath = [NSString stringWithFormat:@"%@", self.outputTextField.stringValue];
        NSLog(@"outputPath = %@", outputPath);
        // 获取输入文件的后缀
        NSString *type = [[self.inputTextField.stringValue componentsSeparatedByString:@"."] lastObject];
        NSLog(@"type = %@", type);
        // 拼接输出文件的完整路径
        NSString *outputFilePath = [NSString stringWithFormat:@"%@traditional.%@", outputPath, type];
        NSLog(@"outputFilePath = %@", outputFilePath);
        // 判断文件是否存在
        if (![fileManager fileExistsAtPath:outputFilePath]) {
            // 文件不存在就创建文件
            BOOL createResult = [fileManager createFileAtPath:outputFilePath contents:nil attributes:nil];
            NSLog(@"createResult = %d", createResult);
        }
        // 写入数据到文件
        NSError *error = nil;
        BOOL result = [outputString writeToFile:outputFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"error = %@", error);
        NSLog(@"result = %d", result);
        
        return [RACSignal empty];
    }];
    
    self.tsBtn.rac_command = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[RACObserve(self, inputTextField.stringValue), RACObserve(self, outputTextField.stringValue)] reduce:^id(NSString *input, NSString *output) {
        return @(input.length > 0 && output.length > 0);
    }] signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        NSString *inputPath = [self.inputTextField.stringValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        NSLog(@"inputPath = %@", inputPath);
        
        // 初始化文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 读取要转换文件内容
        NSData *inputData = [fileManager contentsAtPath:inputPath];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        NSLog(@"inputString = %@", inputString);
        
        // 简体转换为繁体
        NSString *outputString = [ChineseConvert convertTraditionalToSimplified:inputString];
        NSLog(@"outputString = %@", outputString);
        
        // 输出文件夹目录
        NSString *outputPath = [NSString stringWithFormat:@"%@", self.outputTextField.stringValue];
        NSLog(@"outputPath = %@", outputPath);
        // 获取输入文件的后缀
        NSString *type = [[self.inputTextField.stringValue componentsSeparatedByString:@"."] lastObject];
        NSLog(@"type = %@", type);
        // 拼接输出文件的完整路径
        NSString *outputFilePath = [NSString stringWithFormat:@"%@simplified.%@", outputPath, type];
        NSLog(@"outputFilePath = %@", outputFilePath);
        // 判断文件是否存在
        if (![fileManager fileExistsAtPath:outputFilePath]) {
            // 文件不存在就创建文件
            BOOL createResult = [fileManager createFileAtPath:outputFilePath contents:nil attributes:nil];
            NSLog(@"createResult = %d", createResult);
        }
        // 写入数据到文件
        NSError *error = nil;
        BOOL result = [outputString writeToFile:outputFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"error = %@", error);
        NSLog(@"result = %d", result);
        
        return [RACSignal empty];
    }];
    
    self.clearBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        self.inputTextField.stringValue = @"";
        self.outputTextField.stringValue = @"";
        
        return [RACSignal empty];
    }];
}

@end
