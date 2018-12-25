//
//  ChineseConvert.m
//  ChineseFormat
//
//  Created by chengshuangshuang on 2018/11/30.
//  Copyright © 2018 css. All rights reserved.
//

#define Valid(a) ((a == nil || [a isKindOfClass:[NSNull class]] || ([a respondsToSelector:@selector(isEqualToString:)] && ([a isEqualToString:@"<null>"] || [a isEqualToString:@"(null)"] || [a isEqualToString:@"null"]))) ? @"" : a)
#define isValid(a) ((a == nil || [a isKindOfClass:[NSNull class]] || ([a respondsToSelector:@selector(isEqualToString:)] && ([a isEqualToString:@""] || [a isEqualToString:@"<null>"] || [a isEqualToString:@"(null)"] || [a isEqualToString:@"null"]))) ? NO :YES)

#import "ChineseConvert.h"

@interface ChineseConvert ()

@property (nonatomic, strong) NSString *simplifiedCode;  //!< 简体中文码表.
@property (nonatomic, strong) NSString *traditionalCode; //!< 繁体中文码表.

@end

@implementation ChineseConvert

/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertSimplifiedToTraditional:(NSString *)simpString
{
    return [[ChineseConvert getInstance] convertSimplifiedToTraditional:simpString];
}


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString *)convertTraditionalToSimplified:(NSString *)tradString
{
    return [[ChineseConvert getInstance] convertTraditionalToSimplified:tradString];
}


// 获取单例对象
+ (instancetype)getInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 加载简体中文和繁体中文码表
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        self.simplifiedCode = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"SimplifiedCode.txt"] encoding:NSUTF8StringEncoding error:nil];
        self.traditionalCode = [NSString stringWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"TraditionalCode.txt"] encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}


/**
 简体中文转繁体中文
 
 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
- (NSString *)convertSimplifiedToTraditional:(NSString *)simpString
{
    // 空值判断
    if (!isValid(simpString)) {
        return nil;
    }
    
    // 存储转换结果
    NSMutableString *resultString = [NSMutableString string];
    
    // 遍历字符串中的字符
    NSInteger length = [simpString length];
    for (NSInteger i = 0; i < length; i++)
    {
        // 在简体中文中查找字符位置，如果存在则取出对应的繁体中文
        NSString *simCharString = [simpString substringWithRange:NSMakeRange(i, 1)];
        NSRange charRange = [self.simplifiedCode rangeOfString:simCharString];
        if (charRange.location != NSNotFound) {
            NSString *tradCharString = [self.traditionalCode substringWithRange:charRange];
            [resultString appendString:tradCharString];
        } else {
            [resultString appendString:simCharString];
        }
    }
    
    return resultString;
}


/**
 繁体中文转简体中文
 
 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
- (NSString *)convertTraditionalToSimplified:(NSString *)tradString
{
    // 空值判断
    if (!isValid(tradString)) {
        return nil;
    }
    
    // 存储转换结果
    NSMutableString *resultString = [NSMutableString string];
    
    // 遍历字符串中的字符
    NSInteger length = [tradString length];
    for (NSInteger i = 0; i < length; i++)
    {
        // 在繁体中文中查找字符位置，如果存在则取出对应的简体中文
        NSString *tradCharString = [tradString substringWithRange:NSMakeRange(i, 1)];
        NSRange charRange = [self.traditionalCode rangeOfString:tradCharString];
        if (charRange.location != NSNotFound) {
            NSString *simCharString = [self.simplifiedCode substringWithRange:charRange];
            [resultString appendString:simCharString];
        } else {
            [resultString appendString:tradCharString];
        }
    }
    
    return resultString;
}

@end
