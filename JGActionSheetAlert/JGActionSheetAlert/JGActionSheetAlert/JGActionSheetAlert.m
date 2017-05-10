//
//  JGActionSheetAlert.m
//  JGActionSheetAlert
//
//  Created by 梅继高 on 2017/5/10.
//  Copyright © 2017年 MEETStudio. All rights reserved.
//

#import "JGActionSheetAlert.h"

// NSArray元素获取
#define JGActionSheetAlertArrayObjectAtIndex(__ARRAY__, __INDEX__) \
((__INDEX__ >= [__ARRAY__ count]) ? nil : [__ARRAY__ objectAtIndex:__INDEX__])

// NSArray 转 va_list，暂无其他更好办法，考虑只是本文件内部使用，最多使用20个元素进行枚举处理
#define JGActionSheetAlertArrayToVa_list(__ARRAYNAME__) \
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 0),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 1),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 2),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 3),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 4),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 5),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 6),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 7),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 8),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 9),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 10),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 11),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 12),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 3),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__,14),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 15),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 16),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 7),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 18),\
JGActionSheetAlertArrayObjectAtIndex(__ARRAYNAME__, 19),\
nil

@interface JGActionSheetAlert () <UIAlertViewDelegate, UIActionSheetDelegate> {
    
}

@property (nonatomic, copy) JGActionSheetAlertAction actionBlock;

/**
 iOS7及以下系统Alert
 */
@property (nonatomic, strong) UIAlertView *alertView;

/**
 iOS7及以下系统Destructive
 */
@property (nonatomic, copy) NSString *alertDestructiveTitle;

@end

@implementation JGActionSheetAlert

static NSInteger const JGActionSheetAlertCancelIndex = 0;
static NSInteger const JGActionSheetAlertDestructiveIndex = 1;
static NSInteger const JGActionSheetAlertFirstOtherIndex = 2;

#pragma mark - ClassMethod
+ (instancetype)sharedInstance {
    
    static JGActionSheetAlert *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Alert
+ (BOOL)hideAlert {
    
    return [[self sharedInstance] hideCurrentAlertShow];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel {
    
    return [self showAlertWithTitle:title message:message cancel:cancel ?: @"确定" action:nil];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel action:(JGActionSheetAlertAction)action {
    
    return [self showAlertWithTitle:title message:message cancel:cancel ?: @"确定" other:nil action:action];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other action:(JGActionSheetAlertAction)action {
    
    return [self showAlertWithTitle:title message:message cancel:cancel others:[NSArray arrayWithObjects:other, nil] action:action];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel destructive:(NSString *)destructive action:(JGActionSheetAlertAction)action {
    
    return [self showAlertWithTitle:title message:message cancel:cancel destructive:destructive others:nil action:action];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    return [[self sharedInstance] showAlertWithTitle:title message:message cancel:cancel destructive:nil others:others action:action];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel destructive:(NSString *)destructive others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    return [[self sharedInstance] showAlertWithTitle:title message:message cancel:cancel destructive:destructive others:others action:action];
}

#pragma mark - ActionSheet
+ (id)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    return [self showActionSheetWithTitle:title cancel:cancel destructive:nil others:others action:action];
}

+ (id)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel destructive:(NSString *)destructive others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    return [[self sharedInstance] showActionSheetWithTitle:title cancel:cancel destructive:destructive others:others action:action];
}

#pragma mark - init & dealloc
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter
- (NSInteger)cancelIndex {
    
    return JGActionSheetAlertCancelIndex;
}

- (NSInteger)destructiveIndex {
    
    return JGActionSheetAlertDestructiveIndex;
}

- (NSInteger)firstOtherIndex {
    
    return JGActionSheetAlertFirstOtherIndex;
}

#pragma mark - Show
- (BOOL)hideCurrentAlertShow {
    
    UIViewController *topVC = [[UIApplication sharedApplication] applicationTopViewController];
    if ([topVC isKindOfClass:[UIAlertController class]]) {
        
        [topVC dismissViewControllerAnimated:NO completion:^{
            
        }];
        
        return YES;
    }
    
    if (self.alertView) {
        
        [self.alertView setDelegate:nil];
        [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
        self.alertView = nil;
        
        return YES;
    }
    
    return NO;
}

/** Alert 区分iOS7及以下与之后系统 */
- (id)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel destructive:(NSString *)destructive others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    title = title ?: @"提示";
    if ([UIAlertController class]) {
        
        return [self showAlertWithTitle:title message:message style:UIAlertControllerStyleAlert cancel:cancel destructive:destructive others:others action:action];
    }
    else {
        
        if (self.alertView) {
            
            [self.alertView setDelegate:nil];
            [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:NO];
            self.alertView = nil;
        }
        
        self.actionBlock = action;
        
        NSMutableArray *tmpOthers = [NSMutableArray arrayWithArray:others];
        if (destructive && ![others containsObject:destructive]) {
            
            self.alertDestructiveTitle = destructive;
            [tmpOthers insertObject:destructive atIndex:0];
        }
        
        self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:JGActionSheetAlertArrayToVa_list(tmpOthers)];
        
        //iOS7 asset 问题
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.alertView show];
        });
        
        return self.alertView;
    }
}

/** Actionsheet 区分iOS7及以下与之后系统 */
- (id)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel destructive:(NSString *)destructive others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    if ([UIAlertController class]) {
        
        return [self showAlertWithTitle:title message:nil style:UIAlertControllerStyleActionSheet cancel:cancel destructive:destructive others:others action:action];
    }
    else {
        
        UIViewController *topVC = [[UIApplication sharedApplication] applicationTopViewControllerExcludeAlert:YES];
        if (!topVC) {
            return nil;
        }
        
        self.actionBlock = action;
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:destructive otherButtonTitles:JGActionSheetAlertArrayToVa_list(others)];
        [sheet setActionSheetStyle:UIActionSheetStyleAutomatic];
        [sheet showInView:topVC.view];
        
        return sheet;
    }
}

/** Alert Actionsheet iOS8及以上系统统一处理 */
- (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style cancel:(NSString *)cancel destructive:(NSString *)destructive others:(NSArray<NSString *> *)others action:(JGActionSheetAlertAction)action {
    
    UIViewController *topVC = [[UIApplication sharedApplication] applicationTopViewController];
    if (!topVC) {
        return nil;
    }
    
    self.actionBlock = action;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (cancel) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.actionBlock) {
                
                strongSelf.actionBlock(strongSelf, [strongSelf cancelIndex]);
                strongSelf.actionBlock = nil;
            }
        }];
        
        [alert addAction:cancelAction];
    }
    
    if (destructive) {
        
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructive style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.actionBlock) {
                
                strongSelf.actionBlock(strongSelf, [strongSelf destructiveIndex]);
                strongSelf.actionBlock = nil;
            }
        }];
        
        [alert addAction:destructiveAction];
    }
    
    for (NSUInteger i = 0; i < [others count]; i++) {
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:others[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.actionBlock) {
                
                strongSelf.actionBlock(strongSelf, [strongSelf firstOtherIndex] + i);
                strongSelf.actionBlock = nil;
            }
        }];
        
        [alert addAction:otherAction];
    }
    
    if (alert.popoverPresentationController) {
        
        [alert.popoverPresentationController setSourceView:topVC.view];
        [alert.popoverPresentationController setSourceRect:topVC.view.bounds];
        [alert.popoverPresentationController setPermittedArrowDirections:(UIPopoverArrowDirection)0];
    }
    
    if ([topVC isKindOfClass:[UIAlertController class]]) {
        
        [topVC dismissViewControllerAnimated:NO completion:^{
            
            UIViewController *newVc = [[UIApplication sharedApplication] applicationTopViewController];
            [newVc presentViewController:alert animated:YES completion:nil];
        }];
    }
    else {
        
        [topVC presentViewController:alert animated:YES completion:nil];
    }
    
    return alert;
}

#pragma mark - UIAlertViewDelegate
- (void)alertViewCancel:(UIAlertView *)alertView {
    
    self.alertView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger actionIndex = JGActionSheetAlertCancelIndex;
    if (buttonIndex >= [alertView firstOtherButtonIndex]) {
        
        if (self.alertDestructiveTitle) {
            
            if (buttonIndex == [alertView firstOtherButtonIndex]) {
                
                actionIndex = JGActionSheetAlertDestructiveIndex;
            }
            else {
                
                actionIndex = JGActionSheetAlertFirstOtherIndex + (buttonIndex - [alertView firstOtherButtonIndex]) - 1;
            }
        }
        else {
            
            actionIndex = JGActionSheetAlertFirstOtherIndex + (buttonIndex - [alertView firstOtherButtonIndex]);
        }
    }
    else {
        
        actionIndex = JGActionSheetAlertCancelIndex;
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(self, actionIndex);
        self.actionBlock = nil;
    }
    
    self.alertView = nil;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    NSInteger actionIndex = JGActionSheetAlertCancelIndex;
    if (buttonIndex >= [actionSheet firstOtherButtonIndex]) {
        
        actionIndex = JGActionSheetAlertFirstOtherIndex + (buttonIndex - [actionSheet firstOtherButtonIndex]);
    }
    else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        
        actionIndex = JGActionSheetAlertDestructiveIndex;
    }
    else {
        
        actionIndex = JGActionSheetAlertCancelIndex;
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(self, actionIndex);
        self.actionBlock = nil;
    }
}

#pragma mark - End

@end

@implementation UIApplication (JGActionSheetAlert)

#pragma mark - Controller
- (UIViewController *)applicationTopViewController {
    
    return [self applicationTopViewControllerExcludeAlert:NO];
}

- (UIViewController *)applicationTopViewControllerExcludeAlert:(BOOL)exclude {
    
    UIViewController *topVC = [self topVCWithViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (topVC.presentedViewController) {
        
        UIViewController *presented = topVC.presentedViewController;
        if (exclude && [presented isKindOfClass:[UIAlertController class]]) {
            
            break;
        }
        
        topVC = [self topVCWithViewController:presented];
    }
    
    return topVC;
}

- (UIViewController *)topVCWithViewController:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self topVCWithViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self topVCWithViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else {
        
        return vc;
    }
}

- (UINavigationController *)applicationTopNavigationController {
    
    UINavigationController *topNav = [self applicationTopViewController].navigationController;
    if (!topNav) {
        
        UIViewController *topVC = [self topVCWithViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
        while (topVC && [topVC isKindOfClass:[UINavigationController class]]) {
            
            topNav = (UINavigationController *)topVC;
        }
    }
    
    return topNav;
}

#pragma mark - End

@end
