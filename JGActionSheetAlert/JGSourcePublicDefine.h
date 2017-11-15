//
//  JGSourcePublicDefine.h
//  JGActionSheetAlertDemo
//
//  Created by Mei Jigao on 2017/11/14.
//  Copyright © 2017年 MeiJigao. All rights reserved.
//

// 防止重复引用
#pragma once

#ifndef JGSourcePublicDefine_h
#define JGSourcePublicDefine_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JGSourceLogMode) {
    JGSourceLogModeNone = 0,
    JGSourceLogModeLog,
    JGSourceLogModeFunc,
    JGSourceLogModePretty,
    JGSourceLogModeFile
};

/** 日志输出模式，默认 JGSourceLogModeNone 不输出日志 */
static JGSourceLogMode JGSourceLogOutMode = JGSourceLogModeNone;
FOUNDATION_STATIC_INLINE void JGSourcePrintLogWithMode(JGSourceLogMode mode) {
    JGSourceLogOutMode = mode;
}

// LOG，Xcode控制台日志结尾换行无效，增加空格才有效
#define JGLogOnly(fmt, ...) NSLog((@"" fmt "\n "), ##__VA_ARGS__);
#define JGLogFunc(fmt, ...) NSLog((@"%s Line: %zd " fmt "\n "), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define JGLogPretty(fmt, ...) NSLog((@"\n\nFunc:\t%s\nLine:\t%zd\n" fmt "\n "), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define JGLogFile(fmt, ...) NSLog((@"\n\nFile:\t%@\nFunc:\t%s\nLine:\t%zd\n" fmt "\n "), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define JGLog(fmt, ...) {\
    switch (JGSourceLogOutMode) {\
        case JGSourceLogModeLog:\
            JGLogOnly(fmt, ##__VA_ARGS__)\
            break;\
        case JGSourceLogModeFunc:\
        JGLogFunc(fmt, ##__VA_ARGS__)\
            break;\
        case JGSourceLogModePretty:\
            JGLogPretty(fmt, ##__VA_ARGS__)\
            break;\
        case JGSourceLogModeFile:\
            JGLogFile(fmt, ##__VA_ARGS__)\
            break;\
        case JGSourceLogModeNone:\
            break;\
    }\
}

// Reuse identifier
#define JGReuseIdentifier(Class) [NSStringFromClass([self class]) stringByAppendingFormat:@"_%@", NSStringFromClass([Class class])]

// Break block recycle
#define JGWeak(object) @autoreleasepool{} __weak typeof(object) weak##object = object;
#define JGStrong(object) @autoreleasepool{} __strong typeof(weak##object) object = weak##object;

NS_ASSUME_NONNULL_END

#endif /* JGSourcePublicDefine_h */
