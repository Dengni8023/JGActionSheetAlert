//
//  TableViewController.m
//  JGActionSheetAlert
//
//  Created by 梅继高 on 2017/5/10.
//  Copyright © 2017年 MEETStudio. All rights reserved.
//

#import "TableViewController.h"
#import "JGActionSheetAlert.h"

#ifndef CLog
#define CLog(format, ...) (NSLog)((@"%s Line:%zd " format), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#endif

@interface TableViewController ()

@end

@implementation TableViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 7;
            break;
            
        case 1:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: {
            
            NSString *titles[7] = {
                @"Alert",
                @"Alert With Action",
                @"Alert With Other",
                @"Alert With Destructive",
                @"Alert With Others",
                @"Alert With Destructive And Others",
                @"Alert With Click Alert",
            };
            
            [cell.textLabel setText:titles[indexPath.row]];
        }
            break;
            
        case 1: {
            
            NSString *titles[3] = {
                @"Action Sheet",
                @"Action Sheet With Destructive",
                @"Action Sheet With Click Alert",
            };
            
            [cell.textLabel setText:titles[indexPath.row]];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Alert";
            break;
            
        case 1:
            return @"Action Sheet";
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0: {
            
            switch (indexPath.row) {
                case 0: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel"];
                }
                    break;
                    
                case 1: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 2: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" other:@"Other" action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 3: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" destructive:@"Destructive" action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 4: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" others:@[@"Other 1", @"Other 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 5: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Other 1", @"Other 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 6: {
                    
                    [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Other 1", @"Other 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Other 1", @"Other 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                            
                            CLog(@"Tap button : %zd", actionIndex);
                        }];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            
            switch (indexPath.row) {
                case 0: {
                    
                    [JGActionSheetAlert showActionSheetWithTitle:@"Title" cancel:@"Cancel" others:@[@"Action 1", @"Action 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 1: {
                    
                    [JGActionSheetAlert showActionSheetWithTitle:@"Title" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Action 1", @"Action 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        CLog(@"Tap button : %zd", actionIndex);
                    }];
                }
                    break;
                    
                case 2: {
                    
                    [JGActionSheetAlert showActionSheetWithTitle:@"Title" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Action 1", @"Action 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                        
                        [JGActionSheetAlert showAlertWithTitle:@"Title" message:@"Message" cancel:@"Cancel" destructive:@"Destructive" others:@[@"Other 1", @"Other 2"] action:^(JGActionSheetAlert * _Nonnull actionSheetAlert, NSInteger actionIndex) {
                            
                            CLog(@"Tap button : %zd", actionIndex);
                        }];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
