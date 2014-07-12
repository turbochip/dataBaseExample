//
//  DBEViewController.h
//  dataBaseExample
//
//  Created by Chip Cox on 7/11/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBETableViewController.h"

@interface DBEViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (nonatomic,strong) UIManagedDocument *document;
@property (nonatomic,strong) NSURL *url;

- (void)documentIsReady;

@end
