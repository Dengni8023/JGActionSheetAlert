//
//  JGActionSheetAlert.h
//  JGActionSheetAlert
//
//  Created by 梅继高 on 2017/5/10.
//  Copyright © 2017年 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGActionSheetAlert;
typedef void(^JGActionSheetAlertAction)(JGActionSheetAlert * __nonnull actionSheetAlert, NSInteger actionIndex);

/**
 不可同时显示Alert、ActionSheet，多个同时显示则移除之前的显示后显示最新
 */
@interface JGActionSheetAlert : NSObject

@property (nonatomic, assign, readonly) NSInteger cancelIndex; // 0
@property (nonatomic, assign, readonly) NSInteger destructiveIndex; // 1
@property (nonatomic, assign, readonly) NSInteger firstOtherIndex; // 2

#pragma mark - Alert
/**
 隐藏弹出的实现
 
 @return 是否需要隐藏
 */
+ (BOOL)hideAlert;
    
/**
 Alert 单个按钮，无点击响应
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/**
 Alert 单个按钮，无点击响应
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel;

/**
 Alert 单个按钮，有点击响应
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @param click 点击响应block
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel action:(nullable JGActionSheetAlertAction)click;

/**
 * Alert 双按钮
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @param other 确定按钮标题
 @param click 点击响应block
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel other:(nullable NSString *)other action:(nullable JGActionSheetAlertAction)click;

/**
 * Alert 双按钮，红色警告destructive按钮
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @param destructive 警告按钮标题
 @param click 点击响应block
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel destructive:(nullable NSString *)destructive action:(nullable JGActionSheetAlertAction)click;

/**
 Alert 多按钮
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @param others 目前仅支持不多于20个，多余不显示
 @param click 点击响应block
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel others:(nullable NSArray<NSString *> *)others action:(nullable JGActionSheetAlertAction)click;

/**
 Alert 多按钮，红色警告destructive按钮
 
 @param title 标题，默认“提示”
 @param message 提示内容
 @param cancel 取消按钮标题
 @param destructive 警告按钮标题
 @param others 目前仅支持不多于20个，多余不显示
 @param click 点击响应block
 @return UIAlertView / UIAlertController
 */
+ (nullable id)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel destructive:(nullable NSString *)destructive others:(nullable NSArray<NSString *> *)others action:(nullable JGActionSheetAlertAction)click;

#pragma mark - Actionsheet
/**
 Actionsheet
 
 @param title 标题，默认“提示”
 @param cancel 提示内容
 @param others 目前仅支持不多于20个，多余不显示
 @param click 点击响应block
 @return UIActionSheet / UIAlertController
 */
+ (nullable id)showActionSheetWithTitle:(nullable NSString *)title cancel:(nullable NSString *)cancel others:(nullable NSArray<NSString *> *)others action:(nullable JGActionSheetAlertAction)click;

/**
 Actionsheet，红色警告destructive按钮
 
 @param title 标题，默认“提示”
 @param cancel 提示内容
 @param destructive 警告按钮标题
 @param others 目前仅支持不多于20个，多余不显示
 @param click 点击响应block
 @return UIActionSheet / UIAlertController
 */
+ (nullable id)showActionSheetWithTitle:(nullable NSString *)title cancel:(nullable NSString *)cancel destructive:(nullable NSString *)destructive others:(nullable NSArray<NSString *> *)others action:(nullable JGActionSheetAlertAction)click;

@end

@interface JGActionSheetAlert (UIApplication)

/**
 应用最顶层 Controller
 
 @return UIViewController
 */
- (nullable UIViewController *)applicationTopViewController;

/**
 应用最顶层 Controller
 
 @param exclude 不包括 UIAlertController
 @return UIViewController
 */
- (nullable UIViewController *)applicationTopViewControllerExcludeAlert:(BOOL)exclude;

/**
 应用最顶层 NavigationController
 
 @return UINavigationController
 */
- (nullable UINavigationController *)applicationTopNavigationController;

@end

NS_ASSUME_NONNULL_END
